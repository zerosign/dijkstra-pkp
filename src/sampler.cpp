#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include <ios>
#include <sstream>

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

	std::stringstream sstream (std::stringstream::in | 
			std::stringstream::out);

	sstream << N  << "\t" << ((N-1) * N )<< "\n";

	out << sstream.rdbuf();

	for(int ii = 0; ii < N; ii++) {
		for(int jj = 0; jj < N; jj++) {
			
			// avoid edge loop
			if(ii == jj) continue;
			
			float value = randomize(start_weight, range_weight); 
			
			sstream << ii << "\t" << jj << "\t" << value << "\n";
			
		}
		// write every N loop
		out << sstream.rdbuf();
	}

	out.close();

	return 0;
}


float randomize(int start, int range) {
	return start + rand() % range;
}
