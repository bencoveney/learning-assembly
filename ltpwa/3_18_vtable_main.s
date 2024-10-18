.globl main
.section .text

main:
  .equ LCL_CAT, -8
  .equ LCL_DOG, -16
  .equ LCL_SCREECHY_CAT, -24

  enter $32, $0

  # Construct a cat
  call cat_new
  movq %rax, LCL_CAT(%rbp)

  # Construct a dog
  call dog_new
  movq %rax, LCL_DOG(%rbp)

  # Construct a screechy cat
  call cat_new
  movq %rax, LCL_SCREECHY_CAT(%rbp)

  # Object
  movq LCL_CAT(%rbp), %rdi
  # VTable
  movq $cat_vtable_animal, %rsi
  call doThings

  # Object
  movq LCL_DOG(%rbp), %rdi
  # VTable
  movq $dog_vtable_animal, %rsi
  call doThings

  # Object
  movq LCL_SCREECHY_CAT(%rbp), %rdi
  # VTable
  movq $screechy_cat_vtable_animal, %rsi
  call doThings

  # Destructors
  movq LCL_CAT(%rbp), %rdi
  call cat_destroy

  movq LCL_DOG(%rbp), %rdi
  call dog_destroy

  # Destructors
  movq LCL_SCREECHY_CAT(%rbp), %rdi
  call screechy_cat_destroy

  leave
  ret
