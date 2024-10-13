# Programming Languages

## Global Variables

```gas
# Initialised
.section .data
myvariable:
  .quad 29

# Uninitialised
.section .bss
myvariable:
  .skip 8
```

Think about alignment e.g. `.balign 16`.

## Local Variables

Registers or reserved memory on the current stack frame.

## Conditional Statements

```c
if (a > b) {
  // Do something
} else {
  // Do alternate
}
// Code continues
```

Becomes

```gas
  cmpq %rbx, %rax
  jq do_something
  # Do alternate
  jmp code_continues

do_something:
  # Do something

code_continues:
  # Code continues
```

## Loops

```c
a = 0
// Loop start
while(a > b) {
  // Do something
  a++
}
// Code continues
```

Becomes

```gas
  movq $0, %rax # Initialise the loop

loop_start:
  cmpq %rbx, %rax
  jge code_continues # Opposite of original while comparison
  # Do Something
  incq %rax
  jmp loop_start

code_continues:
  # Code continues
```

## Functions

See `functions.md`

### Default Parameters

```c
int myfunc(int param1, int param2 = 3, int param3 = 5)
```

```gas
myfunc_default_param2_param3:
  mov1 $3, %rsi

myfunc_default_param3:
  movq $5, %rdx

myfunc:
  # Main function here
```

### Function Overloading

Usually done by having multiple implementations of the same function and disambiguating using name
mangling. The C++ name mangling (e.g. `long myfunc(long long a, long b)` = `_Z6myfuncxl`) includes:

- `_Z` - prefix.
- `6` - number of chars in function name.
- `myfunc` - function name.
- `xl` - letters for each parameter type.
  - `l` - 32 bit int.
  - `x` - 64 bit int.
  - `c` - char.
  - `d` - double.
  - Return type is not included.

## Exception Handling

```c
void myfunc() {
  try {
    myfunc2();
    // Do more stuff
  } catch {
    // Handle exception
  }
  // Continue my func
}

void myfunc2() {
  myfunc3();
}

void myfunc3() {
  throw_exception my_exception_code;
}
```
