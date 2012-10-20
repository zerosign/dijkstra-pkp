#include "defs.h"
#include <limits>
#include <map>
#include <vector>

namespace g {
	
	// define the MAX WEIGHT
	const int MAX_WEIGHT = 
		std::numeric_limits<int>::max();

	std::string to_string(path& results) {
		std::string out = "";
		for(vertex_t p : results) {
			//std::printf("%d\t", p);
			out += "\t" + p;
		}
		//std::printf("%s\n", str_out.c_str());
	}

};


