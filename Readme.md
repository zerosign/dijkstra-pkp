# README #

## Description ##

Every binary output comes out into bin/ folder and the data comes out to be data/ folder.

Use of the "sampler" app :

	./sampler [output_file] [vertices_N] [start_weight] [weight]

The sample output of "output_file" should be formatted like :

	[number_of_vertices]\t[number_of_edges]
	[edge#1(start\tend\tweight)]
	[edge#2]
	[edge#3]
	...
	...
	...
	[edge#N]

Or use `make sample` to automatically generate the sample for test later on. It uses
scripts inside scripts folder.

## Pseudocode ##

Pseudocode for this single & parallel dijkstra :


### Dijkstra Single Search Path (CPU) ###



### Dijkstra Single Search Path (Parallel GPU) ###


## Test samples ##

The samples generated automatically and randomly. The generated function to generate
the sample :

	


References : need to be added soon


# END OF README #
