# Executables

## Linking/Loading

- Static linking: All library code ends up physically inside the final executable.
  - By passing `-static` to GCC
- Dynamic linking: Libraries stay separate, and are loaded together when run.
  - By passing `-rdynamic` to GCC (or by default, by just omitting `-static`)
  - Libraries can be upgraded separately.
  - Saves disk space, because one library can be shared by many executables.

Shared Libraries:

- Shared objects with extension `*.so` on Linux.
- Dynamic link libraries with extension `*.dll` on Windows.
- Dynamic libraries with extension `*.dylib` on Mac (or sometimes `.so`).

Tools:

- `ldd [path]` can be used to trace the dynamic loading of files by an executable.
- `strip [path]` can be used to strip debugging information.
- `objdump -X [path]` can be used to inspect ELF file-format metadata for Linux executables.
- `objdump -R [path]` can be used to inspect linker relocations.

LDD output for a simple executable:

- `linux-vdso.so.1 (0x00007fff74f63000)` - The vDSO library, provided by Linux to give access to functions without needing a syscall.
- `libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f2cb01c1000)` - The C library's "soname" (shared object name).
- `/lib64/ld-linux-x86-64.so.2 (0x00007f2cb03fc000)` - The linker/loader that will be used.

The linker/loader is an executable, and you can run it to see a help screen. It will by run (by
Linux) before your executable - your program name will be sent as a parameter.

How the loader works:

- During compilation, there are symbols that can't be resolved.
- The compiler/linker:
  - looks at the list of libraries included at compilation (+ C std lib).
  - Any symbols from your code are looked up in the shared libraries.
  - All shared libraries requested are recorded into the executable:
    - For functions: in the PLT + GOT.
    - For data (e.g. `stdout`):
      - Entry created in GOT (loaded immediately at runtime).
      - Code can use them directly (without going via GOT) via "Copy Relocation"

Example:

- At compile time:
  - `call fprintf` instruction in the code.
  - Entry created for `fprintf` in the GOT (glue code).
  - Entry created for `fprintf` in the PLT (pointing to GOT) named `fprintf@plt`.
  - `call fprintf` modified to be `call fprintf@plt`.
- At run time:
  - `call fprintf@plt` invoked.
  - GOT glue code fixed up to point to real `fprintf` function.
  - Subsequent calls to `call fprintf@plt` end up jumping straight to real `fprintf` function.

### Procedure Linkage Table (PLT)

Contains indirect jump instructions to the locations in the GOT.

### Global Offset Table (GOT)

Initially contains glue code, which tells the loader "replace me with the actual function".

The indirection of the PLT + GOT allows the executable to load quickly without having to wait for
relocations that may never be used. This behaviour can be overridden with the `LD_BIND_NOW`
environment variable.

## Position-Independent Code

When using shared libraries, the loader can map them anywhere in memory. These addresses can be
randomised by Linux as a security precaution. The location where a library is loaded is known as
the "Base Address".

Libraries have to be written to handle being relocated, using "Position-Independent Code" (PIC).
There are 3 main areas which need to be modified:

- References to external functions.
  - `call fprint` becomes `call fprint@PLT` - Allows loader to load value lazily.
  - `call fprint` becomes `call *fprint@GOTPCREL(%rip)` - Forces loader to load value immediately.
- References to the `.data. section.
  - `movq somedata, %rax` becomes `movq somedata($rip), %rax`
- References to externally defined data (e.g. `stdout`).
  - `movq stdout, %rdi` becomes 2 instructions:
    - `movq stdout@GOTPCREL(%rip), %rdi` (To find the address within the GOT)
    - `movq (%rdi), %rdi` (To access the address found in the GOT)

`movq somedata($rip), %rax` is "PC-Relative Addressing". It gets encoded as a relative offset to
the instruction pointer, so any time the code is evaluated the relative offset is correct (because
the instruction pointer will be in the same place at that point in time). This addressing mode
doesn't support index or scale - if those are needed then you need to use `leaq` for those parts.

We can create Position-Independent Executables (PIE) too. Write `main` as though it were a shared
library and then compile with `-pie`. This has security benefits.
