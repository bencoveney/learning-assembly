.globl _start
.section .text
_start:
  # Base
  movq $2, %rbx
  # Exponent
  movq $3, %rcx
  # Destination - 1 so we can just begin multiplying into it
  movq $1, %rax

mainloop:
  # Test for zero
  addq $0, %rcx
  jz complete

  # Multiply by base
  mulq %rbx

  # Decrease exponent.
  decq %rcx
  jmp mainloop

complete:
  movq %rax, %rdi
  movq $60, %rax
  syscall
