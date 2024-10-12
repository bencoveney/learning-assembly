.globl main

.section .data
output:
  .ascii "hello\n\0"

.section .text
main:
  enter $0, $0
  // movq stdout, %rdi
  movq stdout(%rip), %rdi
  // movq $output, %rsi
  leaq output(%rip), %rsi

  // call fprintf
  call fprintf@PLT

  movq $0, %rax

  leave
  ret
