# Learming Assembly

## Goals

- Learn lower level software concepts.

## Project Content

- `/programming_ground_up` _abandoned_ -
  Progress through the book ["Programming from the ground up"](https://download.savannah.gnu.org/releases/pgubook/)
- `/ltpwa` _complete_ -
  Progress through the book "Learn to Program with Assembly"
- `/projects/allocator` _complete "enough"_
- `/projects/compiler` - _coming soon?_

## Assembly Project Ideas

- Generate a binary executable by hand
  - https://oswalt.dev/2020/11/anatomy-of-a-binary-executable/
  - https://www.youtube.com/watch?v=1VnnbpHDBBA
  - https://www.youtube.com/watch?v=nC1U1LJQL8o
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

## Misc Notes

- https://stackoverflow.com/questions/6401586/intel-x86-opcode-reference
