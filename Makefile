SRC_FOLDER = './src'
BIN_FOLDER = './bin'
OBJ_FOLDER = './objects'



firsttime :
	mkdir -p $(SRC_FOLDER)
	mkdir -p $(OBJ_FOLDER)
	mkdir -p $(BIN_FOLDER)

defs.o : firsttime
	g++ -c $(SRC_FOLDER)/defs.cpp -o $(OBJ_FOLDER)/defs.o -Wall -g -O0

reader.o : firsttime defs.o
	g++ -c $(SRC_FOLDER)/reader.cpp -o $(OBJ_FOLDER)/reader.o -Wall -g -O0

sampler : firsttime
	g++ $(SRC_FOLDER)/sampler.cpp -o $(BIN_FOLDER)/sampler -Wall -g -O0

single_dijkstra_adjmap : firsttime defs.o reader.o
	g++ $(SRC_FOLDER)/single_dijkstra_adjmap.cpp $(OBJ_FOLDER)/defs.o $(OBJ_FOLDER)/reader.o -o \
		$(BIN_FOLDER)/single_dijkstra_adjmap -Wall -g -O0

	#nvcc parallel_dijkstra.cu -o parallel_dijkstra -Wall
	#g++ single_dijkstra_adjmat.cpp -o single_dijkstra_adjmat -Wall -g -O0

all : sampler single_dijkstra_adjmap
	

test : firsttime
	echo "Unimplemented"
clean : 
	rm -rf $(OBJ_FOLDER) $(BIN_FOLDER)
