# Compiler

Goals:

- Learn lower level concepts.

Non-goals:

- Language design.
- Learn how to build hardware.
- Learn how old computers worked.

Plan:

- Figure out enough ASM to barely write a compiler.
- Implement compiler in ASM (language to assembly).
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
