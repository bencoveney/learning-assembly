#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

as 1_05_jmpexample.s -o ./output/1_05_jmpexample.o
ld ./output/1_05_jmpexample.o -o ./output/1_05_jmpexample
./output/1_05_jmpexample
echo $?

# as 1_05_infiniteloop.s -o ./output/1_05_infiniteloop.o
# ld ./output/1_05_infiniteloop.o -o ./output/1_05_infiniteloop
# ./output/1_05_infiniteloop
# echo $?

as 1_05_followthejump.s -o ./output/1_05_followthejump.o
ld ./output/1_05_followthejump.o -o ./output/1_05_followthejump
./output/1_05_followthejump
echo $?

as 1_05_exponent.s -o ./output/1_05_exponent.o
ld ./output/1_05_exponent.o -o ./output/1_05_exponent
./output/1_05_exponent
echo $?

as 1_05_exponent_alt.s -o ./output/1_05_exponent_alt.o
ld ./output/1_05_exponent_alt.o -o ./output/1_05_exponent_alt
./output/1_05_exponent_alt
echo $?

as 1_05_exponent_loop.s -o ./output/1_05_exponent_loop.o
ld ./output/1_05_exponent_loop.o -o ./output/1_05_exponent_loop
./output/1_05_exponent_loop
echo $?
