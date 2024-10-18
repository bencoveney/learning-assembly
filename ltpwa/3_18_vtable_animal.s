.globl VTABLE_ANIMAL_SPEAK_OFFSET, VTABLE_ANIMAL_EAT_OFFSET
.globl dog_vtable_animal
.globl cat_vtable_animal

.equ VTABLE_ANIMAL_SPEAK_OFFSET, 0
.equ VTABLE_ANIMAL_EAT_OFFSET, 8

dog_vtable_animal:
  .quad dog_speak
  .quad dog_eat

cat_vtable_animal:
  .quad cat_speak
  .quad cat_eat
