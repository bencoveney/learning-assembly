# Instructions

| Instr     | Operand 1   | Operand 2   | Behaviour                                                                                                      |
| --------- | ----------- | ----------- | -------------------------------------------------------------------------------------------------------------- |
| `movq`    | source\*    | destination | Move quadword from `source` to `destination` (64 bits).                                                        |
| `movl`    | source\*    | destination | Move long from `source` to `destination` (32 bits).                                                            |
| `movw`    | source\*    | destination | Move word from `source` to `destination` (16 bits).                                                            |
| `movb`    | source\*    | destination | Move byte from `source` to `destination` (8 bits).                                                             |
| `addq`    | source\*    | destination | Add two values and store the result in `destination`                                                           |
| `adcq`    | source\*    | destination | Add two values, incl. carry flag from prev addition - useful for bigint addition.                              |
| `subq`    | source\*    | destination | Subtracts the source from the destination and stores the result in `destination`                               |
| `incq`    | destination |             | Increment a value and store the result in `destination`                                                        |
| `decq`    | destination |             | Decrement a value and store the result in `destination`                                                        |
| `mulq`    | source      |             | Multiplies the source by `%rax` and stores the result in `%rdx:%rax` (Unsigned)                                |
| `imulq`   | source      |             | Multiplies the source by `%rax` and stores the result in `%rdx:%rax` (Signed)                                  |
| `divq`    | source      |             | Divides `%rdx:%rax` by the source, stores the result in `%rax`, and stores the remainder in `%rdx` (Unsigned)  |
| `idivq`   | source      |             | Divides `%rdx:%rax` by the source, stores the result in `%rax`, and stores the remainder in `%rdx` (Signed)    |
| `syscall` |             |             | Perform a system call. Args passed in registers. Kernel takes over                                             |
| `jmp`     | nextAddress |             | Unconditional jump - Alter program flow by modifying address of next instruction in `%rip`                     |
| `jz`      | nextAddress |             | Conditional jump - Jump if the zero flag is set to 1                                                           |
| `jnz`     | nextAddress |             | Conditional jump - Jump if the zero flag is set to 0                                                           |
| `jc`      | nextAddress |             | Conditional jump - Jump if the carry flag is set to 1                                                          |
| `jnc`     | nextAddress |             | Conditional jump - Jump if the carry flag is set to 0                                                          |
| `jo`      | nextAddress |             | Conditional jump - Jump if the overflow flag is set to 1                                                       |
| `jno`     | nextAddress |             | Conditional jump - Jump if the overflow flag is set to 0                                                       |
| `js`      | nextAddress |             | Conditional jump - Jump if the sign flag is set to 1                                                           |
| `jns`     | nextAddress |             | Conditional jump - Jump if the sign flag is set to 0                                                           |
| `cmpq`    | left\*      | right       | Compare and update flags. Equal: zero flag set. `right` > `left`: flags cleared. `right` < `left`: complicated |
| `je`      | nextAddress |             | Conditionally jump if `right` == `left`                                                                        |
| `jne`     | nextAddress |             | Conditionally jump if `right` != `left`                                                                        |
| `ja`      | nextAddress |             | Conditionally jump if `right` > `left` (Unsigned - checking CF & ZF)                                           |
| `jae`     | nextAddress |             | Conditionally jump if `right` >= `left` (Unsigned - checking CF & ZF)                                          |
| `jb`      | nextAddress |             | Conditionally jump if `right` < `left` (Unsigned - checking CF & ZF)                                           |
| `jbe`     | nextAddress |             | Conditionally jump if `right` <= `left` (Unsigned - checking CF & ZF)                                          |
| `jg`      | nextAddress |             | Conditionally jump if `right` > `left` (Signed - checking OF and SF)                                           |
| `jge`     | nextAddress |             | Conditionally jump if `right` >= `left` (Signed - checking OF and SF)                                          |
| `jl`      | nextAddress |             | Conditionally jump if `right` < `left` (Signed - checking OF and SF)                                           |
| `jle`     | nextAddress |             | Conditionally jump if `right` <= `left` (Signed - checking OF and SF)                                          |
| `cmovgq`  | source      | destination | Conditionally move if `right` > `left`                                                                         |
| `cmovleq` | source      | destination | Conditionally move if `right` > `left`                                                                         |
| `loopq`   |             |             | Decrement the value it `%rcx`, and jump if the result is not zero                                              |
| `loopeq`  |             |             | Decrement the value it `%rcx`, and jump if the result is not zero and last comparison was equal                |
| `loopneq` |             |             | Decrement the value it `%rcx`, and jump if the result is not zero and last comparison was not equal            |
| `leaq`    | destination |             | "Load effective address" - Calculate a memory location, rather than load its value                             |
| `xchgq`   | source      | destination | Bi-directional `mov`, values are swapped                                                                       |
| `bswap`   | destination |             | Reverse the order of bytes. For word size, instead of `bswapw %ax`, use `xchgb %ax, %al`                       |
| `rorq`    | numBits\*   | register    | Rotate the register right by the number of bits. Bits which fall off the end are rotated round                 |
| `rolq `   | numBits\*   | register    | Rotate the register left by the number of bits. Bits which fall off the end are rotated round                  |
| `shrq`    | numBits\*   | register    | Shift the register right by the number of bits. Bits which fall off the end are replaced with 0                |
| `shlq`    | numBits\*   | register    | Shift the register left by the number of bits. Bits which fall off the end are replaced with 0                 |
| `negq`    | destination |             | Change the sign and store the result in `destination`                                                          |
| `andq`    | source\*    | destination | Perform a bitwise logical AND and store the result in `destination`                                            |
| `orq`     | source\*    | destination | Perform a bitwise logical OR and store the result in `destination`                                             |
| `notq`    | destination |             | Perform a bitwise logical NOT (bit flip) and store the result in `destination`                                 |
| `xorq`    | source\*    | destination | Perform a bitwise logical XOR and store the result in `destination`                                            |
| `andq`    | source\*    | destination | Perform a bitwise logical AND and set the flags, without storing the result in a register                      |

For source/dest instructions (mov, add, sub etc) typically one operand (but not both) can be a memory address

\* = can be a literal.

## Syscalls

| Syscall | Number - `%rax` | `%rdi` |
| ------- | --------------- | ------ |
| exit    | 60              | code   |

### x86 vs x86-64

Migrated from `int 0x80` to `syscall`. Restructuring allowed:

- Perf improvements.
- Register changes (for even more perf).

## Assembler Directives

| Syntax                 | Behaviour                                                                                           |
| ---------------------- | --------------------------------------------------------------------------------------------------- |
| `.section .text`       | Preceeding region of instructions, for inclusion in a code section/segment.                         |
| `.section .data`       | Preceeding region of global variables, for inclusion in a static value code/segment.                |
| `.globl [label]`       | Designate a label/constant as global. It will be exported/available to other files when assembling. |
| `.equ [name], [value]` | Creates a assembler-time constant with the given name. `value` can include some basic computation.  |
| `[label]:`             | Define a label. Ends up just pointing to an address in memory.                                      |

## Big Integer Addition

- Load least significant bits.
- `addq` to perform addition _and set carry flag_.
- Store the result.
- For the remaining bytes
  - Load the next least significant bits.
  - Add with `adcq` (Adds 2 values, and carry flag).
  - Store the result.
- After all additions, check the overflow flag.

# Multiplication

Addition and subtraction will only overflow by 1 bit, which can be stored in the CF and OF. Multiplication can _double_ the length of the value.

For `mul`:

- `%rax` gets least significant bits of result.
- `%rdx` gets most significant bits of result.
- For _all_ multiplication instructions (signed/unsigned), `CF` and `OF` will be set if the result overflows into the second register.

Combination of 2 registers is often written as `%rdx:%rax`.

For `div`:

- `%rdx:%rax` is the input.
- `%rax` gets the quotient.
- `%rdx` gets the remainder.

Should clear `%rdx` before use.

`div` can fail in multiple ways:

- If start value > 64 bits, result can be > 64 bits.
- Division by 0.

Program will terminate if this happens.

`mul` and `div` are unsigned. `imul` and `idiv` are signed.

# Working with bits

```
A:       0b 0 1 0 1 0 1 0 1
B:       0b 0 0 0 0 1 1 1 1
A AND B: 0b 0 0 0 0 0 1 0 1
A OR B:  0b 0 1 0 1 1 1 1 1
```

You can check `ZF` after AND-ing

For checking a bit:

```gas
test $0b00000001, %bl
jnz somewhere
```

For setting a flag:

```gas
movb $0b01001100, %al
orb $0b00000001, %al
```
