# Functions

## Syscalls

Places program on hold and switches control to the operating system kernel.

| Name    | Syscall                                     | `%rax`       | `%rdi`               | `%rsi`       | `%rdx`      | `%r10`, `%r8`, `%r9` | Returns (in `%rax`)           |
| ------- | ------------------------------------------- | ------------ | -------------------- | ------------ | ----------- | -------------------- | ----------------------------- |
| `write` | Write ASCII data (w/o null terminator)      | 1 - `0x01`   | file descriptor      | data pointer | data length |                      |                               |
| `brk`   | Move the program break (to allocate memory) | 12 - `0x0b`  | desired address or 0 |              |             |                      | Current address if 0 passed   |
| `exit`  | Exit the program with exit code             | 60 - `0x3c`  | code                 |              |             |                      | -                             |
| `time`  | Seconds since epoch (1 Jan 1970)            | 201 - `0xc9` | pointer to 64 bits   |              |             |                      | same pointer passed in `%rdi` |

Unused parameters will be ignored.

Most registers are preserved, with the following exceptions:

- `syscall` clobbers `%rcx` (with next instruction to execute upon return)
- `syscall` clobbers `%r11` (with contents of `%eflags`)
- Return value will be stored in `%rax`

Docs on syscalls:

- `man 2 syscalls`.
- `man 2 [name]` - where `[name]` is the name of the syscall.
- https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/
- https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

### File descriptors

OS gives files you open a number (file descriptors).

- `0`: StdIn - often input from keyboard
- `1`: StdOut - often output to console
- `2`: StdErr - often also output to console

## The Stack

OS preallocates memory for the stack (2mb default), then puts the pointer for the memory in `%rsp`.
Normally a pointer points to the beginning of a section of memory, but `%rsp` initially points to
the end.

- On `pushq`
  - `%rsp` is decremented to point to the next memory location.
  - The value gets copied to the location at `%rsp`
- On `popq`
  - Value gets read from the location at `%rsp`
  - `%rsp` is incremented to point at the previous memory location.

Arbitrary space can also be reserved/freed:

```gas
# Reserve 16 bytes:
subq $16, %rsp

# Free 16 bytes:
addq $16, %rsp
```

Notes

- Helpful for keeping parts of the program separate.
  - Don't need to know to much about what other code does, can be loosely coupled.
- Helpful for avoiding clobbering registers.
  - Can be pushed/popped from the stack when calling out to other functions.
- Need to remember to clean it up after use (e.g. everything pushed should be popped).

### Stack Frame Layout

```
                     ^  +-----------------------------+  ^
                     |  |                             |  | "Bottom" of the stack
Previous stack frame |  +-----------------------------+  | is this direction
                     +--|                             |  |
                        +-----------------------------+
                     +--| Return Address              |
                     |  +-----------------------------+
%rbp points here ----|->| Previous %rbp               |
                     |  +-----------------------------+
                     |  | Local variable 1:  -8(%rbp) |
Stack frame for the  |  +-----------------------------+     Each box represents
current function     |  | Local variable 2: -16(%rbp) |     a quadword
                     |  +-----------------------------+
                     |  | Local variable 3: -24(%rbp) |
                     |  +-----------------------------+
%rsp starts here --->+--| Local variable 4: -32(%rbp) |<-- "Top" of the stack
                        +-----------------------------+
                        |                             |  |
                        +-----------------------------+  | Stack grows
                        |                             |  | in this direction
                        +-----------------------------+  V
```

`%rbp` is fixed for the duration of a function, so local variables are referenced relative to it
(rather than `%rsp`, which moves).

## Calling Conventions

Conventions for function calls are known as the application binary interface (ABI). Linux uses the
`System V ABI`.

Full documentation: https://gitlab.com/x86-psABIs/x86-64-ABI

### Preservation of Registers

The contents of the following registers should be preserved:

- `%rbp`
- `%rbx`
- `%r12`
- `%r13`
- `%r14`
- `%r15`

If you want to use those registers, you should save the values (to memory or the stack) and restore
before returning.

Values in any other registers can be overwritten. Be aware that anything you store in them can be
clobbered by functions you call.

### Parameters

Positional, with the following order:

- `%rdi`
- `%rsi`
- `%rdx`
- `%rcx`
- `%r8`
- `%r9`

If there are more than 6 parameters, they get pushed to the stack as quadwords - with the last
parameter being pushed first. For example, to call `myfunc` with 10 parameters:

```gas
movq $1, %rdi
movq $2, %rsi
movq $3, %rdx
movq $4, %rcx
movq $5, %r8
movq $6, %r9
pushq $10
pushq $9
pushq $8
pushq $7
call myfunc
```

### Return Values

In the most common case (1 return value), it will be in `%rax`.

In the uncommon case (2+ return values):

- The ABI allows `%rdx` to be used.
- `%rax` can be a pointer to memory containing multiple values.
- A pointer to memory can be passed as a parameter, which the function can populate.

### Aligning the Stack

The stack is supposed to be aligned to a multiple of 16 bytes before every function call - the
address stored in `$rsp` should be a multiple of 16.

All function calls will store:

- The return address.
- The prior base pointer.

As these are quad-words, this means that calling a function will align to 16 bytes by default. All
we need to do is ensure that any subsequent stack allocations (e.g. in `enter`) are multiples of 16
bytes.

If calling a function which accepts arguments which overflow onto the stack, the stack will need to
be padded before pushing those arguments.

Many functions might not care about this requirement.

## Saving Data to the Stack

At the start of a function, you should:

- Save the value of `%rbp` (by pushing it to the stack)
  - This saves the previous base pointer, so you can unwind and return to it later.
  - Remember - The value in `%rbp` is supposed to be preserved (as defined in the ABI).
- Push the value of `%rsp` should be copied to `%rbp`.
  - This updates the base pointer to the new stack frame, so references to local variables will point to the right place.
- Subtract from `%rsp`.
  - This reserves space for local variables.

```gas
# Save the pointer to the previous stack frame
pushq %rbp

# Copy the stack pointer to the base pointer for a fixed reference point
movq %rsp, %rbp

# Reserve however much memory on the stack you need
subq $NUMBYTES, %rsp
```

At the end of the function, reverse the steps:

```gas
# Restore the stack pointer
movq %rbp, %rsp

# Restore the base pointer
popq %rbp
```

Note: Restoring the stack pointer implicitly unreserves the memory.

There are single instruction which do these steps for us:

```gas
enter $NUMBYTES, $0
# $0 arg can be used for closures.

leave
```

`enter` can be slower than the equivalent instructions, so some compilers will list them out
manually. `leave` tends to be faster.

Some functions are simple enough that all operations can be done in registers, in which case
`enter` and `leave` might not need to be called.

## Invoking and Returning

Address of next instruction to execute (aka return address) is pushed onto the stack before calling
a function, so we know where to resume from after returning.

```gas
  pushq $next_instruction_address
  jmp thefunction

next_instruction_address:
  # Next instruction here
```

There are single instructions which do these steps for us:

```gas
call thefunction

ret
```
