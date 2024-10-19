.globl main
output:
  .ascii "The result is %f\n\0"

.section .text
main:
  enter $0, $0

  movq $1, %rax
  movq $3, %rbx

  cvtsi2sd %rax, %xmm0
  cvtsi2sd %rbx, %xmm1

  divsd %xmm1, %xmm0

  movq stdout, %rdi
  movq $output, %rsi
  call fprintf

  leave
  ret
