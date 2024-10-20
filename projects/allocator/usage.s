.globl _start

.section .data

logMessage:
  .ascii "Hello\n\0"

.section .text
_start:
  mov $logMessage, %rdi
  call stringPrint

  mov $0, %rdi
  call exit
