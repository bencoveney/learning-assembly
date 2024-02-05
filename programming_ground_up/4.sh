#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 4_power.s -o ./output/4_power.o
ld ./output/4_power.o -o ./output/4_power
./output/4_power
echo $?
