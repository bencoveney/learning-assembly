.globl doThings
.section .text

doThings:
  .equ LCL_ANIMAL_OBJ_OFFSET, -8
  .equ LCL_ANIMAL_VTABLE_OFFSET, -16
  enter $16, $0
  movq %rdi, LCL_ANIMAL_OBJ_OFFSET(%rbp)
  movq %rsi, LCL_ANIMAL_VTABLE_OFFSET(%rbp)

  # %rdi already contains the object
  call *VTABLE_ANIMAL_SPEAK_OFFSET(%rsi)

  movq LCL_ANIMAL_OBJ_OFFSET(%rbp), %rdi
  movq LCL_ANIMAL_VTABLE_OFFSET(%rbp), %rsi
  call *VTABLE_ANIMAL_EAT_OFFSET(%rsi)

  movq LCL_ANIMAL_OBJ_OFFSET(%rbp), %rdi
  movq LCL_ANIMAL_VTABLE_OFFSET(%rbp), %rsi
  call *VTABLE_ANIMAL_SPEAK_OFFSET(%rsi)

  movq LCL_ANIMAL_OBJ_OFFSET(%rbp), %rdi
  movq LCL_ANIMAL_VTABLE_OFFSET(%rbp), %rsi
  call *VTABLE_ANIMAL_SPEAK_OFFSET(%rsi)

  leave
  ret
