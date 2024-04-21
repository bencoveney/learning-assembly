# Instructions

| Instr     | Operand 1   | Operand 2   | Behaviour                                                                                                      |
| --------- | ----------- | ----------- | -------------------------------------------------------------------------------------------------------------- |
| `movq`    | source\*    | destination | Move quadword from `source` to `destination` (64 bits).                                                        |
| `movl`    | source\*    | destination | Move long from `source` to `destination` (32 bits).                                                            |
| `movw`    | source\*    | destination | Move word from `source` to `destination` (16 bits).                                                            |
| `movb`    | source\*    | destination | Move byte from `source` to `destination` (8 bits).                                                             |
| `addq`    | source\*    | destination | Add two values and store the result in `destination`                                                           |
| `subq`    | source\*    | destination | Subtracts the source from the destination and stores the result in `destination`                               |
| `incq`    | destination |             | Increment a value and store the result in `destination`                                                        |
| `decq`    | destination |             | Decrement a value and store the result in `destination`                                                        |
| `mulq`    | source      |             | Multiplies the source by `%rax` and stores the result in `%rax`.                                               |
| `divq`    | source      |             | Divides `%rax` by the source, stores the result in `%rax`, and stores the remainder in `%rdx`.                 |
| `syscall` |             |             | Perform a system call. Args passed in registers. Kernel takes over                                             |
| `jmp`     | nextAddress |             | Unconditional jump - Alter program flow by modifying address of next instruction in `%rip`                     |
| `jz`      | nextAddress |             | Conditional jump - Jump if the zero flag is set to 1                                                           |
| `jnz`     | nextAddress |             | Conditional jump - Jump if the zero flag is set to 0                                                           |
| `jc`      | nextAddress |             | Conditional jump - Jump if the carry flag is set to 1                                                          |
| `jnc`     | nextAddress |             | Conditional jump - Jump if the carry flag is set to 0                                                          |
| `cmpq`    | left\*      | right       | Compare and update flags. Equal: zero flag set. `right` > `left`: flags cleared. `right` < `left`: complicated |
| `je`      | nextAddress |             | Conditionally jump if `right` == `left`                                                                        |
| `jne`     | nextAddress |             | Conditionally jump if `right` != `left`                                                                        |
| `ja`      | nextAddress |             | Conditionally jump if `right` > `left`                                                                         |
| `jae`     | nextAddress |             | Conditionally jump if `right` >= `left`                                                                        |
| `jb`      | nextAddress |             | Conditionally jump if `right` < `left`                                                                         |
| `jbe`     | nextAddress |             | Conditionally jump if `right` <= `left`                                                                        |
| `cmovgq`  | source      | destination | Conditionally move if `right` > `left`                                                                         |
| `cmovleq` | source      | destination | Conditionally move if `right` > `left`                                                                         |
| `loopq`   |             |             | Decrement the value it `%rcx`, and jump if the result is not zero                                              |
| `loopeq`  |             |             | Decrement the value it `%rcx`, and jump if the result is not zero and last comparison was equal                |
| `loopneq` |             |             | Decrement the value it `%rcx`, and jump if the result is not zero and last comparison was not equal            |
| `leaq`    | destination |             | "Load effective address" - Calculate a memory location, rather than load its value                             |

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
