#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

gcc 3_18_vtable_*.s -static -o ./output/3_18_vtable
./output/3_18_vtable
echo $?
