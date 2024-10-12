.globl main

.section .data
value:
  .quad 6
output:
  .ascii "The square of %d is %d\n\0"

.section .text
main:
  enter $0, $0

  movq value(%rip), %rdi
  call squareme@PLT

  // movq stdout, %rdi
  movq stdout(%rip), %rdi
  // movq $output, %rsi
  leaq output(%rip), %rsi
  movq value(%rip), %rdx
  movq %rax, %rcx
  // call fprintf
  call fprintf@PLT

  leave
  ret
