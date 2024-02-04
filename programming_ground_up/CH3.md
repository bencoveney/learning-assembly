# Syntax used

| Syntax          | Description                                                                            | Notes                                                  |
| --------------- | -------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `.whatever`     | Assembler directive or pseudo-operations                                               | Instruction for the assembler                          |
| `.section`      | Breaks the program up into sections                                                    | Is this required? Variant omits it                     |
| `.data`         | Data section, lists memory storage for data                                            |                                                        |
| `.text`         | Text section, lists program instructions                                               |                                                        |
| `.globl _start` | Instructs the assembler that `_start` is important to remember                         |                                                        |
| `.globl`        | Assembler shouldn't discard the symbol after assembly, because the linker will need it |                                                        |
| `_start`        | A "symbol" - used to mark locations of programs or data.                               | Saves having to keep track of addresses                |
| `_start:`       | Defines the value of a label                                                           | The value will be the next instruction or data element |
| `movl`          | An instruction                                                                         |                                                        |
| `$1`, `%eax`    | Operands for the instruction                                                           | Can be literals, memory location references, registers |
| `$1`            | Literal value                                                                          |                                                        |
| `%eax`          | register                                                                               |                                                        |

# Entry point

`_start` is special and needs to be marked as global, as it will be the entry point. If not provided, I think it will just begin at the start of the `.text` section.

# Instructions

| Name    | What it does                             | Operand 1        | Operand 2   | Notes                                                                   |
| ------- | ---------------------------------------- | ---------------- | ----------- | ----------------------------------------------------------------------- |
| `mov1`  | Transfers the source to the destination  | source           | destination |                                                                         |
| `addl`  | Add the source to the destination        | source           | destination |                                                                         |
| `subl`  | Subtract the source from the destination | source           | destination |                                                                         |
| `imull` | Multiply the source by the destination   | source           | destination |                                                                         |
| `idivl` | Divides `%eax` by the divisor            | divisor          |             | Requires `%edx` is zero. `%eax` gets quotient and `%edx` gets remainder |
| `int`   | Interrupt the normal program flow        | interrupt number |             |                                                                         |

Typically when instructions have 2 operands, the 1st is the source and the second is the destination. Source does not get modified at all.

# Registers

| Name      | Kind            |
| --------- | --------------- |
| `%eax`    | General purpose |
| `%ebx`    | General purpose |
| `%ecx`    | General purpose |
| `%edx`    | General purpose |
| `%edi`    | General purpose |
| `%esi`    | General purpose |
| `%ebp`    | Special purpose |
| `%esp`    | Special purpose |
| `%eip`    | Special purpose |
| `%eflags` | Special purpose |

# Operands

| Symbol | Example | Addressing mode                 |
| ------ | ------- | ------------------------------- |
| None   | `1`     | Direct addressing               |
| `$`    | `$1`    | Immediate mode                  |
| `$0x`  | `$0x80` | Immediate mode (in hexidecimal) |

# System call

When we trigger the interrupt, it transfers control over to whoever set the interrupt handler (in this case, it was the Linux kernel).

`%eax` contains the system call number (`$1` is exit). The exit system call requires that `%ebx` contains the exit code.

Different system calls will require different values in different registers.

# See Also

https://en.wikibooks.org/wiki/X86_Assembly/GNU_assembly_syntax#Generating_assembly
https://stackoverflow.com/questions/63543127/return-values-in-main-vs-start
https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_node/ld_24.html
https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_toc.html
https://stackoverflow.com/questions/52284829/difference-between-section-text-and-text-with-gas
