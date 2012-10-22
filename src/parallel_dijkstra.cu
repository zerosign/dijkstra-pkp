#include <cstdio>
#include <cuda.h>
#include "defs.h"
#include "reader.h"



__device__ int index() {
	return blockIdx.x * blockDim.x + threadIdx.x;
}

__device__ int x(int index) {
	return index;
}

__device__ int y(int index) {
	return index;
}

__global__ void first_cuda_ssp_kernel() {
	
}

__global__ void second_cuda_ssp_kernel() {

}

/**
void AdjMapToMatrix(g::adjmap & graph, 
	float * VertexArray,
	float * WeightArray);
**/

int main(int argc, char ** argv) {
	
	if(argc != 4) {
		std::fprintf(stderr, "\n[Usage] : %s [filename]\n", 
			std::string(argv[0]).c_str());
	}

	const char * filename = argv[1];

	//g::adjmap graph;

	//g::reader::read(std::string(filename).c_str(), graph);

	int * VertexArray, * EdgeArray, * MaskArray;
	float * WeightArray, * CostArray, * UpdateCostArray;
	
	VertexArray = malloc(sizeof(

	AdjMapToMatrix(graph, VertexArray, WeightArray);


	return 0;
}


