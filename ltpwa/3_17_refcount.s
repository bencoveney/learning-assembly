.globl retain, release

.section .text
.equ REFCOUNT_OFFSET, -16

retain:
  incq REFCOUNT_OFFSET(%rdi)
  ret

release:
  decq REFCOUNT_OFFSET(%rdi)
  ret
