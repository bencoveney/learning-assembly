# Instructions

| Instruction     | Operand 1    | Operand 2   | Behaviour                                                                                                      |
| --------------- | ------------ | ----------- | -------------------------------------------------------------------------------------------------------------- |
| `movq`          | source\*     | destination | Move quadword from `source` to `destination` (64 bits).                                                        |
| `movl`          | source\*     | destination | Move long from `source` to `destination` (32 bits).                                                            |
| `movw`          | source\*     | destination | Move word from `source` to `destination` (16 bits).                                                            |
| `movb`          | source\*     | destination | Move byte from `source` to `destination` (8 bits).                                                             |
| `addq`          | source\*     | destination | Add two values and store the result in `destination`                                                           |
| `adcq`          | source\*     | destination | Add two values, incl. carry flag from prev addition - useful for bigint addition.                              |
| `subq`          | source\*     | destination | Subtracts the source from the destination and stores the result in `destination`                               |
| `incq`          | destination  |             | Increment a value and store the result in `destination`                                                        |
| `decq`          | destination  |             | Decrement a value and store the result in `destination`                                                        |
| `mulq`          | source       |             | Multiplies the source by `%rax` and stores the result in `%rdx:%rax` (Unsigned)                                |
| `imulq`         | source       |             | Multiplies the source by `%rax` and stores the result in `%rdx:%rax` (Signed)                                  |
| `divq`          | source       |             | Divides `%rdx:%rax` by the source, stores the result in `%rax`, and stores the remainder in `%rdx` (Unsigned)  |
| `idivq`         | source       |             | Divides `%rdx:%rax` by the source, stores the result in `%rax`, and stores the remainder in `%rdx` (Signed)    |
| `syscall`       |              |             | Perform a system call. Args passed in registers. Kernel takes over                                             |
| `jmp`           | nextAddress  |             | Unconditional jump - Alter program flow by modifying address of next instruction in `%rip`                     |
| `jz`            | nextAddress  |             | Conditional jump - Jump if the zero flag is set to 1                                                           |
| `jnz`           | nextAddress  |             | Conditional jump - Jump if the zero flag is set to 0                                                           |
| `jc`            | nextAddress  |             | Conditional jump - Jump if the carry flag is set to 1                                                          |
| `jnc`           | nextAddress  |             | Conditional jump - Jump if the carry flag is set to 0                                                          |
| `jo`            | nextAddress  |             | Conditional jump - Jump if the overflow flag is set to 1                                                       |
| `jno`           | nextAddress  |             | Conditional jump - Jump if the overflow flag is set to 0                                                       |
| `js`            | nextAddress  |             | Conditional jump - Jump if the sign flag is set to 1                                                           |
| `jns`           | nextAddress  |             | Conditional jump - Jump if the sign flag is set to 0                                                           |
| `cmpq`          | left\*       | right       | Compare and update flags. Equal: zero flag set. `right` > `left`: flags cleared. `right` < `left`: complicated |
| `je`            | nextAddress  |             | Conditionally jump if `right` == `left`                                                                        |
| `jne`           | nextAddress  |             | Conditionally jump if `right` != `left`                                                                        |
| `ja`            | nextAddress  |             | Conditionally jump if `right` > `left` (Unsigned - checking CF & ZF)                                           |
| `jae`           | nextAddress  |             | Conditionally jump if `right` >= `left` (Unsigned - checking CF & ZF)                                          |
| `jb`            | nextAddress  |             | Conditionally jump if `right` < `left` (Unsigned - checking CF & ZF)                                           |
| `jbe`           | nextAddress  |             | Conditionally jump if `right` <= `left` (Unsigned - checking CF & ZF)                                          |
| `jg`            | nextAddress  |             | Conditionally jump if `right` > `left` (Signed - checking OF and SF)                                           |
| `jge`           | nextAddress  |             | Conditionally jump if `right` >= `left` (Signed - checking OF and SF)                                          |
| `jl`            | nextAddress  |             | Conditionally jump if `right` < `left` (Signed - checking OF and SF)                                           |
| `jle`           | nextAddress  |             | Conditionally jump if `right` <= `left` (Signed - checking OF and SF)                                          |
| `cmovgq`        | source       | destination | Conditionally move if `right` > `left`                                                                         |
| `cmovleq`       | source       | destination | Conditionally move if `right` > `left`                                                                         |
| `loopq`         |              |             | Decrement the value in `%rcx`, and jump if the result is not zero                                              |
| `loopeq`        |              |             | Decrement the value in `%rcx`, and jump if the result is not zero and last comparison was equal                |
| `loopneq`       |              |             | Decrement the value in `%rcx`, and jump if the result is not zero and last comparison was not equal            |
| `leaq`          | destination  |             | "Load effective address" - Calculate a memory location, rather than load its value                             |
| `xchgq`         | source       | destination | Bi-directional `mov`, values are swapped                                                                       |
| `bswap`         | destination  |             | Reverse the order of bytes. For word size, instead of `bswapw %ax`, use `xchgb %ax, %al`                       |
| `rorq`          | numBits\*    | register    | Rotate the register right by the number of bits. Bits which fall off the end are rotated round                 |
| `rolq `         | numBits\*    | register    | Rotate the register left by the number of bits. Bits which fall off the end are rotated round                  |
| `shrq`          | numBits\*    | register    | Shift the register right by the number of bits. Bits which fall off the end are replaced with 0                |
| `shlq`          | numBits\*    | register    | Shift the register left by the number of bits. Bits which fall off the end are replaced with 0                 |
| `negq`          | destination  |             | Change the sign and store the result in `destination`                                                          |
| `andq`          | source\*     | destination | Perform a bitwise logical AND and store the result in `destination`                                            |
| `orq`           | source\*     | destination | Perform a bitwise logical OR and store the result in `destination`                                             |
| `norq`          | source\*     | destination | Perform a bitwise logical NOR and store the result in `destination`                                            |
| `notq`          | destination  |             | Perform a bitwise logical NOT (bit flip) and store the result in `destination`                                 |
| `xorq`          | source\*     | destination | Perform a bitwise logical XOR and store the result in `destination`                                            |
| `testq`         | source\*     | destination | Perform a bitwise logical AND and set the flags, without storing the result in a register                      |
| `clc`           |              |             | Clears the carry flag `CF`                                                                                     |
| `setc`          |              |             | Sets the carry flag `CF`                                                                                       |
| `cld`           |              |             | Clears the direction flag `DF`                                                                                 |
| `setd`          |              |             | Sets the direction flag `DF`                                                                                   |
| `lahf`          |              |             | Loads the common flags from `%eflags` into `%ah`                                                               |
| `sahf`          |              |             | Sets the common flags from `%ah` into `%eflags`                                                                |
| `movsq`         |              |             | Copies from address in `%rsi` to address in `%rdi`, then moves to next address                                 |
| `cmpsq`         |              |             | Compares value at address in `%rsi` to value at address in `%rdi`, then moves to next address                  |
| `scasq`         |              |             | Compares value at address in `%rdi` to `%rax`, then moves to next address                                      |
| `rep`           | string instr |             | Repeats the instruction, counting down `%rcx` as a counter                                                     |
| `repe`/`repz`   | string instr |             | Repeats the instruction, counting down `%rcx` or until non-equal/non-zero values are found (checking `ZF`)     |
| `repne`/`repnz` | string instr |             | Repeats the instruction, counting down `%rcx` or until equal/zero values are found (checking `ZF`)             |
| `nop`           |              |             | Does nothing, useful for being replaced, or code alignment                                                     |
| `pushq`         |              |             | Increments `%rsp` and pushes a value onto the stack                                                            |
| `popq`          |              |             | Pops a value from the stack and decrements `%rsp`                                                              |
| `enter`         | numBytes\*   | numBytes\*  | Sets up a stack frame with `numBytes` of memory reserved. 2nd `numBytes` can be used for closures              |
| `leave`         |              |             | Clears up a stack frame                                                                                        |
| `endbr64`       |              |             | Intel Control-Flow Enforcement Technology - security measure                                                   |
| `cvtsi2sd`      | source       | destination | Converts an int (stored in a general register) to a float (in an `xmm` register)                               |

For source/dest instructions (mov, add, sub etc) typically one operand (but not both) can be a memory address

\* = can be a literal. Probably missing plenty for this.

### x86 vs x86-64

Migrated from `int 0x80` to `syscall`. Restructuring allowed:

- Perf improvements.
- Register changes (for even more perf).

## Big Integer Addition

- Load least significant bits.
- `addq` to perform addition _and set carry flag_.
- Store the result.
- For the remaining bytes
  - Load the next least significant bits.
  - Add with `adcq` (Adds 2 values, and carry flag).
  - Store the result.
- After all additions, check the overflow flag.

## Multiplication

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

## Bitwise logic instructions

```
A:       0b 0 1 0 1 0 1 0 1
B:       0b 0 0 0 0 1 1 1 1

NOT A:   0b 1 0 1 0 1 0 1 0

A AND B: 0b 0 0 0 0 0 1 0 1
A OR B:  0b 0 1 0 1 1 1 1 1
A NOR B: 0b 1 0 1 0 0 0 0 0
A XOR B: 0b 0 1 0 1 1 0 1 0
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

Uses:

- All (except `not`) set flags. ZF tends to be most useful
- `and` is used for masking
- `or` is used for setting/combining flags
- `xor` is the most efficient way to clear a register, by applying it to itself (note: sets flags)

Assembler can do OR logic. Example:

```gas
.equ KNOWS_PROGRAMMING, 0b1
.equ KNOWS_CHEMISTRY, 0b1
.equ KNOWS_PHYSICS, 0b1

movq $(KNOWS_PROGRAMMING | KNOWS_PHYSICS), %rax

andq KNOWS_PHYSICS, %rax
jnz do_something_if_they_know_physics
```

## Bitwise counting/scanning instructions

- `lzcntq`: Count leading zeroes.
- `bsfq`: Bit scan forward.
  - From least significant bit, count forward.
  - If found
    - Store index of first non-zero bit in destination.
    - Set `ZF` to 0
  - If not found
    - Destination is undefined.
    - Set `ZF` to 1
  - Rightmost index is 0, leftmost is 63 (for 64 bit ops).
- `bsrq`: Bit scan reverse.
  - From most significant bit, count backwards.
  - If found
    - Store index of first non-zero bit in destination.
    - Set `ZF` to 0
  - If not found
    - Destination is undefined.
    - Set `ZF` to 1
  - Rightmost index is 0, leftmost is 63 (for 64 bit ops).

```gas
mov $0b 00000000 00000000 00000000 00000000 00000000 00000000 00000000 10010000, %rdx
lzcbtq %rdx # 59
bsfq %rdx # 4
bsrq %rdx # 7?
```

Can flip bits (with `not`) to count 1s.

- https://en.wikipedia.org/wiki/X86_Bit_manipulation_instruction_set
- https://www.chessprogramming.org/TBM

## Jumps

- _Short Jump_
  - Within 127 bytes of the current instruction
  - Relative to instruction pointer
- _Near Jump_
  - Typical type of jump
  - Within 2GB of the current instruction
  - Relative to instruction pointer
- _Far jump_
  - Not really used any more
  - Relevant when memory had different segments
  - Linux has a flat memory model, every address (for a process) is in the same segment
- _Indirect jump_
  - Jump to an address we won't know until runtime (from memory or a register)
  - Uses same `jmp` instruction, but with a `*` prefix before the operand e.g. `jmp *mytarget`

Assembler picks between short and near jumps

```gas
target_pointer:
  .quad 0

mycode:
  movq $mytarget, target_pointer
  jmp *target_pointer

  # We jump over this

mytarget:
  # We end up here
```

## Memory and string operations

String instructions (e.g. `movsq`, `cmpsq`, `scasq`) will:

- Use `%rsi` (source register) as the source.
- Use `%rdi` (dest register) as the destination.
- Move those registers on to the next memory location.
  - e.g. 8 bytes for quad-words.
- Chose the movement direction based on the `DF` direction flag register.
  - e.g. incremented if `DF == 0`

String operations can be prefixed by `rep`, which will:

- Repeat the instruction multiple times.
- Count down in the `%rcx` register.

```gas
.section .data
source:
  .quad 9, 23, 55, 1, 3
dest:
  .quad 0, 0, 0, 0, 0

.section .text
_start
  # Copy the first 3 values from source to dest
  movq $source, %rsi
  movq $dest, %rdi
  movq $3, %rcx
  rep movsq
```

- `rep` can be used with:
  - `movsq` to move values
  - `ins`, `outs`, `lods`, `stos`
- `repe`, `repne`, `repz`, `repnz` can be used with:
  - `cmpsq` to compare values
  - `scasq` to find a value

`%rcx` will often contain useful information about string length after running `rep`. E.g. find length of a string in bytes:

```gas
.section .data
mystring:
  .ascii "This is my string\0"

.section .text
_start
  # Preload rcx with a large value
  movq $-1, %rcx
  # Load the address of the string
  movq $mystring, $rdi
  # Looking for a null value
  movb $0, %al
  # Repeat until null found
  repne scasb

  # Now %rdi points to one byte beyond null terminator
  # Subtract string address + 1, to get length
  subq $mystring, %rdi
  decq %rdi

  # Length can now be loaded into %rcx for use copying etc...
```

## Floating-Point Instructions

For converting:

- `cvtsi2sd`
  - **c**on**v**er**t** a **s**ingle value that is an **i**nteger to (**2**) a **s**calar
    **d**ouble-precision floating-point value.
  - From a general register, to an `%xmm` register.
- `cvtsd2si`
  - **c**on**v**er**t** a **s**calar **d**ouble-precision floating-point value to (**2**) a
    **s**ingle value that is an **i**nteger.
  - From an `%xmm` register, to a general register.
- `cvtss2sd`
  - **c**on**v**er**t** a **s**calar **s**ingle-precision floating-point value to (**2**) a
    **s**calar **d**ouble-precision floating-point value.
- `cvtsd2ss`
  - **c**on**v**er**t** a **s**calar **d**ouble-precision floating-point value to (**2**) a
    **s**calar **s**ingle-precision floating-point value.

For moving values in:

- `movq` into the lower 64 bits (clears the top 64 bits).
- `movsd` into the lower 64 bits (retains the top 64 bits).
- `movss` into the lower 32 bits (retains the top 32 bits).
- `movdqu` moves 4 unaligned values (optimised for integers).
- `movdqa` moves 4 aligned values (optimised for integers).
- `movups` moves 4 unaligned values (optimised for floating points).
- `movaps` moves 4 aligned values (optimised for floating points).

Aligned values will be quicker to move.

Operations on the registers occur for all values simultaneously.

For most math operations there is a `...sd` variant for working with **s**calar
**d**ouble-precision values. For single-precision (32-bits) the suffix is `...ss`

- `addsd %xmm0, %xmm1` adds the values and stores in `%xmm1`.
- `mulsd %xmm0, %xmm1` adds the values and stores in `%xmm1`.
- `divsd %xmm0, %xmm1` does `%xmm1 / %xmm0 `and stores in `%xmm1`.

For most math operations, there is a `...pd` variant for working with **p**acked
**d**ouble-precision values. For single-precision (32-bits) the suffix is `ps`

- `addpd %xmm0, %xmm1` adds the values and stores in `%xmm1` for each packed value.
- `mulpd %xmm0, %xmm1` adds the values and stores in `%xmm1` for each packed value.
- `divpd %xmm0, %xmm1` does `%xmm1 / %xmm0 `and stores in `%xmm1` for each packed value.

For most math operations, there is a `...pd` variant for working with **p**acked integer values.

- `paddb` for 1 byte integers.
- `paddw` for 2 byte integers.
- `paddd` for 4 byte integers.
- `paddq` for 8 byte integers.

For shifting values (packing):

- `pslldq [bytes], [register]` - shifts the register left by N bytes.
- `psrldq [bytes], [register]` - shifts the register right by N bytes.

## Instruction Formats

Text form of instructions are the "mnemonics". Assembler converts these into numbers which the
processor then interprets. In x86-64, instructions can have variable size, ranging from 1 byte to
15 bytes.

The numeric form of an instruction is the "opcode". Opcodes don't map 1-1 with mnemonics, sometimes
there can be different opcodes to support different operands. E.g:

- `movl` is `0x89` when: the source is a register.
- `movl` is `0x8b` when: the source is memory.
- `movl` is `0xb8` when: the source is an immediate-mode value.
- `movq` is `0x89` with a REX prefix when: the source is a register.
- `movq` is `0x8b` with a REX prefix when: the source is memory.
- `movq` is `0xb8` with a REX prefix when: the source is an immediate-mode value.

http://ref.x86asm.net/coder64.html
http://ref.x86asm.net/coder64-abc.html

Basic format:

| Part         | Size                                         | Description                                       | Examples                     |
| ------------ | -------------------------------------------- | ------------------------------------------------- | ---------------------------- |
| Prefixes     | 1 byte for each                              | Modify instruction operation                      | `rep`, `repe`, `LOCK`, `REX` |
| Opcode       | 1-3 bytes                                    | Which instruction to do                           | `movl`, `movq`               |
| ModR/M       | 1 byte if required by the opcode             | Which registers and/or addressing mode            |                              |
| SIB          | 1 byte if required by the opcode             | Which registers are scale, index and base         |                              |
| Displacement | 1, 2, 4 or 8 bytes if required by the opcode | Entire address, or displacement from base pointer |                              |
| Immediate    | 1, 2, 4 or 8 bytes if required by the opcode | Immediate mode value                              |                              |

`LOCK` prefix tells processor that no other CPU should have access to a cache line.

`REX` prefix allows some legacy (from 32-bit) instructions to work as 64-bit.

Example: `movb $8, %ah` becomes `0xb4 0x08`:

- There are different opcodes for each destination.
  - `0xb0` is `%al`.
  - `0xb4` is `%ah`.
- Immediate value is `0x08`.

Example: `movq $8, %rax` becomes `0x48 0xc7 0xc3 0x08 0x00 0x00 0x00`:

- REX prefix is `0x48`
- Opcode is `0xc7`
- Immediate value is `0x08 0x00 0x00 0x00` (4 byte little-endian).
