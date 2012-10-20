#ifndef DEFS_H
#define DEFS_H

#include <vector>
#include <map>
#include <string>
#include <limits>
#include <list>

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

	typedef std::map<vertex_t, weight_t> edges;
	typedef std::map<vertex_t, vertex_t> relations;
	typedef std::list<vertex_t> path;

	typedef std::map<vertex_t, 
			  std::vector<neighbor> > adjmap;
	
	typedef std::pair<vertex_t, 
			  std::vector<neighbor> > adjmap_it;

	template <typename vertex_type>
		void to_string(g::path&, 
			std::string&);
};

#endif // defs.h
