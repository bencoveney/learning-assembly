# Compiler

## Goals

- Learn lower level software concepts.

## Non-goals

- Design a novel or interesting programming language.
- Learn how to build hardware.

## Plan:

- Figure out enough ASM to barely write a compiler.
- Implement compiler in ASM (language to assembly).
- Extent simple language with some larger concepts.
- Rewrite compiler pipeline in language.
- Implement assembler (assembly to machine code, probably x86).
- Implement linker (x86 to ELF).

## Language

- Just enough to get work done.
- Use the source code of the implemented compiler to determine what features the language needs.

## Useful Commands

```bash
# Read ELF
readelf -aW ./hello

# Hex dump
hd ./hello
```

## Project Content

- `/ltpwa` _active_ -
  Progress through the book "Learn to Program with Assembly"
- `/programming_ground_up` _abandoned_ -
  Progress through the book ["Programming from the ground up"](https://download.savannah.gnu.org/releases/pgubook/)
