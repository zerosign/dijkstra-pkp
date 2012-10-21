#include <cstdio>
#include <cuda.h>
#include "defs.h"
#include "reader.h"

__device__ int thread_id() {
	return threadIdx.x;
}

__global__ void first_cuda_ssp_kernel() {
	
}	

__global__ void second_cuda_ssp_kernel() {
	
}


int main(int argc, char ** argv) {
	
	const char * filename = argv[1];

	std::adjmap graph;

	g::reader::read(filename, graph);

	int * VertexArray, * EdgeArray;
	float * WeightArray, * CostArray, * UpdateCostArray;
	bool * MaskArray;

	cudaEvent_t start, stop;

	return 0;
}
