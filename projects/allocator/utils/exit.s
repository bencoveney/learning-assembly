.globl exit

.section .text

# Exits the program
# Param %rdi: The exit code
exit:
  enter $0, $0

  # Exit
  movq $SYSCALL_EXIT, %rax
  movq $0, %rdi
  syscall

  leave
  ret
