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
		exit(EXIT_FAILURE);
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

	int vertexSize = 1;

	io::file::read(filename, vertexSize,
			VertexArrayHost, WeightArrayHost);

	CostArrayHost = (float*)malloc(vertexSize * sizeof(float));
	UpdateCostArrayHost = (float*)malloc(vertexSize * sizeof(float));
	
	
	for(int ii = 0; ii < vertexSize; ii++) {
		CostArrayHost[ii] = std::numeric_limits<int>::max();
		UpdateCostArrayHost[ii] = std::numeric_limits<int>::max();
	}

	
	cudaMalloc((void**)&VertexArrayDevice, vertexSize * sizeof(float));
	cudaMalloc((void**)&WeightArrayDevice, vertexSize * vertexSize * sizeof(float) * sizeof(float));
	cudaMalloc((void**)&CostArrayDevice, vertexSize * sizeof(float));
	cudaMalloc((void**)&UpdateCostArrayDevice, vertexSize * sizeof(float));
	
	// malloc default set it to zero (we call this as a false)
	cudaMalloc((void**)&MaskArray, vertexSize * sizeof(float));
	
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


