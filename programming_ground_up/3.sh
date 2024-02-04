#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 3_exit.s -o ./output/3_exit.o
ld ./output/3_exit.o -o ./output/3_exit
./output/3_exit
echo $?

as 3_exit_alt.s -o ./output/3_exit_alt.o
ld ./output/3_exit_alt.o -o ./output/3_exit_alt
./output/3_exit_alt
echo $?

as 3_maximum.s -o ./output/3_maximum.o
ld ./output/3_maximum.o -o ./output/3_maximum
./output/3_maximum
echo $?

as 3_maximum_alt.s -o ./output/3_maximum_alt.o
ld ./output/3_maximum_alt.o -o ./output/3_maximum_alt
./output/3_maximum_alt
echo $?

shasum ./output/*.o
