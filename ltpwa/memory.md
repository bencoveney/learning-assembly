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

| Register | Purpose                 | Known as          | Use                                              | Subdivisions                        |
| -------- | ----------------------- | ----------------- | ------------------------------------------------ | ----------------------------------- |
| `%rax`   | General - Computational | Accumulator       | Most widely used for computation.                | `%rax`, `%eax`, `%ax`, `%ah`, `%al` |
| `%rbx`   | General - Computational | Base              | Often used for indexed addressing.               | `%rbx`, `%ebx`, `%bx`, `%bh`, `%bl` |
| `%rcx`   | General - Computational | Counter           | Often used for counts in loops.                  | `%rcx`, `%ecx`, `%cx`, `%ch`, `%cl` |
| `%rdx`   | General - Computational | Data              | Special significance in some math/io operations. | `%rdx`, `%edx`, `%dx`, `%dh`, `%dl` |
| `%rsi`   | General - Pointers      | Source index      | Uses when working with longer spans of memory.   | `%rsi`, `%esi`, `%si`               |
| `%rdi`   | General - Pointers      | Destination index | Uses when working with longer spans of memory.   | `%rdi`, `%edi`, `%di`               |
| `%rbp`   | General - Pointers      | Base pointer      | Uses when working with longer spans of memory.   | `%rbp`, `%ebp`, `%bp`               |
| `%rsp`   | General - Pointers      | Stack pointer     | Uses when working with longer spans of memory.   | `%rsp`, `%esp`, `%sp`               |
| `%r8`    | General                 |                   |                                                  | `%r8`, `%r8w`, `%r8w`, `%r8b`       |
| ...      | ...                     | ...               | ...                                              | ...                                 |
| `%r15`   | General                 |                   |                                                  | `%r15`, `%r15w`, `%r15w`, `%r15b`   |

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

## Values

| Example | Kind            | Notes                   |
| ------- | --------------- | ----------------------- |
| $5      | Immediate value | Value of 5 (in decimal) |
| $0b0101 | Immediate value | Value of 5 (in binary)  |
