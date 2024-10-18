## ScreechyCat Class
.globl screechy_cat_new, screechy_cat_speak, screechy_cat_destroy
.section .data
speak_text:
  .ascii "Screech!\n\0"

.section .text

.equ CAT_SIZE, 64

screechy_cat_new:
  enter $0, $0
  movq $CAT_SIZE, %rdi
  call malloc
  leave
  ret

screechy_cat_speak:
  enter $0, $0
  movq stdout, %rdi
  movq $speak_text, %rsi
  call fprintf
  leave
  ret

screechy_cat_destroy:
  enter $0, $0
  # %rdi already has the address
  call free
  leave
  ret
