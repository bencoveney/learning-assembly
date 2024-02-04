# Syntax used

| Syntax        | Description                                                                                   | Notes                                                  |
| ------------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `.whatever`   | Assembler directive or pseudo-operations                                                      | Instruction for the assembler                          |
| `.section`    | Breaks the program up into sections                                                           | Is this required? Variant omits it                     |
| `.data`       | Data section, lists memory storage for data                                                   |                                                        |
| `.text`       | Text section, lists program instructions                                                      |                                                        |
| `.globl name` | Assembler shouldn't discard the `name` symbol after assembly, because the linker will need it |                                                        |
| `name:`       | Defines the value of a label                                                                  | The value will be the next instruction or data element |
| `movl`        | An instruction                                                                                |                                                        |
| `$1`, `%eax`  | Operands for the instruction                                                                  | Can be literals, memory location references, registers |
| `$1`          | Literal value                                                                                 |                                                        |
| `%eax`        | register                                                                                      |                                                        |

# Labels

Label names can contain letters or `_`.

`_start` is special and needs to be marked as global, as it will be the entry point. If not provided, I think execution will just begin at the start of the `.text` section.

# Instructions

| Name    | What it does                              | Operand 1        | Operand 2   | Notes                                                                   |
| ------- | ----------------------------------------- | ---------------- | ----------- | ----------------------------------------------------------------------- |
| `movl`  | Transfers the source to the destination   | source           | destination |                                                                         |
| `addl`  | Add the source to the destination         | source           | destination |                                                                         |
| `subl`  | Subtract the source from the destination  | source           | destination |                                                                         |
| `imull` | Multiply the source by the destination    | source           | destination |                                                                         |
| `idivl` | Divides `%eax` by the divisor             | divisor          |             | Requires `%edx` is zero. `%eax` gets quotient and `%edx` gets remainder |
| `int`   | Interrupt the normal program flow         | interrupt number |             |                                                                         |
| `cmpl`  | Compare two values                        | compared         | compared    | Result will also be stored in the `%eflags` status register             |
| `je`    | Jump if the second value was == the first | jump to          |             | Checked against the `%eflags` register                                  |
| `jg`    | Jump if the second value was > the first  | jump to          |             | Checked against the `%eflags` register                                  |
| `jge`   | Jump if the second value was >= the first | jump to          |             | Checked against the `%eflags` register                                  |
| `jl`    | Jump if the second value was < first      | jump to          |             | Checked against the `%eflags` register                                  |
| `jle`   | Jump if the second value was <= first     | jump to          |             | Checked against the `%eflags` register                                  |
| `jmp`   | Jump unconditionally                      | jump to          |             |                                                                         |

The `l` in `movl` (and others) means `long`.

Typically when instructions have 2 operands, the 1st is the source and the second is the destination. Source does not get modified at all.

# Registers

| Name                              | Kind            |
| --------------------------------- | --------------- |
| `%eax`                            | General purpose |
| `%ebx`                            | General purpose |
| `%ecx`                            | General purpose |
| `%edx`                            | General purpose |
| `%edi`                            | General purpose |
| `%esi`                            | General purpose |
| `%ebp`                            | Special purpose |
| `%esp`                            | Special purpose |
| `%eip`                            | Special purpose |
| `%eflags` (flags/status register) | Special purpose |

# Operands

| Symbol                       | Example               | Addressing mode            |
| ---------------------------- | --------------------- | -------------------------- |
| None                         | `1`                   | Direct addressing          |
| `$`                          | `$1`                  | Immediate                  |
| `$0x`                        | `$0x80`               | Immediate (in hexidecimal) |
| `beginning(,index,itemSize)` | `data_items(,%edi,4)` | Indexed                    |

# System call

When we trigger the interrupt, it transfers control over to whoever set the interrupt handler (in this case, it was the Linux kernel).

`%eax` contains the system call number (`$1` is exit). The exit system call requires that `%ebx` contains the exit code.

Different system calls will require different values in different registers.

# Sections

| Name | Syntax                      | Purpose                           |
| ---- | --------------------------- | --------------------------------- |
| data | `.section .data` or `.data` | Contains memory storage for data. |
| text | `.section .text` or `.text` | Contains program instructions.    |

# Data items

The "Maximum" program uses the data segment for a list of items:

```s
  .section .data
data_items:
  .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
```

`data_items:` at the beginning defines a label. `.long` causes the assembler to reserve memory for the list of numbers that follows.

When we refer to `data_items` in the program, the assembler will give us the address of _the first item_ in the list. So `movl data_items, %eax` would move `$3` into `%eax`.

Because the sequence has 14 items, the assembler will reserve space for 14 longs. Each one is 4 bytes, so assembler will reserve `14 x 4 = 56` bytes for this value.

We are using 0 to identify the end of the list, we will need to check for this ourselves in the code. An alternative method would be to hardcode the length somewhere.

We do not mark `data_items` as a `.globl` - because it is only used from this program, no other programs will need to know about `data_items`.

| Type     | Storage locations (bytes) | Notes                                                                                            |
| -------- | ------------------------- | ------------------------------------------------------------------------------------------------ |
| `.byte`  | 1                         | Range from 0 to 255.                                                                             |
| `.int`   | 2                         | Range from 0 to 65535.                                                                           |
| `.long`  | 4                         | Range from 0 to 4294967295. Matches 32 bit register size.                                        |
| `.ascii` | 1 per character           | Values wrapped in double quotes. Escapes (e.g. terminator `\0`, newline `\n`) are one character. |

# See Also

https://en.wikibooks.org/wiki/X86_Assembly/GNU_assembly_syntax#Generating_assembly
https://stackoverflow.com/questions/63543127/return-values-in-main-vs-start
https://ftp.gnu.org/old-gnu/Manuals/ld-2.9.1/html_node/ld_24.html
https://ftp.gnu.org/old-gnu/Manuals/gas-2.9.1/html_chapter/as_toc.html
https://stackoverflow.com/questions/52284829/difference-between-section-text-and-text-with-gas
