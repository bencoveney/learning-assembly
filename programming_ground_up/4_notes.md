# Function parts

| Part             | Role                                                                                            |
| ---------------- | ----------------------------------------------------------------------------------------------- |
| Name             | Symbol that represents the address where the code starts.                                       |
| Parameters       | (0-N) data items passed in to the function for processing.                                      |
| Local variables  | Used while function is processing and then thrown away.                                         |
| Static variables | Reused each time the function is processing and not thrown away.                                |
| Global variables | Used by the function but not managed by it.                                                     |
| Return address   | "Invisible" parameter, not used by the function, execution resumes there when function returns. |
| Return value     | Value transferred from the function back to the rest of the program.                            |

# Stack

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

# Stack instructions

| Instruction          | Operands       | Behaviour                             | %esp           |
| -------------------- | -------------- | ------------------------------------- | -------------- |
| `pushl`              | Register/value | Push register/memory value onto stack | Decreased by 4 |
| `popl`               | Register       | Pop register/memory value off stack   | Increased by 4 |
| `movl (%esp), %eax`  | n/a            | Read value at top of stack            | Accessed       |
| `movl 4(%esp), %eax` | n/a            | Read value below top of stack         | Accessed       |

# Function calling

| Instruction       | Action                                                                  | Responsibility     |
| ----------------- | ----------------------------------------------------------------------- | ------------------ |
| `pushl` ...       | Push parameters onto stack in reverse order                             | Calling code       |
| `call`            | Passing location of function instructions                               | Calling code       |
|                   | Return address (next instr) pushed to stack. `%eip + 4`?                | `call` instruction |
|                   | `%eip` moved to function instructions                                   | `call` instruction |
| `pushl %ebp`      | Save current base pointer register. Used for accessing params/variables | Called code        |
| `movl %esp, %ebp` | Copy old base pointer to `%ebp`, to allow stack to be "unwound" later   | Called code        |
| `subl $8, %esp`   | Reserve space for variables (2 words in this example)                   | Called code        |

## Stack after loading params

| Value        | How to access |
| ------------ | ------------- |
| Parameter #N |               |
| Parameter 2  |               |
| Parameter 1  |               |

## Stack after `call`

| Value          | How to access |
| -------------- | ------------- |
| Parameter #N   |               |
| Parameter 2    |               |
| Parameter 1    |               |
| Return Address | `(%esp)`      |

## Stack after called code updates stack pointers

| Value          | How to access         |
| -------------- | --------------------- |
| Parameter #N   | `N*4+4(%ebp)`         |
| Parameter 2    | `12(%ebp)`            |
| Parameter 1    | `8(%ebp)`             |
| Return Address | `4(%ebp)`             |
| Old `%ebp`     | `(%ebp)` and `(%esp)` |

## Stack after called code reserves space for variables

| Value            | How to access           |
| ---------------- | ----------------------- |
| Parameter #N     | `N*4+4(%ebp)`           |
| Parameter 2      | `12(%ebp)`              |
| Parameter 1      | `8(%ebp)`               |
| Return Address   | `4(%ebp)`               |
| Old `%ebp`       | `(%ebp)`                |
| Local variable 1 | `-4(%ebp)`              |
| Local variable 2 | `-8(%ebp)` and `(%esp)` |

# Function returning

| Instruction       | Action                                                                        | Responsibility    |
| ----------------- | ----------------------------------------------------------------------------- | ----------------- |
|                   | Store the return value in `%eax`                                              | Called code       |
| `movl %ebp, %esp` | Restore the stack pointer `%esp` to where it was at the beginning of the call | Called code       |
| `popl %ebp`       | Restore the base pointer `%ebp` (and `%esp`) for the calling function         | Called code       |
| `ret`             | Return to the calling function                                                | Called code       |
|                   | Pops the return instruction into `%eip`                                       | `ret` instruction |
|                   | Continue execution from the updated `%eip`                                    | `ret` instruction |
|                   | Access return value by reading `%eax`                                         | Calling code      |
|                   | (Optionally) pop all parameters back off the stack                            | Calling code      |

# Register caveats

When calling functions, consider all registers to be wiped out. The only register the called function will try to preserve is `%ebp`. `%eax` will almost always be overwritten by the return value, and others should be considered dirty too.

To work around this, you can push the registers to the stack before calling the function, and pop them afterwards.

According to [wikipedia](https://en.wikipedia.org/wiki/X86_calling_conventions#cdecl):

> If the return values are Integer values or memory addresses they are put into the EAX register by the callee, whereas floating point values are put in the ST0 x87 register. Registers EAX, ECX, and EDX are caller-saved, and the rest are callee-saved. The x87 floating point registers ST0 to ST7 must be empty (popped or freed) when calling a new function, and ST1 to ST7 must be empty on exiting a function. ST0 must also be empty when not used for returning a value.

# Calling conventions in x86 and x86-64

For x86, the calling conventions were `cdecl` (`System V Intel386 ABI`?), which mandated parameters be passed on the stack.

On x86-64, the calling conventions are `System V AMD64 ABI`, which mandeted parameters be passed in registers.

This can be demonstrated by compiling the following C code (in godbolt):

```c
int square(int num) {
    return num * num;
}

int squareDoubled(num) {
    return square(num) + square(num);
}
```

Using `x86 gcc 1.27` you get:

```asm
square:
        pushl   %ebp              # Stack maintenance - store the old base pointer
        movl    %esp,%ebp         # Stack maintenance - set the new base pointer
        pushl   %ebx              # Saving to restore values later
        movl    8(%ebp),%ebx      # Access parameter
        imull   8(%ebp),%ebx      # Access parameter, and do multiply
        movl    %ebx,%eax         # Set return address
        leal    -4(%ebp),%esp     # Set stack to where we were after saving values, so we can restore them
        popl    %ebx              # Restoring values saved earlier
        leave                     # Inverse of the pushl/movl at the start of the function
        ret                       # Resume execution at return address
squareDoubled:
        pushl   %ebp              # Stack maintenance - store the old base pointer
        movl    %esp,%ebp         # Stack maintenance - set the new base pointer
        pushl   %esi              # Saving to restore values later
        pushl   %edi              # Saving to restore values later
        pushl   8(%ebp)           # (Access and) Store parameter
        call    square            # Call function
        movl    %eax,%esi         # Save return value to %esi
        pushl   8(%ebp)           # (Access and) Store parameter
        call    square            # Call function
        movl    %eax,%edi         # Save return value to %edi
        leal    (%edi,%esi),%eax  # Use leal instruction to do addition, and store in eax
        leal    -8(%ebp),%esp     # Set stack to where we were after saving values, so we can restore them
        popl    %edi              # Restoring values saved earlier
        popl    %esi              # Restoring values saved earlier
        leave                     # Inverse of the pushl/movl at the start of the function
        ret                       # Resume execution at return address
```

Using `x86-64 gcc 13.2` you get:

```asm
square:
        pushq   %rbp              # Stack maintenance - store the old base pointer
        movq    %rsp, %rbp        # Stack maintenance - set the new base pointer
        movl    %edi, -4(%rbp)    # Move parameter onto stack
        movl    -4(%rbp), %eax    # Pull it out into a register (I think acts as a resize)
        imull   %eax, %eax        # Do the multiply
        popq    %rbp              # Restore the base pointer for the caller
        ret                       # Resume execution at return address
squareDoubled:
        pushq   %rbp              # Stack maintenance - store the old base pointer
        movq    %rsp, %rbp        # Stack maintenance - set the new base pointer
        pushq   %rbx              # Saving to restore values later
        subq    $8, %rsp          # Create space for a variable
        movl    %edi, -12(%rbp)   # Push the (incoming) parameter into that variable
        movl    -12(%rbp), %eax   # Pull variable out into a register (I think acts as a resize)
        movl    %eax, %edi        # Put the variable into the parameter register for function calling
        call    square            # Call function
        movl    %eax, %ebx        # Save return to register
        movl    -12(%rbp), %eax   # Pull variable out into a register (I think acts as a resize)
        movl    %eax, %edi        # Put the variable into the parameter register for function calling
        call    square            # Call function
        addl    %ebx, %eax        # Perform add
        movq    -8(%rbp), %rbx    # Restoring values saved earlier
        leave                     # Inverse of the pushl/movl at the start of the function
        ret                       # Resume execution at return address
```

Note that square is a "leaf function" and doesn't need to bother with maintaining the stack pointer. It gets a 128-byte space beneath the stack pointer called the "red zone" which will not be clobbered by signal or interrupt handlers.

x86-64 also has some [register requirements](https://en.wikipedia.org/wiki/X86_calling_conventions#System_V_AMD64_ABI):

> If the callee wishes to use registers RBX, RSP, RBP, and R12–R15, it must restore their original values before returning control to the caller. All other registers must be saved by the caller if it wishes to preserve their values.

Using registers for function calling may have some advantages.

- It might be faster for the CPU
- Reisters can be populated with values during manipulation, and be in the right place already for the function call.
- Nested method calls with similar parameters can also leave registers in place.

Ultimately, you can call functions however you want from within your own code. Adhering to a convention is only strictly necessary when calling out (or being called) by code you didn't write (e.g. a C library).

# Syntax used

| Syntax                   | Description              |
| ------------------------ | ------------------------ |
| `.type power, @function` | Instruct the linker that |

# Power example

Couldn't the value be left in `%eax` for the duration?

This sample doesn't build and run on my machine. This is because it uses 32-bit stach instructions (`pushl`, `popl`) which are not supported on 64 bit architectures.

# References

https://en.wikipedia.org/wiki/X86_calling_conventions
https://stackoverflow.com/questions/37239885/what-is-leal-edx-edx-4-eax-means
https://stackoverflow.com/questions/29790175/assembly-x86-leave-instruction
https://stackoverflow.com/questions/21679131/error-invalid-instruction-suffix-for-push
