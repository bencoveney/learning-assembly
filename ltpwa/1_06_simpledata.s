.globl _start

.section .data
first_value:
  .quad 4
second_value:
  .quad 4
final_result:
  .quad 0

.section .text
_start:
  # Read from data section memory
  movq first_value, %rbx
  movq second_value, %rcx

  addq %rbx, %rcx

  # Write back to data section memory
  movq %rcx, final_result

  movq $60, %rax
  movq final_result, %rdi
  syscall
