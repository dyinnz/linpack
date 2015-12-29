#CC=gcc
CC=icc
FLAGS=-DSP -DUNROLL -fast
#FLAGS=-DSP -DUNROLL -no-vec
#FLAGS=-no-vec
 
linpack: linpack.c
	${CC} $< -o $@ ${FLAGS}

.PHONY: clean
clean:
	rm -f linpack
