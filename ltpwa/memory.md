# Memory

## Sizes

| Size (bits) | Size (bytes) | Known as               | Suffix |
| ----------- | ------------ | ---------------------- | ------ |
| 1           |              | bit                    |        |
| 8           | 1            | byte                   | `b`    |
| 16          | 2            | word, short            | `w`    |
| 32          | 3            | double-word, int, long | `d`    |
| 64          | 4            | quad-word              | `q`    |

Some names are reused depending on context, which makes things confusing. "Wordsize" should be based on the architecture, but stayed the same for compatibility.

## Registers

| Register  | Purpose                 | Known as          | Use                                              | Subdivisions                        |
| --------- | ----------------------- | ----------------- | ------------------------------------------------ | ----------------------------------- |
| `%rax`    | General - Computational | Accumulator       | Most widely used for computation.                | `%rax`, `%eax`, `%ax`, `%ah`, `%al` |
| `%rbx`    | General - Computational | Base              | Often used for indexed addressing.               | `%rbx`, `%ebx`, `%bx`, `%bh`, `%bl` |
| `%rcx`    | General - Computational | Counter           | Often used for counts in loops.                  | `%rcx`, `%ecx`, `%cx`, `%ch`, `%cl` |
| `%rdx`    | General - Computational | Data              | Special significance in some math/io operations. | `%rdx`, `%edx`, `%dx`, `%dh`, `%dl` |
| `%rsi`    | General - Pointers      | Source index      | Uses when working with longer spans of memory.   | `%rsi`, `%esi`, `%si`               |
| `%rdi`    | General - Pointers      | Destination index | Uses when working with longer spans of memory.   | `%rdi`, `%edi`, `%di`               |
| `%rbp`    | General - Pointers      | Base pointer      | Uses when working with longer spans of memory.   | `%rbp`, `%ebp`, `%bp`               |
| `%rsp`    | General - Pointers      | Stack pointer     | Uses when working with longer spans of memory.   | `%rsp`, `%esp`, `%sp`               |
| `%r8`     | General                 |                   |                                                  | `%r8`, `%r8w`, `%r8w`, `%r8b`       |
| ...       | ...                     | ...               | ...                                              | ...                                 |
| `%r15`    | General                 |                   |                                                  | `%r15`, `%r15w`, `%r15w`, `%r15b`   |
| `%rip`    | Special purpose         | Instruction       | Points to memory location of next instruction    | `%rip`                              |
| `%eflags` | Special purpose         | Flags             | Holds status of previous operation               | 32-bit                              |

### Register sizes

```
Most significant bits                          Least significant bits
<--------------------                          --------------------->

 63                                                                0
+--------------------------------+----------------+--------+--------+
|                                |                |        |        |
+--------------------------------+----------------+--------+--------+

                                                  |--%ah---|
                                                           |--%al---|
                                                  |-------%ax-------|
                                 |---------------%eax---------------|
|------------------------------%rax---------------------------------|
```

- `%ah` - High
- `%al` - Low
- `%ax` - Where we started
- `%eax` - "extended"
- `%rax` - dunno

### `%eflags`

| Flag | Name       | Role                                                                                       |
| ---- | ---------- | ------------------------------------------------------------------------------------------ |
| `ZF` | Zero flag  | Set to 1 if the result of the last arithmetic operation was 0, otherwise 0                 |
| `CF` | Carry flag | Set to 1 if the last arithmetic resulted in a carry (overflow) in the destination register |

## Values

| Example                      | Addressing Mode                           | Notes                                                              |
| ---------------------------- | ----------------------------------------- | ------------------------------------------------------------------ |
| `$5`                         | Immediate mode                            | Value of 5 (in decimal)                                            |
| `$0b0101`                    | Immediate mode                            | Value of 5 (in binary)                                             |
| `$'z'`                       | Immediate mode                            | ASCII value of the char literal 'z'                                |
| `$label`                     | Immediate mode                            | Memory address of label                                            |
| `%rax`                       | Register mode                             | Value from the register                                            |
| `label`                      | Direct mode                               | Value (at the memory address) of label                             |
| `(%rax)`                     | Register indirect mode                    | Looks up the value from the memory address stored in the register  |
| `numbers(,%rbx,8)`           | Indexed mode                              | Look up the index-th value from the array at the specified address |
| `offset(basepointer)`        | Base pointer mode (aka displacement mode) |                                                                    |
| `offset(basepointer,%rbx,8)` | Base pointer indexed mode                 |                                                                    |
|                              | Program counter relative mode             |                                                                    |

### General addressing mode

```
VALUE(BASEREG, IDXREG, MULTIPLIER)
```

Calculated as:

```
address = VALUE + BASEREG + IDXREG * MULTIPLIER
```

| Part         | Value                             | Default |
| ------------ | --------------------------------- | ------- |
| `VALUE`      | Fixed value                       | 0       |
| `BASEREG`    | Register                          | 0       |
| `IDX`        | Register                          | 0       |
| `MULTIPLIER` | Fixed value: 1, 2, 4 or 8 (bytes) | 1       |

Sometimes `VALUE` can be a calculation, like `label-8` - Don't really know when this is permitted.

#### Example

```
movq VALUE(%rbx, %rdi, 2), %rax
```

- Look up the memory address in the `BASEREG` `%rbx`.
- Add the offset `VALUE` to that base address.
- Then step `%rdi` times, with steps of size `2`.
- Load the _value_ at that final location into `%rax`

## Data Sections

```gas
label:
  .size value [, value, value...]
```

Can be read from and written to. Generally need to move values to registers to use/manipulate them.

### Sizes

| Directive | Size    |
| --------- | ------- |
| `.byte`   | 1 byte  |
| `.quad`   | 4 bytes |

### Lists

```gas
mynumbers:
  .quad 5, 20, 33, 80, 52, 10, 1
```

Common ways of identifying the end of the list:

- A "sentinel" - special value identifying the end of the list (e.g. 0).
  - Easiest to program.
- Memory location identifying the end, stored in another label.
  - Useful for static data.
- Number of elements in list, stored in another location.
  - Useful for variable-length arrays.

```gas
numberofnumbers:
  .quad 7
mynumbers:
  .quad 5, 20, 33, 80, 52, 10, 1
```

### Arrays

Can use constants and compile-time evaluation to calculate the length of array, between 2 labels (the starting and ending memory address).

```gas
.equ PERSON_RECORD_SIZE, 32
numpeople:
  .quad (endpeople - people) / PERSON_RECORD_SIZE
people:
  .quad 250, 3, 75, 24
  .quad 250, 4, 70, 11
  .quad 180, 5, 69, 65
endpeople:
```

## Records/Structs/Structures

Well defined segment of data, with multiple parts laid out in a specific way in memory.

E.g. "person" with 4 properties stored as quadwords

```
High addresses      |      |
                    +------+ <-- End of record (start + 32 -1)
                    |      |
                    +------+ <-- Location of age (start + 24)
                    |      |
                    +------+ <-- Location of height (start + 16)
                    |      |
                    +------+ <-- Location of hair colour (start + 8)
                    |      |
Start of record --> +------+ <-- Location of weight (start + 0)
Low addresses       |      |
```

Common to set the offsets as constants - e.g:

```gas
.equ WEIGHT_OFFSET, 0
.equ HAIR_COLOUR_OFFSET, 8
.equ HEIGHT_OFFSET, 16
.equ AGE_OFFSET, 24
.globl WEIGHT_OFFSET, HAIR_COLOUR_OFFSET, HEIGHT_OFFSET, AGE_OFFSET

# Alternative method:
.equ WEIGHT_OFFSET, 0
.equ HAIR_COLOUR_OFFSET, WEIGHT_OFFSET + 8
.equ HEIGHT_OFFSET, HAIR_COLOUR_OFFSET + 8
.equ AGE_OFFSET, HEIGHT_OFFSET + 8
.globl WEIGHT_OFFSET, HAIR_COLOUR_OFFSET, HEIGHT_OFFSET, AGE_OFFSET
```

## ASCII

```gas
mytext:
  .ascii "This is a string of characters.\0"
```

Equivalent to:

```gas
mytext:
  .byte 84, 104, 105, 115, 32, 105, 115, 32, 97, 32, 115
  .byte 116, 114, 105, 110, 102, 32, 111, 102, 32, 99
  .byte 104, 97, 114, 97, 99, 116, 101, 114, 115, 46, 0
```

Each ASCII character is 1 byte. Need to use byte operations and registers.
Compatible with UTF-8.
Terminated (end is marked) with a null character.

- Capital letters start at 65,
- Lowercase start at 97
- Numbers start at 48
- 32 is a space

| Code | Represents |
| ---- | ---------- |
| `\0` | Null       |
| `\n` | Newline    |
| `\t` | Tab        |
| `\\` | Backslash  |

You can have literal ASCII chars in assembly, e.g.:

```gas
movb $'a', %al
```
