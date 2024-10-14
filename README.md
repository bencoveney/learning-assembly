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

## Compiler

Development capabilities:

- Ability to read a file.
- Ability to write a file.
- Ability to log a message to STDOUT/STDERR.
- Ability to heap allocate data structures.
- Some test harness, where:
  - Source files are the input.
  - Compiled code is the output.
  - Errors can be confirmed too.

Front End:

- Lexical Analysis.
  - Scan through source code.
  - Break it into a stream of tokens/lexemes.
  - Removes lexical errors.
    - Bad characters - anything non-ASCII?.
    - Incorrect spellings.
  - Can remove comments.
  - Classify lexical units e.g. identifier, operator, number, string.
  - Needs:
    - Ability to operate on a string.
      - Iterate through.
      - Do comparisons.
    - Ability to create a stream (data structure).
    - Ability to put identifiers in a symbol table (data structure).
- Syntax Analysis.
  - Take the stream of tokens.
  - Build it into an abstract syntax tree.
  - Check they conform to the language syntax.
  - Check for:
    - Operands used with operators.
    - Missing parenthesis.
  - Update symbol table with kind (var, const, func), scope, memory address, value, data type.
  - Needs:
    - Ability to switch on token content.
    - Ability to create a tree (data structure).
      - Heap allocation?
- Semantic Analysis.
  - Check the AST conforms to the language semantics.
  - Check for:
    - Type errors (or implicit casts).
    - Function call parameters.
    - Undeclared variables.
    - Control flow.
  - Needs:
- Intermediate code generation.
  - Create an intermediate representation of the source code.
  - Needs:

Back End:

- Optimization.
  - Improve performance/size of generated code.
  - Remove unused/redundant code/data.
  - Needs:
- Code Generation.
  - Take optimized code and generate machine code.
  - Bundle it into an executable.
  - Needs:

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
- https://www.geeksforgeeks.org/symbol-table-compiler/
