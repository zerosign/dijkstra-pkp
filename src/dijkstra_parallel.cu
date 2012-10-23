#include <cstdio>
#include <cuda.h>
#include <list>
#include "file.h"


#define BUFFSIZE 100

typedef struct Memory {
	float * Host, * Device;
	operator()(int N) {
		Host = (float*)malloc(sizeof(N));
		cudaMalloc((void**)&Device, N);
	}
	operator~() {
		free(Host);
		cudaFree(Device);
	}
};

void read(const char * filename, int & vertexSize,
	struct Memory& weights) {
		
	std::ifstream input(std::string(filename).c_str());
	
	if(!input.good()) {
		std::fprintf(stderr, "[ERROR] No such file %s\n", 
				std::string(filename).c_str());
		exit(EXIT_FAILURE);
	}
	char * buffer = new char[BUFFSIZE];

	input.getline(buffer, BUFFSIZE);
		
	//int num_vertices, num_edges;

	int edgeSize;

	std::sscanf(buffer, "%d\t%d\n", &vertexSize,
			&edgeSize);


	//VertexArray = (int*)malloc(sizeof(int)*num_vertices);	
	//WeightArray = (float*)malloc(sizeof(float)*(num_vertices*num_vertices));
	
	weights = Memory(vertexSize * vertexSize * sizeof(float));

	//for(int ii = 0; ii < num_vertices; ii++) {
	//	VertexArray[ii] = ii;
	//}

	for(int ii = 0; ii < edgeSize; ii++) {
		int start, end;
		float weight;
		//sstream >> start >> end >> weight;
		buffer = new char[BUFFSIZE];

		input.getline(buffer, BUFFSIZE);
	
		std::sscanf(buffer, "%d\t%d\t%f\n", &start,
				&end, &weight);

		weights.Host[start * vertexSize + end ] = weight;
		weights.Host[end * vertexSize + start] = weight;
	}
	
	input.close();
	
}



int main(int argc, char ** argv) {
	
	const char * filename = argv[1];

	int start, end, N;

	start = std::atoi(argv[2]);
	end = std::atoi(argv[3]);

	dim3 gridDim, blockDim;

	struct Memory WeightArray;
	
	io::file::read(filename, N, WeightArray);
	
	gridDim.x = N;
	blockDim.x = N;

	for(int ii = 0; ii < N; ii++) {
		for(int jj = 0; jj < N; jj++) {
			std::printf("%f ", WeightArray.Host[ii * vertexSize + jj]);
		}
		std::printf("\n");
	}



	return 0;
}
