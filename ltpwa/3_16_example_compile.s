  .text
  .globl  squareme
  .type  squareme, @function
squareme:
.LFB0:
  pushq  %rbp
  movq  %rsp, %rbp
  movq  %rdi, -8(%rbp)
  movq  -8(%rbp), %rax
  imulq  %rax, %rax
  popq  %rbp
  ret
.LFE0:
  .size  squareme, .-squareme
  .globl  myval
  .bss
  .align 8
  .type  myval, @object
  .size  myval, 8
myval:
  .zero  8
  .section  .rodata
.LC0:
  .string  "Enter a number: \n"
.LC1:
  .string  "%d"
.LC2:
  .string  "The square of %d is %d"
  .text
  .globl  main
  .type  main, @function
main:
.LFB1:
  pushq  %rbp
  movq  %rsp, %rbp
  movq  stdout(%rip), %rax
  movq  %rax, %rcx
  movl  $17, %edx
  movl  $1, %esi
  leaq  .LC0(%rip), %rax
  movq  %rax, %rdi
  call  fwrite@PLT
  movq  stdin(%rip), %rax
  leaq  myval(%rip), %rdx
  leaq  .LC1(%rip), %rcx
  movq  %rcx, %rsi
  movq  %rax, %rdi
  movl  $0, %eax
  call  __isoc99_fscanf@PLT
  movq  myval(%rip), %rax
  movq  %rax, %rdi
  call  squareme
  movq  %rax, %rcx
  movq  myval(%rip), %rdx
  movq  stdout(%rip), %rax
  leaq  .LC2(%rip), %rsi
  movq  %rax, %rdi
  movl  $0, %eax
  call  fprintf@PLT
  movl  $0, %eax
  popq  %rbp
  ret
.LFE1:
  .size  main, .-main
  .ident  "GCC: (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0"
  .section  .note.GNU-stack,"",@progbits
  .section  .note.gnu.property,"a"
  .align 8
  .long  1f - 0f
  .long  4f - 1f
  .long  5
