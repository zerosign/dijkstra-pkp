#!/bin/bash

if [ $2 == 'generate' ]
then 
	echo "Generating Samples.."
	#GENERATE()
	for ii in {1..15}
	do #$1 $3/sample_$((2**${ii})).data $((2**${ii})) 0 100;
		echo $1 $3/sample_$((2**${ii})).data $((2**${ii})) 0 100
		
		./$1 $3/sample_$((2**${ii})).data $((2**${ii})) 0 100
		
	done
	
	exit
fi

if [ $2 == 'test' ]
then
	echo "Test Over 15 Samples.."
	for ii in {1..15}
	do
		echo "Testing over "$((2**${ii}))" vertices"
		echo $1 $3/sample_$((2**${ii})).data 0 $((2**${ii}))
		./$1 $3/sample_$((2**${ii})).data 0 $((2**${ii}))
	done
	#TEST()
fi
