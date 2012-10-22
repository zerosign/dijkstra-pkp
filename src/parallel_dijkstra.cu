#include <cstdio>
//#include <cuda.h>
#include <cstdlib>
#include <list>
#include <sstream>
#include <iterator>
#include <iostream>
#include "defs.h"
#include "file.h"

__device__ int index() {
	return blockIdx.x * blockDim.x + threadIdx.x;
}

__device__ int x(int index) {
	return index;
}

__device__ int y(int index) {
	return index;
}

__global__ void first_cuda_ssp_kernel(int * VertexArray,
		float * WeightArray, int * MaskArray, float * CostArray, 
		float * UpdateCostArray) {
	
	int id = index();
	
	if(MaskArray[id] == 1) {
		MaskArray[id] = 0;
		
		int vertex = x(id);
		int neighborSize = y(blockDim.x);

		for(int ii = 0; ii < neighborSize; ii++) {
			
			if(y(id) == ii) 
				continue;

			int nid = id * neighborSize + ii;
			
			if(UpdateCostArray[nid] > CostArray[id] + WeightArray[nid]) {
				UpdateCostArray[nid] = CostArray[id] + WeightArray[nid];
			}
		}

	}

}	



__global__ void second_cuda_ssp_kernel(int * VertexArray,
		float * WeightArray, int * MaskArray, float * CostArray,
		float * UpdateCostArray) {
	int id = index();

	// Update the cost array
	if(CostArray[id] > UpdateCostArray[id]) {
		CostArray[id] = UpdateCostArray[id];
		MaskArray[id] = 1;
	}
	UpdateCostArray[id] = CostArray[id];
}

bool is_empty(int * MaskArrayHost, int size) {
	bool not_empty = false;
	for(int ii = 0; ii < size; ii++) {
		not_empty |= (MaskArrayHost[ii] == 1) ? (true) : (false);
		if(not_empty)
			return false;
	}
	return !not_empty;
}

std::list<int> get_shortest_path(float * CostArray, 
		const int source, const int target,
		const int vertexSize,
		int & finalCost);

int main(int argc, char ** argv) {
	
	if(argc != 4) {
		std::fprintf(stderr, "\n[Usage] : %s [filename] [start] [end] [outfile]\n", 
			std::string(argv[0]).c_str());
		exit(EXIT_FAILURE);
	}

	const char * filename = argv[1];

	int start, end;

	start = std::atoi(argv[2]);
	end = std::atoi(argv[3]);


	dim3 gridDim, blockDim;
	//g::adjmap graph;

	//g::reader::read(std::string(filename).c_str(), graph);


	// untuk VertexArray sizenya adalah size of vertex
	// untuk MaskArray sizenya adalah size of vertex (dilihat dari distance yang ingin diubah)
	int * VertexArrayHost, * VertexArrayDevice, 
		 * MaskArrayHost, * MaskArrayDevice;

	float * WeightArrayHost, * WeightArrayDevice,
			* CostArrayHost, * CostArrayDevice, 
			* UpdateCostArrayHost, * UpdateCostArrayDevice;

	int vertexSize = 0;

	io::file::read(filename, vertexSize,
			VertexArrayHost, WeightArrayHost);

	if(vertexSize < 2) {
		std::fprintf(stderr, "\n[ERROR] Anomaly in VertexSize\n");
		exit(EXIT_FAILURE);
	}


	// RAW copy from vertex matrix to block
	gridDim.x = vertexSize;
	blockDim.x = vertexSize;
	
	/**
	for(int ii = 0; ii < vertexSize; ii++) {
		for(int jj = 0; jj < vertexSize; jj++) {
			std::printf("%f ", WeightArrayHost[ii * vertexSize + jj]);
		}
		std::printf("\n");
	}
	**/

	const int rawVertexSize = vertexSize * sizeof(float);
	const int rawMatrixSize = rawVertexSize * rawVertexSize;

	// Cost array is used for counting
	// cost of given source to target
	CostArrayHost = (float*)malloc(rawVertexSize);

	// temporary cost array for counting 
	// cost from the previous vertex to current 
	// vertex
	// 
	// If it's smaller than CostArray then it's switched
	UpdateCostArrayHost = (float*)malloc(rawVertexSize);	
	
	MaskArrayHost = (int*)malloc(rawVertexSize);

	for(int ii = 0; ii < vertexSize; ii++) {
		CostArrayHost[ii] = std::numeric_limits<int>::max();
		UpdateCostArrayHost[ii] = std::numeric_limits<int>::max();
	}
	
	cudaMalloc((void**)&VertexArrayDevice, rawVertexSize);
	cudaMalloc((void**)&WeightArrayDevice, rawMatrixSize);
	cudaMalloc((void**)&CostArrayDevice, rawVertexSize);
	cudaMalloc((void**)&UpdateCostArrayDevice, rawVertexSize);
	
	// MaskArray is used for determining that the vertex
	// is already been visited or not
	cudaMalloc((void**)&MaskArrayDevice, rawVertexSize);
	
	MaskArrayHost[start] = 1;
	CostArrayHost[start] = 0;
	UpdateCostArrayHost[start] = 0;


	cudaMemcpy(VertexArrayDevice, VertexArrayHost, 
			rawVertexSize, cudaMemcpyHostToDevice);
	
	cudaMemcpy(WeightArrayDevice, WeightArrayHost,
			rawMatrixSize, cudaMemcpyHostToDevice);

	cudaMemcpy(CostArrayDevice, CostArrayHost,
			rawVertexSize, cudaMemcpyHostToDevice);
	
	cudaMemcpy(UpdateCostArrayDevice, UpdateCostArrayHost,
			rawVertexSize, cudaMemcpyHostToDevice);
	
	// freeing big memory that not been used
	// anymore because already copied to device
	free(UpdateCostArrayHost);
	free(WeightArrayHost);
	free(VertexArrayHost);
	
	
	
	while(!is_empty(MaskArrayHost, vertexSize * vertexSize)) {
		for(int ii = 0; ii < vertexSize; ii++) {
			
			first_cuda_ssp_kernel<<<gridDim, blockDim >>>(VertexArrayDevice, 
					WeightArrayDevice, MaskArrayDevice, CostArrayDevice,
					UpdateCostArrayDevice);

			second_cuda_ssp_kernel<<<gridDim, blockDim >>>(VertexArrayDevice,
					WeightArrayDevice, MaskArrayDevice, CostArrayDevice,
					UpdateCostArrayDevice);
		}

		// update the masks
		cudaMemcpy(MaskArrayHost, MaskArrayDevice, 
				rawVertexSize, cudaMemcpyDeviceToHost);
	}
	
	
	cudaMemcpy(CostArrayHost, CostArrayDevice, rawVertexSize, 
			cudaMemcpyDeviceToHost);
	
	
	int finalCost = 0;

	std::list<int> result = get_shortest_path(CostArrayHost, 
			start, end, vertexSize, finalCost);

	std::stringstream sstream(std::stringstream::in |
			std::stringstream::out);

	std::copy(result.begin(), result.end(), 
			std::ostream_iterator<g::vertex_t>(sstream, "->"));	
	
	std::string out;

	//while(!sstream.eof()) 
	//	sstream >> out;
	out = sstream.str();
	
	std::cout << "Path : \n" << out << "end" << std::endl;
	
	return 0;
}


std::list<int> get_shortest_path(float * CostArray, 
		const int source, const int target,
		const int vertexSize, int & finalCost) {
	std::list<int> result;
	
	
	return result;
}
