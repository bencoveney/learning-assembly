# Instructions

| Instr     | Operand 1   | Operand 2   | Behaviour                                                                                      |
| --------- | ----------- | ----------- | ---------------------------------------------------------------------------------------------- |
| `movq`    | source\*    | destination | Move quadword (64 bits)                                                                        |
| `movl`    | source\*    | destination | Move long (32 bits)                                                                            |
| `movw`    | source\*    | destination | Move word (16 bits)                                                                            |
| `movb`    | source\*    | destination | Move byte (8 bits)                                                                             |
| `addq`    | source\*    | destination | Add two values and store the result in `destination`                                           |
| `subq`    | source\*    | destination | Subtracts the source from the destination and stores the result in `destination`               |
| `incq`    | destination |             | Increment a value and store the result in `destination`                                        |
| `decq`    | destination |             | Decrement a value and store the result in `destination`                                        |
| `mulq`    | source      |             | Multiplies the source by `%rax` and stores the result in `%rax`.                               |
| `divq`    | source      |             | Divides the source by `%rax`, stores the result in `%rax`, and stores the remainder in `%rdx`. |
| `syscall` |             |             | Perform a system call. Args passed in registers. Kernel takes over                             |

\* = can be a literal.

## Syscalls

| Syscall | Number - `%rax` | `%rdi` |
| ------- | --------------- | ------ |
| exit    | 60              | code   |

### x86 vs x86-64

Migrated from `int 0x80` to `syscall`. Restructuring allowed:

- Perf improvements.
- Register changes (for even more perf).
