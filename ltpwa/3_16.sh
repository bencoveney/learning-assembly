#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 3_16_exception.s  -o ./output/3_16_exception.o
ld ./output/3_16_exception.o -o ./output/3_16_exception
./output/3_16_exception
echo $?

as 3_16_factorialtail.s -o ./output/3_16_factorialtail.o
ld ./output/3_16_factorialtail.o -o ./output/3_16_factorialtail
./output/3_16_factorialtail
echo $?

gcc -S 3_16_example_compile.c -Wformat=0 -o ./output/3_16_example_compile.s
