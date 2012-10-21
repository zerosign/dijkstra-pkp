SRC_FOLDER = './src'
BIN_FOLDER = './bin'
OBJ_FOLDER = './objects'
SAMPLES_FOLDER = './samples'
SCRIPTS_FOLDER = './scripts'
CXXFLAGS = -std=c++0x

all : sampler single_dijkstra_adjmap
	
firsttime :
	mkdir -p $(SRC_FOLDER)
	mkdir -p $(OBJ_FOLDER)
	mkdir -p $(BIN_FOLDER)
	mkdir -p $(SAMPLES_FOLDER)

defs.o : firsttime
	g++ -c $(SRC_FOLDER)/defs.cpp -o $(OBJ_FOLDER)/defs.o -Wall -g -O0 $(CXXFLAGS)

reader.o : firsttime defs.o
	g++ -c $(SRC_FOLDER)/reader.cpp -o $(OBJ_FOLDER)/reader.o -Wall -g -O0 $(CXXFLAGS)

sampler : firsttime
	g++ $(SRC_FOLDER)/sampler.cpp -o $(BIN_FOLDER)/sampler -Wall -g -O0 $(CXXFLAGS)

single_dijkstra_adjmap : firsttime defs.o reader.o
	g++ $(SRC_FOLDER)/single_dijkstra_adjmap.cpp $(OBJ_FOLDER)/defs.o $(OBJ_FOLDER)/reader.o -o $(BIN_FOLDER)/single_dijkstra_adjmap -Wall -g -O0 $(CXXFLAGS)

	#nvcc parallel_dijkstra.cu -o parallel_dijkstra -Wall
	#g++ single_dijkstra_adjmat.cpp -o single_dijkstra_adjmat -Wall -g -O0


sample : sampler
	#$((`for ii in {1..200}; do touch $(SAMPLES_FOLDER)/sample_${ii}.data ${ii} 0 100;  done`))
	#$((`echo Helloworld`)
	exec $(SCRIPTS_FOLDER)/script.sh $(BIN_FOLDER)/sampler generate $(SAMPLES_FOLDER)

test : firsttime single_dijkstra_adjmap
	exec $(SCRIPTS_FOLDER)/script.sh $(BIN_FOLDER)/single_dijkstra_adjmap test $(SAMPLES_FOLDER) $(OUT_FOLDER)

clean : 
	rm -rf $(OBJ_FOLDER) $(BIN_FOLDER) $(SAMPLES_FOLDER) 
