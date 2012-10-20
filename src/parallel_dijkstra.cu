#include <cstdio>
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
	

	return 0;
}
