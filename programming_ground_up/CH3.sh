#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as CH3_exit.s -o ./output/CH3_exit.o
# objdump -D ./output/CH3_exit.o
#  objdump -x ./output/CH3_exit.o
ld ./output/CH3_exit.o -o ./output/CH3_exit
# readelf -aW ./output/CH3_exit.o
./output/CH3_exit
echo $?

as CH3_exit_variant.s -o ./output/CH3_exit_variant.o
# objdump -D ./output/CH3_exit_variant.o
#  objdump -x ./output/CH3_exit_variant.o
ld ./output/CH3_exit_variant.o -o ./output/CH3_exit_variant
# readelf -aW ./output/CH3_exit_variant.o
./output/CH3_exit_variant
echo $?

# shasum ./output/CH3_exit ./output/CH3_exit_variant
