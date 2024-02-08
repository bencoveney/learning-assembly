.globl _start
.section .text
_start:
  # Base
  movq $2, %rbx
  # Exponent
  movq $3, %rcx
  # Destination - 1 so we can just begin multiplying into it
  movq $1, %rax

  # Test for zero
  cmpq $0, %rcx
  je complete

mainloop:
  # Multiply by base
  mulq %rbx

  # Decrease exponent.
  loopq mainloop

complete:
  movq %rax, %rdi
  movq $60, %rax
  syscall
