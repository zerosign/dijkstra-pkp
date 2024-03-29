#include <cstdio>
#include <cstdlib>
#include "defs.h"
#include "file.h"
#include <memory>
#include <set>
#include <vector>
#include <iostream>
#include <iterator>
#include <sstream>



void dijkstra_sp_cpu(g::vertex_t&, g::vertex_t&,
		const g::adjmap&, g::edges&,
		g::relations&);
	
void dijkstra_sp_cpu_result(
		g::vertex_t&, g::relations&,
		g::path &);

int main(int argc, char ** argv) {
	
	if(argc != 4) {
		std::printf("%s [graph_file] [start] [end] [outfile]\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	const char * filename = argv[1];
	
	g::edges distances;
	g::relations previous;
	g::path result;
	g::adjmap graph;

	clock_t read_begin = clock();	
	
	io::file::read(filename, graph);
	
	clock_t read_end = clock();

	g::vertex_t source, target;

	source = std::atoi(argv[2]);
	target = std::atoi(argv[3]);
	
	/**
	std::printf("Source : %d\n", source);
	std::printf("Target : %d\n", target);

	for(auto & g : graph) {
		std::printf("Vertex %d, Edge Size %ld\n", 
				g.first, g.second.size());
	}
	**/

	clock_t search_begin = clock();

	dijkstra_sp_cpu(source, target, graph, 
		distances, previous);
	
	clock_t search_end = clock();

	// std::printf("Sizeof relations : %ld\n", previous.size());

	/**/

	/**/

	clock_t search_result_begin = clock();

	dijkstra_sp_cpu_result(target, previous, result);
	
	clock_t search_result_end = clock();

	//std::string out = g::to_string(result);
	
	std::stringstream sstream(std::stringstream::in |
			std::stringstream::out);

	std::copy(result.begin(), result.end(), 
			std::ostream_iterator<g::vertex_t>(sstream, "->"));	
	
	std::string out;

	//while(!sstream.eof()) 
	//	sstream >> out;
	out = sstream.str();
	
	std::cout << "Path : \n" << out << "end" << std::endl;

	std::cout << "IO Read Time " << ((double) (double)read_end - (double)read_begin) << std::endl;
	std::cout << "SEARCH Time " << ((double) search_end - search_begin) << std::endl;
	std::cout << "SEARCH backtrack Time " << ((double) search_result_end - search_result_begin) << std::endl;
	//std::cout << out;
	//std::printf("\n\n[RESULT]\n\n%s\n\n", out.c_str());
	/**/
	return 0;
}


void dijkstra_sp_cpu(g::vertex_t& source, /*{{{*/
		g::vertex_t& target,
		const g::adjmap& graph, 
		g::edges &distances,
		g::relations &previous) {

	//std::printf("Sizeof Graph : %ld\n", graph.size());


	// init the the distances edges
	for(auto& it : graph) {
		g::vertex_t v = it.first;
		distances[v] = g::MAX_WEIGHT; // init as max value
		
		for(auto& n : it.second) {
			g::vertex_t v_target = n.target;
			distances[v_target] = g::MAX_WEIGHT; 

			//std::printf("V_BEGIN : %d, V_END : %d, D : %f\n", v,
			//	v_target, distances[v_target]);
			//std::printf("Target : %d\n", v_target);
		}
	}
	
	distances[source] = 0; // init the distance from source
							 // to source XD
					
	/**
	for(auto &e : distances) {
		std::printf("From source [%d], to target [%d], weight : %f\n", 
				source, e.first, e.second);
	}
	**/

	// at last I found the damn collection that fit
	std::set<std::pair<g::weight_t, g::vertex_t>> queue;
	
	//std::printf("%s\n", "Insert the source for the firstime");
	queue.insert(std::make_pair(distances[source], source));
	
	while(!queue.empty()) {
		g::vertex_t v_begin = queue.begin()->second;
		queue.erase(queue.begin());

		if(v_begin == target) {
			std::printf("%s\n", "[SUCCED] Target Founded.");
			break;
		}

		const std::vector<g::neighbor> neighbors = graph.find(v_begin)->second;
		
		//std::printf("Size of the neighbor : %ld\n", neighbors.size());

		for(auto& n : neighbors) {
			g::vertex_t v_end = n.target;
			g::weight_t w_end = n.weight;

			g::weight_t distance = distances[v_begin] + w_end;
			/**
			std::printf("Distance v_begin : %f\n" , distances[v_begin]);
			std::printf("w_end : %f\n" , w_end);
			std::printf("Distance v_end : %f\n" , distances[v_end]);
			std::printf("Distance : %f\n" , distance);
			**/
			if(distance < distances[v_end]) {
				queue.erase(std::make_pair(distances[v_end], v_end));
				distances[v_end] = distance;
				previous[v_end] = v_begin;
				queue.insert(std::make_pair(distances[v_end], v_end));
			}
		}
	}
	
}/*}}}*/

void dijkstra_sp_cpu_result(
		g::vertex_t& target, 
		g::relations & previous,
		g::path& result){

	/**
	for(auto & p : previous) {
		std::printf("Relation :  %d -> %d\n", p.first, p.second);
	}
	**/
	//std::map<g::vertex_t, g::vertex_t>::const_iterator s_path;
	g::relations::const_iterator s_path;
	
	g::vertex_t v_end = target;
	result.push_front(v_end);
	//std::printf("Finding  : %d\n", v_end);

	
	//auto v_begin = previous.find(v_end);
	
	//std::printf("%s\n", (v_begin != previous.end() ? "TRUE" : "FALSE"));
	

	while( (s_path = previous.find(v_end)) != previous.end() ) {
		//std::printf("V_END %d\n", s_path->second);
		v_end = s_path->second;
		result.push_front(v_end);
	}
	//std::printf("Size of result : %ld\n", result.size());

}



