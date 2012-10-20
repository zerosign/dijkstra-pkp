#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include <ios>
#include <sstream>
#include <utility>
#include <set>

#define BUFFSIZE 100

float randomize(int start, int range);

int main(int argc, char ** argv) {
	
	srand(time(NULL));

	if(argc != 5) {
		std::fprintf(stderr, "\n\nUsage : %s [output] [vertices_N] "
						"[start_weight] [weight]\n\n", argv[0]);

		exit(EXIT_FAILURE);
	}

	std::ofstream out(std::string(argv[1]).c_str());
	
	int N = std::atoi(argv[2]);
	int start_weight = std::atoi(argv[3]);
	int range_weight = std::atoi(argv[4]);
	
	char * buffer = new char[BUFFSIZE];

	int size = std::snprintf( buffer, BUFFSIZE, "%d\t%d\n", N, (N-1) * (N) / 2 );

	out.write(buffer, size);
	
	out.flush();

	std::set<std::pair<int, int>> keys;
	
	for(int ii = 0; ii < N; ii++) {
		for(int jj = ii+1; jj < N; jj++) {
			/**
			if(keys.find(std::make_pair(ii, jj)) != keys.end()) {
				continue;
			}

			if(keys.find(std::make_pair(jj, ii)) != keys.end()) {
				continue;
			}
			**/
			// avoid edge loop
			//if(ii == jj) continue;
			
			float value = randomize(start_weight, range_weight); 
			int size = std::snprintf( buffer, BUFFSIZE, "%d\t%d\t%f\n", ii, jj, value);

			out.write(buffer, size);
			//sstream << ii << "\t" << jj << "\t" << value << "\n";
		}

		out.flush();
		// write every N loop
		//out << sstream.rdbuf();
	}
	
	out.close();

	return 0;
}


float randomize(int start, int range) {
	return start + rand() % range;
}
