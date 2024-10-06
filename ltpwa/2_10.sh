#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 2_10_wait5.s -o ./output/2_10_wait5.o
ld ./output/2_10_wait5.o -o ./output/2_10_wait5
./output/2_10_wait5
echo $?

as 2_10_simpleoutput.s -o ./output/2_10_simpleoutput.o
ld ./output/2_10_simpleoutput.o -o ./output/2_10_simpleoutput
./output/2_10_simpleoutput
echo $?
