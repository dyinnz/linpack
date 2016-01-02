CC     = icc
FLAGS  =

# ** generate optimization report
FLAGS+=-qopt-report=3

# ** -O[n] level; -Os would be default enabled in -O1
# FLAGS += -Os
 FLAGS += -O1
# FLAGS += -O2
# FLAGS += -O3
# FLAGS += -fast

# ** target architecture
 FLAGS += -xHost

# ** interprocedural optimization
# FLAGS += -ipo

# * profile guide optimization
# FLAGS += -prof-gen
# FLAGS += -prof-use

# ** builtin function provided by compiler
# FLAGS += -fbuiltin

# ** inline function for possible; -O2/-O3/-Ofast + -finline takes effect,
# -O1 + -finline takes little effect
# FLAGS += -finline

# * math presicion
# FLAGS += -no-prec-div
# FLAGS += -fp-model fast=2

# ** set no pointer alias
# FLAGS += -fno-alias -fargument-noalias -fargument-noalias-global

# if using raw c source file, turn this on because of core dump
# FLAGS += -no-vec

# no much effect
# FLAGS += -unroll
# FLAGS += -funroll-all-loops
# FLAGS += -unroll-aggressive

# use static libraries
# FLAGS += -static

# * all about prefetch, may take effect
# FLAGS += -qopt-prefetch=2
# FLAGS += -qopt-prefetch-issue-excl-hint
# 
# others 
# FLAGS += -qopt-subscript-in-range
# FLAGS += -falign-functions
# FLAGS += -ffunction-sections
# FLAGS += -hotpatch

################################################################################
#### Intel Libary

# intel matrix multiply libraries
# FLAGS += -qopt-matmul

# intel integrated performance primitives
# FLAGS += -ipp
# FLAGS += -ipp-link=static

# intel math kernel libary
# FLAGS += -mkl
# FLAGS += -static-intel

# FLAGS += -use-intel-optimized-headers

################################################################################

SP_ROLL   = -DSP -DROLL
SP_UNROLL = -DSP -DUNROLL
DP_ROLL   = -DDP -DROLL
DP_UNROLL = -DDP -DUNROLL
 
linpack: linpack.c makefile
	${CC} $< -o sp_unroll ${FLAGS} ${SP_UNROLL}
	@ echo '-----------------------------------------------------' >> Linpack.txt
	@ date >> Linpack.txt
	@ echo 'FLAGS:' ${FLAGS} >> Linpack.txt

.PHONY: clean
clean:
	rm -f sp_roll sp_unroll dp_roll dp_unroll

