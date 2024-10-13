#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 3_16_exception.s  --gdwarf-2 -o ./output/3_16_exception.o
ld ./output/3_16_exception.o -o ./output/3_16_exception
./output/3_16_exception
echo $?
