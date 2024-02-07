.globl _start
.section .text
_start:
  # rdi rax
  movq $3, %rdi
  # 003 000
  movq %rdi, %rax
  # 003 003
  addq %rdi, %rax
  # 003 006
  mulq %rdi
  # 003 018
  movq $2, %rdi
  # 002 018
  addq %rdi, %rax
  # 002 020
  movq $4, %rdi
  # 004 020
  mulq %rdi
  # 004 080
  movq %rax, %rdi
  # 004 080

  # 80?
  movq $60, %rax
  syscall
