.globl uintPrint

.section .data

uintChars:
  .ascii "0123456789"

uintOutput:
  # Max 64 bit uint is 18446744073709551615
  # Allocate enough space to store that, plus terminator
  .ascii "00000000000000000000\n\0"

.section .text

# Prints a value as an unsigned integer to stdout
# Param %rdi: The value to print.
uintPrint:
  enter $0, $0

  # The value to print
  movq %rdi, %rax

  # We will be dividing by 10
  movq $10, %rdi

  # Initial offset into the output string.
  movq $20, %rcx

  uintLoop:
  decq %rcx

  # Division uses %rdx:%rax - we only care about the %rax part.
  movq $0, %rdx

  # Divide by 10. The remainder will be the smallest digit in base 10.
  divq %rdi

  # Look up the ascii character
  movb uintChars(,%rdx,1), %dl

  # Move the character into the ouput string
  movb %dl, uintOutput(,%rcx,1)

  # If there is still stuff to divide, go around again.
  cmpq $0, %rax
  jne uintLoop

  # Offset the output by the number of values we wrote to the output area.
  # This effectively trims leading zeroes.
  movq $uintOutput, %rdi
  addq %rcx, %rdi

  call stringPrint

  leave
  ret
