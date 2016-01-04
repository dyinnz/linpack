CC     = icc
FLAGS  =

# ** generate optimization report
FLAGS+=-qopt-report=3

# ** -O[n] level; -Os would be default enabled in -O1
# FLAGS += -Os
# FLAGS += -O1
# FLAGS += -O2
 FLAGS += -O3
# -fast = -ipo, -O3, -no-prec-div, -static, -fp-model fast=2, -xHost
# FLAGS += -fast

# *** target architecture
 FLAGS += -xHost

# * profile guide optimization
# FLAGS += -prof-gen
# FLAGS += -prof-use

# ** interprocedural optimization
 FLAGS += -ipo

# ** inline function for possible;
# -O1 -finline: takes little effect
# -O2/-O3 -finline: Address boundary error ? 
# -O2/-O3/-Ofast -finline: takes effect, and other option?
 FLAGS += -finline

# ** builtin function provided by compiler; do not effects others
 FLAGS += -fbuiltin

# * math presicion
 FLAGS += -no-prec-div
 FLAGS += -fp-model fast=2

# *** set no pointer alias; do not effects others
 FLAGS += -fno-alias -fargument-noalias -fargument-noalias-global
# *** what the fuck ?
 FLAGS += -qopt-subscript-in-range
# **  what the fuck ?
 FLAGS += -falign-functions

# if using raw c source file, turn this on because of core dump
# FLAGS += -no-vec

# no much effect
# FLAGS += -unroll-aggressive
# FLAGS += -funroll-all-loops

# use static libraries
# FLAGS += -static

# * all about prefetch, may take effect
 FLAGS += -qopt-prefetch
# FLAGS += -qopt-prefetch-issue-excl-hint
# 
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

FLAGS += -parallel

SP_ROLL   = -DSP -DROLL
SP_UNROLL = -DSP -DUNROLL
DP_ROLL   = -DDP -DROLL
DP_UNROLL = -DDP -DUNROLL

TYPE = ${SP_ROLL}

linpack: linpack.c makefile
	${CC} $< -o sp_unroll ${FLAGS} ${TYPE}
	@ echo '-----------------------------------------------------' >> Linpack.txt
	@ date >> Linpack.txt
	@ echo 'TYPE: ' ${TYPE} >> Linpack.txt
	@ echo 'FLAGS: icc ' ${FLAGS} >> Linpack.txt

VTUNE = -O1 -fno-inline -fno-inline-functions

vtune: linpack.c makefile
	${CC} $< -o vtune ${VTUNE} ${TYPE}
	@ echo '-----------------------------------------------------' >> Linpack.txt
	@ date >> Linpack.txt
	@ echo 'TYPE: ' ${TYPE} >> Linpack.txt
	@ echo 'FLAGS: icc ' ${VTUNE} >> Linpack.txt

.PHONY: clean
clean:
	rm -f sp_roll sp_unroll dp_roll dp_unroll

