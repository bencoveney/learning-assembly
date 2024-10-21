.globl stringPrint

.section .text

# Prints a null-terminated string
# Param %rdi: Pointer to the string
stringPrint:
  .equ LOCAL_STRING, -8
  enter $16, $0

  mov %rdi, LOCAL_STRING(%rbp)

  # Grab the length
  call stringLength

  # Move length first, so it doesn't get trampled
  movq %rax, %rdx

  # write(stderr, string, length)
  movq $SYSCALL_WRITE, %rax
  movq $FD_STDERR, %rdi
  movq LOCAL_STRING(%rbp), %rsi
  syscall

  leave
  ret
