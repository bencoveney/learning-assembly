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

| Register        | Purpose                 | Known as          | Use                                              | Subdivisions                        |
| --------------- | ----------------------- | ----------------- | ------------------------------------------------ | ----------------------------------- |
| `%rax`          | General - Computational | Accumulator       | Most widely used for computation.                | `%rax`, `%eax`, `%ax`, `%ah`, `%al` |
| `%rbx`          | General - Computational | Base              | Often used for indexed addressing.               | `%rbx`, `%ebx`, `%bx`, `%bh`, `%bl` |
| `%rcx`          | General - Computational | Counter           | Often used for counts in loops.                  | `%rcx`, `%ecx`, `%cx`, `%ch`, `%cl` |
| `%rdx`          | General - Computational | Data              | Special significance in some math/io operations. | `%rdx`, `%edx`, `%dx`, `%dh`, `%dl` |
| `%rsi`          | General - Pointers      | Source index      | Used when working with longer spans of memory.   | `%rsi`, `%esi`, `%si`               |
| `%rdi`          | General - Pointers      | Destination index | Used when working with longer spans of memory.   | `%rdi`, `%edi`, `%di`               |
| `%rbp`          | General - Pointers      | Base pointer      | Used when working with longer spans of memory.   | `%rbp`, `%ebp`, `%bp`               |
| `%rsp`          | General - Pointers      | Stack pointer     | Used when working with longer spans of memory.   | `%rsp`, `%esp`, `%sp`               |
| `%r8`           | General                 |                   |                                                  | `%r8`, `%r8w`, `%r8w`, `%r8b`       |
| ...             | ...                     | ...               | ...                                              | ...                                 |
| `%r15`          | General                 |                   |                                                  | `%r15`, `%r15w`, `%r15w`, `%r15b`   |
| `%xmm0/%xmm1`   | SSE                     |                   | Floating point, SIMD                             | `%xmm0`, `%xmm1`                    |
| ...             | ...                     | ...               | ...                                              | ...                                 |
| `%xmm14/%xmm15` | SSE                     |                   | Floating point, SIMD                             | `%xmm14`, `%xmm15`                  |
| `%rip`          | Special purpose         | Instruction       | Points to memory location of next instruction    | `%rip`                              |
| `%eflags`       | Special purpose         | Flags             | Holds status of previous operation               | 32-bit                              |

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

- First 16 are `flags`
- First 32 are `eflags`
- First 64 are `rflags`

| Bit   | Mask          | Abbrev | Name                      | Category | If `=1`                                                                              |
| ----- | ------------- | ------ | ------------------------- | -------- | ------------------------------------------------------------------------------------ |
| 0     | `0x0000 0001` | `CF`   | Carry flag                | Status   | Last arithmetic operation resulted in a carry (overflow) in the destination register |
| 1     | `0x0000 0002` | -      | Reserved                  | -        | Always - always 1                                                                    |
| 2     | `0x0000 0004` | `PF`   | Parity Flag               | Status   | Last operation resulted in a value which has an even number of bits set to 1         |
| 3     | `0x0000 0008` | -      | Reserved                  | -        | Never - always 0                                                                     |
| 4     | `0x0000 0010` | `AF`   | Auxiliary Carry flag      | Status   | ?                                                                                    |
| 5     | `0x0000 0020` | -      | Reserved                  | -        | Never - always 0                                                                     |
| 6     | `0x0000 0040` | `ZF`   | Zero flag                 | Status   | Last operation resulted in 0                                                         |
| 7     | `0x0000 0080` | `SF`   | Sign flag                 | Status   | Last operation set the sign flag                                                     |
| 8     | `0x0000 0100` | `TF`   | Trap flag                 | Control  | Enables single-step mode                                                             |
| 9     | `0x0000 0200` | `IF`   | Interrupt Enable flag     | Control  | The processor will respond immediately to maskable hardware interrupts               |
| 10    | `0x0000 0400` | `DF`   | Direction flag            | Control  | String will be processed from highest to lowest address (auto-decrementing)          |
| 11    | `0x0000 0800` | `OF`   | Overflow flag             | Status   | Last arithmetic operation resulted in a overflow for _signed_ numbers                |
| 12    | `0x0000 1000` | `IOPL` | I/O Privilege Level       | System   | -                                                                                    |
| 13    | `0x0000 2000` | `IOPL` | I/O Privilege Level       | System   | -                                                                                    |
| 14    | `0x0000 4000` | `NT`   | Nested task flag          | System   | -                                                                                    |
| 15    | `0x0000 8000` | `MD`   | Mode flag                 | Control  | -                                                                                    |
| 16    | `0x0001 0000` | `RF`   | Resume flag               | System   | -                                                                                    |
| 17    | `0x0002 0000` | `VM`   | Virtual 8086 mode         | System   | -                                                                                    |
| 18    | `0x0004 0000` | `AC`   | Alignment check           | System   | -                                                                                    |
| 19    | `0x0008 0000` | `VIF`  | Virtual interrupt flag    | System   | -                                                                                    |
| 20    | `0x0010 0000` | `VIP`  | Virtual interrupt pending | System   | -                                                                                    |
| 21    | `0x0020 0000` | `ID`   | Able to use CPUID         | System   | -                                                                                    |
| 22    | `0x0040 0000` | -      | Reserved                  | -        | -                                                                                    |
| 23    | `0x0080 0000` | -      | Reserved                  | -        | -                                                                                    |
| 24    | `0x0100 0000` | -      | Reserved                  | -        | -                                                                                    |
| 25    | `0x0200 0000` | -      | Reserved                  | -        | -                                                                                    |
| 26    | `0x0400 0000` | -      | Reserved                  | -        | -                                                                                    |
| 27    | `0x0800 0000` | -      | Reserved                  | -        | -                                                                                    |
| 28    | `0x1000 0000` | -      | Reserved                  | -        | -                                                                                    |
| 29    | `0x2000 0000` | -      | Reserved                  | System   | -                                                                                    |
| 30    | `0x4000 0000` | -      | AES key schedule flag     | System   | -                                                                                    |
| 31    | `0x8000 0000` | `AI`   | Alternate instruction set | System   | -                                                                                    |
| 32-63 | ...           | -      | Reserved                  | -        | -                                                                                    |

## Values

| Example                      | Addressing Mode                           | Notes                                                                                      |
| ---------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------ |
| `$5`                         | Immediate mode                            | Value of 5 in decimal                                                                      |
| `$0b0101`                    | Immediate mode                            | Value of 5 in binary                                                                       |
| `$0x05`                      | Immediate mode                            | Value of 5 in hexidecimal                                                                  |
| `$05`                        | Immediate mode                            | Value of 5 in octal (any number with a 0 prefix)                                           |
| `$'z'`                       | Immediate mode                            | ASCII value of the char literal 'z'                                                        |
| `$label`                     | Immediate mode                            | Memory address of label                                                                    |
| `%rax`                       | Register mode                             | Value from the register                                                                    |
| `label`                      | Direct mode                               | Value (at the memory address) of label                                                     |
| `(%rax)`                     | Register indirect mode                    | Looks up the value from the memory address stored in the register                          |
| `numbers(,%rbx,8)`           | Indexed mode                              | Look up the index-th value from the array at the specified address                         |
| `offset(basepointer)`        | Base pointer mode (aka displacement mode) |                                                                                            |
| `offset(basepointer,%rbx,8)` | Base pointer indexed mode                 |                                                                                            |
| `label(%rip)`                | Program counter relative mode             | Uses labelled data offsets relative to the instruction, allowing position-independent code |

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

## Endianness

x86-64 ia little endian.

Big endian is sometimes called network byte order.

Given this data:

```
10000000 11000000 11100000 11110000 11111000 11111100 11111110 11111111
```

Little endian is:

1. `11111111`
2. `11111110`
3. `11111100`
4. `11111000`
5. `11110000`
6. `11100000`
7. `11000000`
8. `10000000`

Big endian is:

1. `10000000`
2. `11000000`
3. `11100000`
4. `11110000`
5. `11111000`
6. `11111100`
7. `11111110`
8. `11111111`

Given this data:

```gas
.ascii: "Foo Bar!"
```

Little endian is:

1. `!`
2. `r`
3. `a`
4. `B`
5. ` `
6. `o`
7. `o`
8. `F`

Big endian is:

1. `F`
2. `o`
3. `o`
4. ` `
5. `B`
6. `a`
7. `r`
8. `!`

### Example

We load this as a quadword. It will be reversed because it is little endian:

```gas
.ascii: "Foo Bar!"
```

```
'!' 'r' 'a' 'B' ' ' 'o' 'o' 'F'
                        \al/\ah/
                \-----eax------/
\--------------rax-------------/
```

`rol` and `ror` will rotate the register left/right by the specified number of bits.

e.g. `ror $16, %rax` will give:

```
'o' 'F' '!' 'r' 'a' 'B' ' ' 'o'
                        \al/\ah/
                \-----eax------/
\--------------rax-------------/
```

By loading multiple bytes into a register at once, we can save on memory accesses (which might be slow).

## Signed integers

Most instruction sets (incl x86-64) use "Two's complement":

- Positive numbers count up from 0.
- Negative numbers cound back from 0.

In order of bits:

- `0b00000000` = `0`
- `0b00000001` = `1`
- ...
- `0b01111110` = `126`
- `0b01111111` = `127`
- `0b10000000` = `-128`
- `0b10000001` = `-127`
- ...
- `0b11111110` = `-2`
- `0b11111111` = `-1`

In order of values:

- `0b10000000` = `-128`
- `0b10000001` = `-127`
- ...
- `0b11111110` = `-2`
- `0b11111111` = `-1`
- `0b00000000` = `0`
- `0b00000001` = `1`
- ...
- `0b01111110` = `126`
- `0b01111111` = `127`

Properties:

- First bit (AKA sign bit/flag) tells us if the number is negative.
- Operations which cause wraps (e.g. adding 1 to `0b01111111`) are "overflows".
- Values (for 1 byte size) range from -128 to 127 - 0 occupies a spot in the positive range.

Size of a value can be increased through sign extension - repeating the sign bit

- e.g. `0b01001101` = `77` = `0b0000000001001101`
- e.g. `0b10110011` = `-77` = `0b1111111110110011`

To obtain a negative value (`negq` instruction): Flip all the bits and add 1

- e.g. `5` = `0b00000101` => `0b11111010` => `0b11111011` = `-5`
- e.g. `-5` = `0b11111011` => `0b00000100` => `0b00000101` = `5`

## Floating-Point Numbers

Decimal numbers are stored at a fixed level of precision, in 3 parts:

- Sign
- Exponent
- Mantissa

E.g: `1.2345.2` Can be represented as:

- Sign: Positive
- Mantissa: 1.23452
- Exponent: 4

However, computers work in base 2, so all numbers are stored as IEEE 754 floats:

```
+/- X.XXXXX * 2^X.XXXX
```

| Wordsize | Sign  | Mantissa | Exponent |
| -------- | ----- | -------- | -------- |
| 64 bit   | 1 bit | 52 bits  | 11 bits  |
| 32 bit   | 1 bit | 23 bits  | 8 bits   |

Can lead to weird cases, E.g: `1 + 16777216.0` is not significant enough to make a change. Can lead
to scenarios where the order of operations impacts the output.

Computers are much slower at floating-point operations than integers.

### SSE Registers

SSE is "Streaming SIMD Extensions", and SIMD is "Single Instruction Multiple Data".

Initial registers (for floating point) were `%mm0` to `%mm7` - each 64 bits wide. They are still
present and can be used

Current registers are `%xmm0` to `%xmm15`, which form 8 double-wide registers. Each one can be
"Packed" and treated as:

- 2 64-bit values.
- 4 32-bit values.
- 8 16-bit values.
- 16 8-bit values.

## Memory Layout

- Memory arranged into physical blocks called pages.
- OS's use virtual memory to keep process isolated. Manages assignment of pages to programs.
  - Some pages can be offloaded from RAM to Hard Drive (swap space).
- We see pointers to virtual addresses (in our "address space"), rather than actual physical memory addresses.
- 64 bit addresses mean 16 exibytes of addressable RAM. In practice Linux is limited to 47 bits (128 terabytes).

Linux process layout is roughly:

- _Unmapped_ + kernel shared memory (inaccessible)
- The stack
- _Unmapped_
- Dynamically loaded libraries
- _Unmapped_
- The heap
- _Unmapped_
- Uninitized data (`.bss`)
- Global data (`.data`)
- Read-only data (`.rodata`)
- Program code (`.text`)
- Reserved kernel memory (inaccessible)

Unmapped regions can be randomized for security.

```
High memory     +----------+ "bottom of the stack"
addresses       | inactive |
(top of memory) |  stack   |
                |  frame   | <- Return address
                +----------+
                | inactive |
                |  stack   |
                |  frame   | <- Return address
           |    +----------+
    Stack  |    |  active  | <- Base pointer `%ebp`
    grows  |    |  stack   |
    down   |    |  frame   | <- Stack pointer `%esp`
           |    +----------+ "top of the stack"
           V    |          |
                |          |
                |          |
                |          |
                |          |
                |          |
           ^    |          |
           |    +----------+
    Heap   |    |          |
    grows  |    | heap     |
    up     |    |          |
           |    +----------+
                | static   |
                | data     |
                | (bss)    |
                +----------+
                | program  |
Low memory      | text     |
addresses       +----------+
(bottom         | reserved |
of memory)      +----------+
```

## The Heap

Program can request memory as it runs, which OS _may_ allocate if available. This will make more
addresses available to your program. The "Program Break" is the point where the valid addresses end
for your program - and can be moved by the OS.

### C Malloc and Free

- C allocates some memory.
- Program asks C for some memory (`malloc` - memory allocate).
- If there is memory free, it will be granted.
- C may ask OS for more (ie ask to move the program break) to satisfy request.
- After memory is used, the program can call `free` to return the memory to C.

`malloc`:

- Takes 1 argument, the amount of memory to reserve.
- Returns the address of the allocated memory.

`free`:

- Takes 1 argument, the memory to free.
- Returns nothing.

Need to obey these rules:

- `free` anything you `malloc`.
- Don't use pointers to memory which have been `free`-d.
- Don't `free` an address which wasn't allocated by `malloc`.
- Don't call `free` on the same address multiple times.

Things that can go wrong:

- "Memory Leak" - Allocating memory without freeing it.
- "Buffer Overflow" - Writing beyond a heap-allocated buffer.
- "Stack Overflow" - Writing beyond a stack-allocated buffer(?).

### brk

Asks the OS to move the program break, effectively allocating more memory.

### mmap

Asks the OS to allocate a larger block of memory. Memory will be allocated in page-size increments
(4096 bytes on x86-64) - if you request other sizes the OS will round up to that size. Target
address can be specified, but Linux can/will override your request.

mmap is extremely flexible, e.g. you can use it to map files to memory (with reading + writing).

Parameters:

- `%rax`: `0x09` as the system call number.
- `%rdi`: Requested target address.
  - If provided, Linux can override it.
  - If null, let Linux decide.
- `%rsi`: Length of allocation.
  - In bytes.
  - Best to be a multiple of 4096 as this is what will be allocated.
- `%rdx`: Protection flags - Many available:
  - `0x01` for read-only.
  - `0x03` for read-write.
- `%r10`: General flags - Many available:
  - `MAP_PRIVATE` flag (`0x02`) for most purposes.
  - `MAP_ANONYMOUS` flag (`0x20`) if not file based - Linux will ignore the file descriptor.
- `%r8`: File descriptor.
  - If mapping a file, the file descriptor from a previous system call.
  - If not mapping a file, this should be -1.
- `%r9`: Offset.
  - If mapping a file, where within the file should you start.
  - If not mapping a file, this should be 0.

Returns (in `%rax`):

- If successful, the memory address of the allocated memory.
- If not, -1.

Example 0 requesting a memory block that is 2 pages long:

```gas
movq $9, %rax    # mmap syscall number
movq $0, %rdi    # Linux chooses destination
movq $8192, %rsi # Two pages of memory
movq $0x03, %rdx # Memory should be read-write
movq $0x22, %r10 # Requesting private memory not tied to a file
movq $-1, %r8    # No file descriptor attached
movq $0, %r9     # No offset required
syscall
# Result in %rax
```

munmap returns memory to the operating system. - accepts:

- `%rax`: `0x0b` as the system call number.
- `%rdi`: Memory address to unmap.
- `%rsi`: Size of memory to unmap.

### Memory Pools

Allocate/deallocate in groups, for example:

- Server receives a request.
- Server allocates memory (multiple times from a pool) for handling that request.
- Server processes request and returns a response.
- Server deallocates all memory (for that request's pool) at once.

Useful for patterns where groups of allocations share a lifetime.

### Reference Counting

Reference counter stored on the memory saying how many parts of the program are using it.

- Add one to counter when part of the program starts to use a piece of memory.
- Subtract one from counter when part of the program stops using the piece of memory.
- When the count drops to zero, it is done being used and can be derefereced.

This adds overhead because the program repeatedly needs to add/remove from the counter.

Can have problems if:

- There are circular references, because those will maintain 1 on the counter.
- A fresh object is returned from a function, what should its counter be?

### Garbage Collection

Program allocates, but doesn't need to explicitly deallocate. The garbage collector performs sweeps
and works out what is no longer being referenced by the rest of the program.

- Walk all allocations and mark them all as free.
- Start with a set of base memory regions:
  - `.data`
  - `.bss`
  - The stack
- Work out from there, looking for anything that looks like a pointer.
- For any pointer found, push it onto the stack.
- Iterate through the stack and:
  - Walk through allocations and check if it is a real pointer.
  - If it is a pointer, check if it is in use.
    - If in use, skip
    - If not in use, mark it as in use, and add any pointers within the block to the stack.

By starting from a base region and working out, we avoid the problem of circular references (see
reference counting).

Relies on some assumptions to identify references between objects:

- Pointers will be stored on 8 byte boundaries
- When GC is called, there will not be any pointers in registers that aren't stored elsewhere.

This GC design is "conservative" because it assumes anything that could be a pointer is a pointer.
If we were in charge of the language we could make smarter decisions about what is/isn't a pointer.

### Finalisers

Sometimes you'd like to know when something is deallocated (and have an opportunity to run some
code), e.g. to close a file when no longer in use.

Also known as destructors. Can be added to any memory management system.

Requirements:

- Add a spot in the memory header to store a finalizer.
- Add a function call to set the finalizer.
- Execute the finalizer before deallocating.
