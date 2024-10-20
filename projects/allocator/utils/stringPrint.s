.globl stringPrint

.section .text

# Prints a null-terminated string
# Param %rdi: Pointer to the string
stringPrint:
  enter $0, $0

  # Grab the length
  call stringLength

  # Move length first, so it doesn't get trampled
  movq %rax, %rdx

  # write(stderr, string, length)
  movq $SYSCALL_WRITE, %rax
  movq $FD_STDERR, %rdi
  movq $logMessage, %rsi
  syscall

  leave
  ret
