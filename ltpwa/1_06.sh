#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 1_06_simpledata.s -o ./output/1_06_simpledata.o
ld ./output/1_06_simpledata.o -o ./output/1_06_simpledata
./output/1_06_simpledata
echo $?

as 1_06_simpledatashort.s -o ./output/1_06_simpledatashort.o
ld ./output/1_06_simpledatashort.o -o ./output/1_06_simpledatashort
./output/1_06_simpledatashort
echo $?

as 1_06_largestvalue.s -o ./output/1_06_largestvalue.o
ld ./output/1_06_largestvalue.o -o ./output/1_06_largestvalue
./output/1_06_largestvalue
echo $?

as 1_06_largestvalueindex.s -o ./output/1_06_largestvalueindex.o
ld ./output/1_06_largestvalueindex.o -o ./output/1_06_largestvalueindex
./output/1_06_largestvalueindex
echo $?

as 1_06_largestvaluercx.s -o ./output/1_06_largestvaluercx.o
ld ./output/1_06_largestvaluercx.o -o ./output/1_06_largestvaluercx
./output/1_06_largestvaluercx
echo $?
