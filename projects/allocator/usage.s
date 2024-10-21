.globl _start

.section .data

logMessage:
  .ascii "Hello\n\0"

.section .text
_start:
  movq $logMessage, %rdi
  call stringPrint

  call allocate

  movq $0, %rdi
  call exit
