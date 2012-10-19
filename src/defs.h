#ifndef DEFS_H
#define DEFS_H

#include <vector>
#include <map>
#include <string>
#include <limits>

namespace g {

	typedef int vertex_t;
	typedef float weight_t;

	extern "C++" const int MAX_WEIGHT;
	
	//extern "C++" struct neighbor;

	struct neighbor {
		vertex_t target;
		weight_t weight;

		neighbor(const vertex_t v, const weight_t w) :
			target(v), weight(w){
		}
	};

	typedef std::map<vertex_t, 
			  std::vector<neighbor> >  adjmap_t;
	
	template <typename vertex_type>
		void to_string(std::vector<vertex_type>&, 
			std::string&);
};

#endif // defs.h
