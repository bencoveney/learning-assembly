#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 1_04_arithmetic.s -o ./output/1_04_arithmetic.o
ld ./output/1_04_arithmetic.o -o ./output/1_04_arithmetic
./output/1_04_arithmetic
echo $?

as 1_04_binaryexit.s -o ./output/1_04_binaryexit.o
ld ./output/1_04_binaryexit.o -o ./output/1_04_binaryexit
./output/1_04_binaryexit
echo $?

as 1_04_valuesize.s -o ./output/1_04_valuesize.o
ld ./output/1_04_valuesize.o -o ./output/1_04_valuesize
./output/1_04_valuesize
echo $?
