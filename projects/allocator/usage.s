.globl _start

.section .data

logMessage:
  .ascii "Hello\n\0"

.section .text
_start:
  movq $logMessage, %rdi
  call stringPrint

  # Allocate!
  movq $16, %rdi
  call allocate

  # Allocate again!
  movq $16, %rdi
  call allocate

  # Allocate even more!
  movq $16, %rdi
  call allocate

  movq %rax, %rdi
  call exit
