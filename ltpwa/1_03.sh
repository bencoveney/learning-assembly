#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 1_03_exit.s -o ./output/1_03_exit.o
ld ./output/1_03_exit.o -o ./output/1_03_exit
./output/1_03_exit
echo $?
