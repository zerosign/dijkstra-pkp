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

__global__ void first_cuda_ssp_kernel(float * VertexArray,
		float * EdgeArray, float * WeightArray,
		float * MaskArray, float * CostArray, 
		float * UpdateCostArray) {
	
}	

__global__ void second_cuda_ssp_kernel() {
	
}


int main(int argc, char ** argv) {
	
	if(argc != 4) {
		std::fprintf(stderr, "\n[Usage] : %s [filename] [start] [end] [outfile]\n", 
			std::string(argv[0]).c_str());
	}

	const char * filename = argv[1];

	int start, end;

	start = std::atoi(argv[2]);
	end = std::atoi(argv[3]);

	//g::adjmap graph;

	//g::reader::read(std::string(filename).c_str(), graph);

	int * VertexArrayHost, * VertexArrayDevice,
		 * EdgeArray, * MaskArray;

	float * WeightArrayHost, * WeightArrayDevice,
			* CostArrayHost, * CostArrayDevice, 
			* UpdateCostArrayHost, * UpdateCostArrayDevice;

	int vertexSize;

	io::file::read(std::string(filename).c_str(), vertexSize
			VertexArrayHost, WeightArrayHost);

	CostArrayHost = (int*)malloc(vertexSize);
	UpdateCostArrayHost = (int*)malloc(vertexSize);
	
	
	for(int ii = 0; ii < vertexSize; ii++) {
		CostArrayHost[ii] = std::numeric_limits<int>::max();
		UpdateCostArrayHost[ii] = std::numeric_limits<int>::max();
	}

	
	cudaMalloc((void**)&VertexArrayDevice, vertexSize);
	cudaMalloc((void**)&WeightArrayDevice, vertexSize * vertexSize);
	cudaMalloc((void**)&CostArrayDevice, vertexSize);
	cudaMalloc((void**)&UpdateCostArrayDevice, vertexSize);
	
	// malloc default set it to zero (we call this as a false)
	cudaMalloc((void**)&MaskArray, vertexSize);
	
	/**
	MaskArrayHost[start] = 1;
	CostArrayHost[start] = 0;
	UpdateCostArrayHost[start] = 0;

	cudaMemcpy(VertexArrayDevice, VertexArrayHost, 
			size, cudaMemcpyHostToDevice);
	
	cudaMemcpy(WeightArrayDevice, WeightArrayHost,
			size, cudaMemcpyHostToDevice);

	cudaMemcpy(CostArrayDevice, CostArrayHost,
			size, cudaMemcpyHostToDevice);
	
	cudaMemcpy(UpdateCostArrayDevice, UpdateCostArrayHost,
			size, cudaMemcpyHostToDevice);

	while(true) {
	
	}
	**/
	return 0;
}


