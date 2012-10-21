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

<<<<<<< HEAD
=======
/**
void AdjMapToMatrix(g::adjmap & graph, 
	float * VertexArray,
	float * WeightArray);
**/
>>>>>>> origin/zerosign

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
<<<<<<< HEAD
	bool * MaskArray;

	cudaEvent_t start, stop;
=======
	
	VertexArray = malloc(sizeof(

	AdjMapToMatrix(graph, VertexArray, WeightArray);

>>>>>>> origin/zerosign

	return 0;
}


