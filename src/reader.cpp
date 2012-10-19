#include "reader.h"

namespace io {
	
	struct reader {
		reader() {}
		
		static void read(const char * filename, g::adjmap_t& adjmap) {
			std::ifstream input(std::string(filename).c_str());
			
			input.seekg(0, std::ios::end);
			long length = input.tellg();

			input.seekg(0, std::ios::beg);

			char buffer[length];

			input.read(buffer, length);
			std::istringstream sstream(std::string(buffer));


			int num_vertices, num_edges;
			
			
			//sstream >> num_vertices >> num_edges;
			for(int ii = 0; ii < num_edges; ii++) {
				int start, end;
				float weight;

				//sstream >> start >> end >> weight;

				adjmap[start].push_back(g::neighbor(end, weight));

			}
			

			input.close();
		}

		static void write(const char * filename,
				std::string output) {

		}
	};
	
};
