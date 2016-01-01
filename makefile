#CC=gcc
CC=icc
#CC=clang
FLAGS=
#FLAGS+=-no-vec
#FLAGS+=-no-simd
#FLAGS+=-O1  # -Os would be default enabled
#FLAGS+=-O2
FLAGS+=-O3
#FLAGS+=-fast
FLAGS+=-ipo    # mark
FLAGS+=-no-prec-div
FLAGS+=-fp-model fast=2
#FLAGS+=-static
FLAGS+=-xHost    # mark
FLAGS+=-fno-alias -fargument-noalias -fargument-noalias-global  # mark
FLAGS+=-qopt-prefetch=2    # mark
FLAGS+=-fbuiltin    # mark
#FLAGS+=-ffunction-sections
#FLAGS+=-hotpatch
FLAGS+=-unroll
FLAGS+=-funroll-all-loops
FLAGS+=-unroll-aggressive
#FLAGS+=-ipp -ipp-link=static
#FLAGS+=-mkl -static-intel
#FLAGS+=-ipp
#FLAGS+=-mkl
#FLAGS+=-qopt-matmul
#FLAGS+=-qopt-prefetch -qopt-prefetch-issue-excl-hint
#FLAGS+=-qopt-prefetch-issue-excl-hint
FLAGS+=-qopt-subscript-in-range
#FLAGS+=-use-intel-optimized-headers

#FLAGS+=-finline
#FLAGS+=-falign-functions

#FLAGS+=-Ofast 	# gcc, clang. compatibility in icc

#FLAGS+=-prof-gen
#FLAGS+=-prof-use

SP_ROLL=-DSP -DROLL
SP_UNROLL=-DSP -DUNROLL
DP_ROLL=-DDP -DROLL
DP_UNROLL=-DDP -DUNROLL
 
linpack: linpack.c makefile
	#${CC} $< -o sp_roll ${FLAGS} ${SP_ROLL}
	${CC} $< -o sp_unroll ${FLAGS} ${SP_UNROLL}
	#${CC} $< -o dp_roll ${FLAGS} ${DP_ROLL}
	#${CC} $< -o dp_unroll ${FLAGS} ${DP_UNROLL}

.PHONY: clean
clean:
	rm -f sp_roll sp_unroll dp_roll dp_unroll
