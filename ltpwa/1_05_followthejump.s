.globl _start
.section .text
_start:
  # rax rbx rdi
  # 025 000 000
  movq $25, %rax
  jmp thelabel

somewhere:
  # 011 05 011
  movq %rax, %rdi
  jmp anotherlabel

label1:
  # 055 030 000
  addq %rbx, %rax
  # 055 05 000
  movq $5, %rbx
  jmp here

labellabel:
  # 060 05 011
  # exit(11)
  syscall

anotherlabel:
  # 060 05 011
  movq $60, %rax
  jmp labellabel

thelabel:
  # 025 025 000
  movq %rax, %rbx
  jmp there

here:
  # 011 05 000
  divq %rbx
  jmp somewhere

there:
  # 025 030 000
  addq $5, %rbx
  jmp label1

anywhere:
  jmp thelabel
