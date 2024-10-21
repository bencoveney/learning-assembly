#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as allocator.s usage.s ./utils/*.s --gdwarf-2 -o ./output/allocator.o
ld ./output/allocator.o -o ./output/allocator
./output/allocator
echo $?
