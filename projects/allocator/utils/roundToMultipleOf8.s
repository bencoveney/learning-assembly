.globl roundToMultipleOf8

# Takes the given value, and rounds it up (if required) to be a multiple of 8.
# Param %rdi: The value to round.
# Return %rax: The rounded value.
.section .text
roundToMultipleOf8:
  enter $0, $0

  mov %rdi, %rax

  # Mask off the last 3 bits
  andq $0xfffffffffffffff8, %rax

  # If the value matches what was initially passed, then it is already divisible by 8.
  cmpq %rdi, %rax
  je done

  # Otherwise, add 8.
  add $8, %rax

  done:
  leave
  ret
