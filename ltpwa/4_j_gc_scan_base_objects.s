# Scans the base objects 0 the stack and the data sections (.data, .rodata, .bss) - for potentially
# valid pointers.

.globl gc_scan_base_objects
.section .rodata
.section .text
gc_scan_base_objects:
  enter $0, $0

  # the 'end' of the stack is the beginning
  # of the memory of the stack
  movq stack_end, %rdi
  # size is in %rsi
  movq stack_start, %rsi
  subq %rdi, %rsi
  call gc_scan_memory

  # .rodata is the first data segment
  movq $.rodata, %rdi
  # Align to an 8-byte boundary
  andq $0xfffffffffffffff8, %rdi
  # _end marks the end of data
  movq $_end, %rsi
  subq %rdi, %rsi
  call gc_scan_memory

  leave
  ret
