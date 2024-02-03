# Compiler

Goals:

- Learn lower level concepts.

Non-goal:

- Language design.

Plan:

- Figure out enough NASM to barely write a compiler.
- Implement compiler in NASM (language to assembly).
- Extent simple language with some larger concepts.
- Rewrite compiler pipeline in language.
- Implement assembler (assembly to machine code, probably x86).
- Implement linker (x86 to ELF).

Language:

- Just enough to get work done.
- Use the source code of the implemented compiler to determine what features the language needs.

Compiling:

```bash
# Generate object file
nasm -f elf64 hello.asm
# Generate object file + listing
nasm -f elf64 hello.asm -l hello.lst

# Link object file into executable
ld hello.o -o hello

# Run executable
./hello

# Read ELF
readelf -aW ./hello

# Hex dump
hd ./hello
```
