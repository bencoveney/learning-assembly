.globl brk

.section .text

# Gets/sets the system break
#
# Usage 1 (Set):
# Param %rdi: The desired system break.
# Return %rax: The current system break.
#
# Usage 2 (Get):
# Param %rdi: 0.
# Return %rax: The current system break.
brk:
  enter $0, $0

  # Exit
  movq $SYSCALL_BRK, %rax
  syscall

  leave
  ret
