#include "defs.h"
#include <limits>
#include <map>
#include <vector>

namespace g {
	
	// define the MAX WEIGHT
	const int MAX_WEIGHT = 
		std::numeric_limits<int>::max();

	void to_string(path& results,
				std::string& str_out) {
		for(auto &p : results) {
			str_out.append(p + " ");
		}
	}

};


