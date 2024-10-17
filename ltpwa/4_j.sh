#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

gcc 4_j_gc_* -g -static -Wformat=0 -o ./output/4_j_gc
./output/4_j_gc
echo $?
