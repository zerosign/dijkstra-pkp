#include <cstdio>
#include <cuda.h>
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
		
		int vertex = x(index);
		int neighborSize = y(blockDim.x);

		for(int ii = 0; ii < neighborSize; ii++) {
			
			if(y(id) == ii) 
				continue;

			int nid = index * neighborSize + ii;
			
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

	int * VertexArrayHost, * VertexArrayDevice, 
		 * MaskArrayHost, * MaskArrayDevice;

	float * WeightArrayHost, * WeightArrayDevice,
			* CostArrayHost, * CostArrayDevice, 
			* UpdateCostArrayHost, * UpdateCostArrayDevice;

	int vertexSize = 1;

	io::file::read(filename, vertexSize,
			VertexArrayHost, WeightArrayHost);

	gridDim.x = vertexSize;
	blockDim.x = vertexSize;

	const int rawVertexSize = vertexSize * sizeof(float);
	const int rawMatrixSize = rawVertexSize * rawVertexSize;

	CostArrayHost = (float*)malloc(rawVertexSize);
	UpdateCostArrayHost = (float*)malloc(rawVertexSize);	
	
	for(int ii = 0; ii < vertexSize; ii++) {
		CostArrayHost[ii] = std::numeric_limits<int>::max();
		UpdateCostArrayHost[ii] = std::numeric_limits<int>::max();
	}
	
	cudaMalloc((void**)&VertexArrayDevice, rawVertexSize);
	cudaMalloc((void**)&WeightArrayDevice, rawMatrixSize);
	cudaMalloc((void**)&CostArrayDevice, rawVertexSize);
	cudaMalloc((void**)&UpdateCostArrayDevice, rawVertexSize);
	
	// malloc default set it to zero (we call this as a false)
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

	return 0;
}


