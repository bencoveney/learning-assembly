# Make entry point available to the linker
.globl _start
# Instruct linker there is code here
.section .text
# Define a label
_start:
  # Call exit syscall with exit code 3
  movq $60, %rax
  movq $3, %rdi
  syscall
