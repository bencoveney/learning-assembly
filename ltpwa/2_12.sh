#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 2_12_abscall.s -o ./output/2_12_abscall.o
# -static tells linker to statically link (aka physically incorporate the library).
# -lc tells linker to link with the c library.
ld ./output/2_12_abscall.o -static -lc -o ./output/2_12_abscall
./output/2_12_abscall
echo $?

# Using the C runtime is more complex.
# It is easier to use GCC (which knows about assembly) than assemble/link ourselves.
gcc 2_12_absmain.s -static -o ./output/2_12_absmain
./output/2_12_absmain
echo $?

# Note how linking the C runtime has ballooned the size of the executable.
ls -la ./output/2_12*

# Using the C runtime is more complex.
# It is easier to use GCC (which knows about assembly) than assemble/link ourselves.
gcc 2_12_filewrite.s -static -o ./output/2_12_filewrite
./output/2_12_filewrite
echo $?

cat ./output/myfile.txt

gcc 2_12_stdoutwrite.s -static -o ./output/2_12_stdoutwrite
./output/2_12_stdoutwrite
echo $?

# Excursion to C, to debug the issue I was having.
gcc 2_12_stdoutwrite.c -S -fverbose-asm -O2 -o ./output/2_12_stdoutwrite_c.s
gcc 2_12_stdoutwrite.c -static -o ./output/2_12_stdoutwrite_c
./output/2_12_stdoutwrite_c
echo $?

gcc 2_12_exponentscanf.s 2_11_exponentfunc.s -static -o ./output/2_12_exponentscanf
./output/2_12_exponentscanf
echo $?
