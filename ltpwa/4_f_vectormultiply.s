.globl main

.balign 16
starting_value:
  .single 2.1, 2.1, 2.1, 2.1
multiply_by:
  .single 5.0, 6.0, 7.0, 8.0
output:
  .ascii "Results: %f, %f, %f, %f\n\0"

.section .text
main:
  enter $0, $0

  # Load the values a whole 128 bits at a time
  movaps starting_value, %xmm4
  movaps multiply_by, %xmm5

  # Multiply
  mulps %xmm4, %xmm5

  # Extract into parameters for fprintf

  # Extract the first value to %xmm0
  movss %xmm5, %xmm0
  # Upgrade from a float to a double
  cvtss2sd %xmm0, %xmm0
  # Shift the next value into position
  psrldq $4, %xmm5

  # Extract the first value to %xmm1
  movss %xmm5, %xmm1
  # Upgrade from a float to a double
  cvtss2sd %xmm1, %xmm1
  # Shift the next value into position
  psrldq $4, %xmm5

  # Extract the first value to %xmm2
  movss %xmm5, %xmm2
  # Upgrade from a float to a double
  cvtss2sd %xmm0, %xmm2
  # Shift the next value into position
  psrldq $4, %xmm5

  # Extract the first value to %xmm3
  movss %xmm5, %xmm3
  # Upgrade from a float to a double
  cvtss2sd %xmm0, %xmm3

  # Protext 4 XMM registers
  movq $4, %rax

  # Invoke function
  movq stdout, %rdi
  movq $output, %rsi
  call fprintf

  leave
  ret
