#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 1_07_persondata.s -o ./output/1_07_persondata.o
as 1_07_persondataextended.s -o ./output/1_07_persondataextended.o

as 1_07_tallest.s -o ./output/1_07_tallest.o
ld ./output/1_07_persondata.o ./output/1_07_tallest.o -o ./output/1_07_tallest
./output/1_07_tallest
echo $?

as 1_07_tallest.s -o ./output/1_07_tallest.o
ld ./output/1_07_persondataextended.o ./output/1_07_tallest.o -o ./output/1_07_tallest
./output/1_07_tallest
echo $?

as 1_07_browncount.s -o ./output/1_07_browncount.o
ld ./output/1_07_persondata.o ./output/1_07_browncount.o -o ./output/1_07_browncount
./output/1_07_browncount
echo $?

as 1_07_browncount.s -o ./output/1_07_browncount.o
ld ./output/1_07_persondataextended.o ./output/1_07_browncount.o -o ./output/1_07_browncount
./output/1_07_browncount
echo $?
