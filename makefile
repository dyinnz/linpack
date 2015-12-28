CC=gcc
FLAGS=

linpack: linpack.c
	${CC} $< -o $@ ${FLAGS}
