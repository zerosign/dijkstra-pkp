#include <cstdio>
#include <cstdlib>
#include "defs.h"
#include "reader.h"
#include <memory>
#include <set>
#include <vector>

void dijkstra_sp_cpu(g::vertex_t&, g::vertex_t&,
		const g::adjmap&, g::edges&,
		g::relations&);
	
void dijkstra_sp_cpu_result(
		g::vertex_t&, g::relations&,
		g::path &);

int main(int argc, char ** argv) {
	
	if(argc != 4) {
		std::printf("%s [graph_file] [start] [end]\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	const char * filename = argv[1];
	
	g::edges distances;
	g::relations previous;
	g::path result;
	g::adjmap graph;

	
	io::reader::read(filename, graph);


	g::vertex_t source, target;

	source = std::atoi(argv[2]);
	target = std::atoi(argv[3]);

	dijkstra_sp_cpu(source, target, graph, 
			distances, previous);

	dijkstra_sp_cpu_result(source, previous, result);

	std::string result_str;

	//to_string(result, result_str);

	std::printf("\n\n[RESULT]\n\n%s\n\n", result_str.c_str());
	/**/
	return 0;
}


void dijkstra_sp_cpu(g::vertex_t& source, 
		g::vertex_t& target,
		const g::adjmap& adjmap, 
		g::edges &distances,
		g::relations &previous) {

	for(auto& it : adjmap) {
		g::vertex_t v = it.first;
		distances[v] = g::MAX_WEIGHT; // init as max value
		for(auto& n : it.second) {
			g::vertex_t v_target = n.target;
			distances[v_target] = g::MAX_WEIGHT; 
		}
	}

	distances[source] = 0; // init the distance from source
							 // to source XD
	
	// at last I found the damn collection that fit
	std::set<std::pair<g::weight_t, g::vertex_t>> queue;

	queue.insert(std::make_pair(distances[source], source));
	
	while(!queue.empty()) {
		g::vertex_t v_begin = queue.begin()->second;
		queue.erase(queue.begin());

		if(v_begin == target) {
			std::printf("%s\n", "[SUCCED] Target Founded.");
			break;
		}

		const std::vector<g::neighbor> neighbors = adjmap.find(v_begin)->second;

		for(auto& n : neighbors) {
			g::vertex_t v_end = n.target;
			g::weight_t w_end = n.weight;
			g::weight_t distance = distances[v_begin] + w_end;

			if(distance < distances[v_end]) {
				queue.erase(std::make_pair(distances[v_end], v_end));
				distances[v_end] = distance;
				previous[v_end] = v_begin;
				queue.insert(std::make_pair(distances[v_end], v_end));

			}
		}
	}

}

void dijkstra_sp_cpu_result(
		g::vertex_t& target, 
		g::relations & previous,
		g::path& result){
	
	
	//std::pair<g::vertex_t, g::vertex_t> s_path;
	g::relations::const_iterator s_path;

	g::vertex_t v_end = target;
	result.push_front(v_end);
	while( (s_path = previous.find(v_end)) != previous.end() ) {
		v_end = s_path->second;
		result.push_front(v_end);
	}
}



