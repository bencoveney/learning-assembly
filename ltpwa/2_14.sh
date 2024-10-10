#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

gcc 2_14_mallocdemo.s -static -o ./output/2_14_mallocdemo
./output/2_14_mallocdemo
echo $?

gcc 2_14_allocate.s 2_14_usealloc.c -static -g -Wformat=0 -o ./output/2_14_usealloc
./output/2_14_usealloc
echo $?
