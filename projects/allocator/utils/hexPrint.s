.globl hexPrint

.section .data

hexChars:
  .ascii "0123456789abcdef"

output:
  .ascii "0xffffffffffffffff\n\0"

.section .text

# Prints a value as hex to stdout
# Param %rdi: The value to print.
hexPrint:
  enter $0, $0

  movq $16, %rcx
  hexLoop:

  # Mask off the lowest 4 bits
  movq %rdi, %rax
  andq $0x000000000000000f, %rax

  # Look up the ascii character
  movb hexChars(,%rax,1), %dl

  # Move the character into the ouput string
  movq $0x1, %rax
  movb %dl, output(%rax,%rcx,1)

  # Move on to the next character
  shrq $0x4, %rdi
  loopq hexLoop

  # Once output has been filled, print it.
  movq $output, %rdi
  call stringPrint

  leave
  ret
