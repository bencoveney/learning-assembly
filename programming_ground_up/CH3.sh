#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as CH3_exit.s -o ./output/CH3_exit.o
ld ./output/CH3_exit.o -o ./output/CH3_exit
./output/CH3_exit
echo $?

as CH3_exit_alt.s -o ./output/CH3_exit_alt.o
ld ./output/CH3_exit_alt.o -o ./output/CH3_exit_alt
./output/CH3_exit_alt
echo $?

as CH3_maximum.s -o ./output/CH3_maximum.o
ld ./output/CH3_maximum.o -o ./output/CH3_maximum
./output/CH3_maximum
echo $?

as CH3_maximum_alt.s -o ./output/CH3_maximum_alt.o
ld ./output/CH3_maximum_alt.o -o ./output/CH3_maximum_alt
./output/CH3_maximum_alt
echo $?

shasum ./output/*.o
