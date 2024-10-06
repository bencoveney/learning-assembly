#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 2_11_factorialstack.s -o ./output/2_11_factorialstack.o
ld ./output/2_11_factorialstack.o -o ./output/2_11_factorialstack
./output/2_11_factorialstack
echo $?

as 2_11_exponentfunc.s -o ./output/2_11_exponentfunc.o

as 2_11_runexponent.s -o ./output/2_11_runexponent.o
ld ./output/2_11_exponentfunc.o ./output/2_11_runexponent.o -o ./output/2_11_runexponent
./output/2_11_runexponent
echo $?

gcc 2_11_runexponent.c 2_11_exponentfunc.s -o ./output/2_11_runexponent2
./output/2_11_runexponent2
echo $?

as 2_11_factorialfunc.s -o ./output/2_11_factorialfunc.o

as 2_11_runfactorial.s -o ./output/2_11_runfactorial.o
ld ./output/2_11_factorialfunc.o ./output/2_11_runfactorial.o -o ./output/2_11_runfactorial
./output/2_11_runfactorial
echo $?
