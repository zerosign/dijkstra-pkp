#include <cstdio>
#include "defs.h"
#include "reader.h"
#include <memory>

void dijkstra_sp_cpu(g::vertex_t&, g::vertex_t&,
		const g::adjmap&, std::map<g::vertex_t, g::weight_t>&,
		std::map<g::vertex_t, g::weight_t>&);
	
std::vector<g::vertex_t> dijkstra_sp_cpu_result(
		g::vertex_t&, const std::map<vertex_t, vertex_t>&);

int main(int argc, char ** argv) {
	
	if(argc != 4) {
		std::printf("%s [graph_file] [start] [end]\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	const char * filename = argv[0];
	std::map<g::vertex_t, g::weight_t> edges;
	std::map<g::vertex_t, g::weight_t
	g::adjmap graph;

	io::reader::read(filename, graph);
	
	g::vertex_t source, target;

	dijkstra_sp_cpu(source, target, graph, 

	return 0;
}


void dijkstra_sp_cpu(g::vertex_t& source, g::vertex_t& target
		const g::adjmap& adjmap, 
		std::map<g::vertex_t, g::weight_t>& distances,
		std::map<g::vertex_t, g::weight_t>& prev_distances) {

	for(auto vertex : adjmap) {
		g::vertex_t v = vertex.first;
		distances[v] = g::MAX_WEIGHT; // init as max value
		for(auto edge : vertex.second) {
			g::vertex_t v_target = neighbor.target;
			distances[v_target] = g::MAX_WEIGHT; 
		}
	}
	distances[source] = 0; // init the distance from source
							 // to source XD
	
	// at last I found the damn collection that fit
	std::set<std::pair<g::weight_t, g::vertex_t>> queue;

	queue.insert(std::make_pair(distances[source], source));
	
	while(!queue.empty()) {

	}

}

std::vector<g::vertex_t> dijkstra_sp_cpu_result(
		g::vertex_t&, const std::map<vertex_t, vertex_t>&);

	
