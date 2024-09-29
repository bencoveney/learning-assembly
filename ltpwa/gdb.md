# GNU Debugger

```shell
# Typical compilation.
as source.s -o ./output/object.o
ld ./output/object.o -o ./output/executable
./output/executable

# Compiling with debug symbols, and debugging.
as source.s --gdwarf-2 -o ./output/object.o
ld ./output/object.o -o ./output/executable
gdb ./output/executable
```

## Commands

| Command                | Short      | Description                                      |
| ---------------------- | ---------- | ------------------------------------------------ |
| `run`                  | `r`        | Run the program                                  |
| `break [line]`         | `b [line]` | Sets a breakpoint on a line                      |
| `break [label]`        | `b _start` | Sets a breakpoint on a label (e.g `_start`)      |
| `disable`              |            | Disable the breakpoint                           |
| `enable`               |            | Enable the breakpoint                            |
| `next`                 | `n`        | Single step over (without diving into functions) |
| `step`                 |            | Single step in (diving into functions)           |
| `list`                 | `l`        | Display the code                                 |
| `print`                | `p`        | Display the value of a variable                  |
| `quit`                 | `q`        | Exit GDB                                         |
| `clear`                |            | Clear all breakpoints                            |
| `continue`             |            | Continues normal execution                       |
| `info breakpoints`     | `i b`      | See breakpoints                                  |
| `info registers`       | `i r`      | See registers                                    |
| `info stack`           | `i s`      | See stack                                        |
| `info frame`           | `i f`      | See stack frame                                  |
| `info files`           |            | See targets and files being debugged             |
| `info variables`       |            | All local variables                              |
| `info variables`       |            | All static/global variables                      |
| `frame`                | `f`        |                                                  |
| `info line`            |            | Display information about the current line       |
| `info line [label]`    |            | Display information about a label (e.g `_start`) |
| `info line +[offset]`  |            | Display information about an offset line         |
| `backtrace`, `where`   | `bt`       |                                                  |
| `disassemble`          |            | Dump function code                               |
| `display [expression]` |            | Print an expression when the program stops       |
| `display/i $pc`        |            | Print current instruction when the program stops |

## Printing

| Command    | Description                                                    |
| ---------- | -------------------------------------------------------------- |
| `p/x $pc`  | Print a register                                               |
| `p/x $1`   | Print previously printed value (See `$1 = ` in output)         |
| `p/x $$1`  | Print previously printed value                                 |
| `p/x 0xff` | Print a value                                                  |
| `p/x 0xff` | Print a value as hexidecimal                                   |
| `p/z 0xff` | Print a value as hexidecimal (+ pad to integer size)           |
| `p/d 0xff` | Print a value as decimal                                       |
| `p/u 0xff` | Print a value as (unsigned) decimal                            |
| `p/o 0xff` | Print a value as octal                                         |
| `p/t 0xff` | Print a value as binary (two)                                  |
| `p/a 0xff` | Print a value as an address (incl nearest symbol aka function) |
| `p/c 0xff` | Print a value as ASCII (via int cast)                          |
| `p/f 0xff` | Print a value as float                                         |
| `p/s 0xff` | Print a value as string (with caveats)                         |
| `p/r 0xff` | Print a value as raw (python pretty print)                     |

## Examining

| Command     | Description                                    |
| ----------- | ---------------------------------------------- |
| `x $pc`     | Examine address                                |
| `x/[N] $pc` | Repeat examination N times                     |
| `x/5 $pc`   | Repeat examination 5 times                     |
| `x/[F] $pc` | Format examined value (see print, also i or m) |
| `x/d $pc`   | Format examined value as decimal               |
| `x/i $pc`   | Format examined value as instructions          |
| `x/m $pc`   | Format examined value as memory tags           |
| `x/[U] $pc` | Examine U bytes                                |
| `x/b $pc`   | Examine 1 byte                                 |
| `x/h $pc`   | Examine 2 bytes (half word)                    |
| `x/w $pc`   | Examine 4 bytes (word)                         |
| `x/g $pc`   | Examine 4 bytes (giant word)                   |
| `x/[NFU]`   | Examine with all options                       |

Defaults for `[F]` change any time you use Examine or Print.

Defaults for `[U]` change any time you use Examine.

### Examples:

```shell
# From the location inside $rbx, print 8 bytes as decimals, 10 times.
x/10xw $rbx

# From the instruction pointed to by $pc, print 4-bytes as instructions, 3 times.
x/3i $pc

# From the location inside $rbx, print the null terminated ASCII string.
x/s $rbx
```

## Register names

Common register names across architectures

| Name  | Description                 |
| ----- | --------------------------- |
| `$pc` | Program counter             |
| `$sp` | Stack pointer               |
| `$fp` | Current stack frame pointer |
| `$ps` | Processor status            |