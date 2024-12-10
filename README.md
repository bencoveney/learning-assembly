# Compiler

## Goals

- Learn lower level software concepts.

## Assmebly

- "Programming from the ground up" book
  - `/programming_ground_up`
  - Half done, replaced with...
- "Learn to Program with Assembly" book
  - `/ltpwa`
  - Done
- Work through some basic assembly programs
  - Allocator
  - Sorting algorithms
  - Game of life
  - Polish notation processor
  - Brainfuck interpreter
  - Find information about environment
    - Env vars
    - Args
    - Page size (system calls?)
  - Data structures
    - Fixed size array (arbitrary element size)
    - Dynamic size array (arbitrary element size)
  - File tokeniser
  - Message logger with string interpolation
    - Int parsing/stringification
  - Static file server
  - Challenges from
    - Project Euler
    - Advent of Code

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

## Misc Notes

- https://stackoverflow.com/questions/6401586/intel-x86-opcode-reference
