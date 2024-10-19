#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

gcc 4_f_fpdiv.s -static -o ./output/4_f_fpdiv
./output/4_f_fpdiv
echo $?

gcc 4_f_vectormultiply.s -static -o ./output/4_f_vectormultiply
./output/4_f_vectormultiply
echo $?
