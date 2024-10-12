#! /bin/bash

cd "$(dirname -- ${BASH_SOURCE})"
rm -r ./output
mkdir -p ./output

gcc 2_15_link_example.s -static -o ./output/2_15_link_example_static
./output/2_15_link_example_static
echo $?

ls -lh ./output/2_15_link_example_static

# Strip debugging information
strip ./output/2_15_link_example_static
ls -lh ./output/2_15_link_example_static

# Confirm it is statically linked
ldd ./output/2_15_link_example_static

# Read ELF file format metadata
# objdump -x ./output/2_15_link_example_static

gcc 2_15_link_example.s -rdynamic -o ./output/2_15_link_example_dynamic
./output/2_15_link_example_dynamic
echo $?

ls -lh ./output/2_15_link_example_dynamic

# Strip debugging information
strip ./output/2_15_link_example_dynamic
ls -lh ./output/2_15_link_example_dynamic

# Confirm it is dynamically linked
ldd ./output/2_15_link_example_dynamic

# Read ELF file format metadata
# objdump -x ./output/2_15_link_example_dynamic

gcc 2_15_squareme.s 2_15_run_squareme.s -static -o ./output/2_15_run_squareme_static
./output/2_15_run_squareme_static
echo $?

gcc 2_15_squareme.s -shared -o ./output/libmymath.so
ld -L ./output -lmymath -verbose -o ./output/foundlib.o 2> /dev/null | grep succeeded

gcc 2_15_run_squareme.s -lmymath -L ./output -o ./output/2_15_run_squareme_dynamic

export LD_LIBRARY_PATH="./output"
./output/2_15_run_squareme_dynamic
echo $?
unset LD_LIBRARY_PATH

gcc 2_15_printstuff.s 2_15_multbyten.s 2_15_squareme.s -shared -o ./output/libmyextmath.so
ld -L ./output -lmyextmath -verbose -o ./output/foundextlib.o 2> /dev/null | grep succeeded

gcc 2_15_use_mymath.c -lmyextmath -L ./output -Wformat=0 -o ./output/2_15_use_mymath

export LD_LIBRARY_PATH="./output"
./output/2_15_use_mymath
echo $?
unset LD_LIBRARY_PATH

gcc 2_15_link_example_pie.s -pie -o ./output/2_15_link_example_pie
./output/2_15_link_example_pie
echo $?

gcc 2_15_fprintf_override.s -shared -o ./output/liboverride.so
ld -L ./output -loverride -verbose -o ./output/override.o 2> /dev/null | grep succeeded

export LD_PRELOAD="./output/liboverride.so"
export LD_LIBRARY_PATH="./output"
./output/2_15_use_mymath
echo $?
unset LD_LIBRARY_PATH
unset LD_PRELOAD
