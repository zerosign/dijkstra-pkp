#include "file.h"

#define BUFFSIZE 100

namespace io {
	
				
	file::file() {}
		
	void file::read(const char * filename, 
			g::adjmap& adjmap) {
		
		std::ifstream input(std::string(filename).c_str());
		
		if(!input.good()) {
			std::fprintf(stderr, "[ERROR] No such file %s\n", 
					std::string(filename).c_str());
			exit(EXIT_FAILURE);
		}
		char * buffer = new char[BUFFSIZE];

		input.getline(buffer, BUFFSIZE);
		
		int num_vertices, num_edges;
		
		std::sscanf(buffer, "%d\t%d\n", &num_vertices,
				&num_edges);

	
	//	std::printf("V : %d, E : %d\n", num_vertices, num_edges);

		//sstream >> num_vertices >> num_edges;
		
		for(int ii = 0; ii < num_edges; ii++) {
			int start, end;
			float weight;
			//sstream >> start >> end >> weight;
			buffer = new char[BUFFSIZE];

			input.getline(buffer, BUFFSIZE);
		
			std::sscanf(buffer, "%d\t%d\t%f\n", &start,
					&end, &weight);

			adjmap[start].push_back(g::neighbor(end, weight));
			adjmap[end].push_back(g::neighbor(start, weight));
		}

	
		input.close();
	}

	void file::read(const char * filename, int & vertexSize,
			int *& VertexArray, float *& WeightArray) {
			
		std::ifstream input(std::string(filename).c_str());
		
		if(!input.good()) {
			std::fprintf(stderr, "[ERROR] No such file %s\n", 
					std::string(filename).c_str());
			exit(EXIT_FAILURE);
		}
		char * buffer = new char[BUFFSIZE];

		input.getline(buffer, BUFFSIZE);
		
		int num_vertices, num_edges;
		
		std::sscanf(buffer, "%d\t%d\n", &num_vertices,
				&num_edges);

		VertexArray = (int*)malloc(sizeof(int)*num_vertices);	
		WeightArray = (float*)malloc(sizeof(float)*(num_vertices*num_vertices));
		
		for(int ii = 0; ii < num_vertices; ii++) {
			VertexArray[ii] = ii;
		}

		for(int ii = 0; ii < num_edges; ii++) {
			int start, end;
			float weight;
			//sstream >> start >> end >> weight;
			buffer = new char[BUFFSIZE];

			input.getline(buffer, BUFFSIZE);
		
			std::sscanf(buffer, "%d\t%d\t%f\n", &start,
					&end, &weight);

			WeightArray[start * num_vertices + end ] = weight;
		}

	
		input.close();
	
	}

	void file::write(const char * filename,
		std::string output) {

	}
	
};
