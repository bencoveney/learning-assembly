.globl _start
.section .text
_start:
  # Base
  movq $2, %rbx
  # Exponent
  movq $3, %rcx
  # Destination - 1 so we can just begin multiplying into it
  movq $1, %rax

  # Test for zero - The first time through
  addq $0, %rcx

mainloop:
  jz complete

  # Multiply by base
  mulq %rbx

  # Decrease exponent. If this is 0, the zero flag will be preserved across jumps
  decq %rcx
  jmp mainloop

complete:
  movq %rax, %rdi
  movq $60, %rax
  syscall
