.globl exit

.section .text

# Exits the program
# Param %rdi: The exit code
exit:
  enter $0, $0

  # Exit
  movq $SYSCALL_EXIT, %rax
  syscall

  leave
  ret
