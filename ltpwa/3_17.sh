#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

gcc 3_17_mempool.s 3_17_mempool.c -g -static -Wformat=0 -o ./output/3_17_mempool
./output/3_17_mempool
echo $?

gcc 2_14_allocate.s 3_17_refcount.s 3_17_refcount.c -g -static -Wformat=0 -o ./output/3_17_refcount
./output/3_17_refcount
echo $?
