.globl screechy_cat_vtable_animal

.equ VTABLE_ANIMAL_SPEAK_OFFSET, 0
.equ VTABLE_ANIMAL_EAT_OFFSET, 8

screechy_cat_vtable_animal:
  .quad screechy_cat_speak
  .quad cat_eat
