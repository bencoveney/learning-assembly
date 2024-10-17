# This marks all allocations as being "unused". They will then be remarked as used when pointers to
# them are detected.

.include "4_j_gc_defs.s"

.globl gc_unmark_all
.section .text
gc_unmark_all:
  enter $0, $0

  movq heap_start, %rcx
  movq heap_end, %rdx

loop:
  cmpq %rcx, %rdx
  je finish

  movq $0, HDR_IN_USE_OFFSET(%rcx)
  addq HDR_SIZE_OFFSET(%rcx), %rcx
  jmp loop

finish:
  leave
  ret
