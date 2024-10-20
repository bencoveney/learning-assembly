.globl stringLength

.section .text

# Gets the length (including the terminator) of a null terminated string
# Param %rdi: Pointer to the string
stringLength:
  enter $0, $0

  # %rdi has a pointer to the string
  # Make a copy so we can see how far we went afterwards
  movq %rdi, %r8

  # Preload the counter with a large number, so we can do a lot of counting
  movq $-1, %rcx

  # Count bytes until we find a null
  movb $0, %al
  repne scasb

  # Prepare to return the count of characters
  movq %rdi, %rax
  subq %r8, %rax

  leave
  ret
