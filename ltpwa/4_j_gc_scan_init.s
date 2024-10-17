# Contains the code to initialize the scan. It records the current stack position and then
# allocates enough memory to store the potential pointer list.

.globl gc_scan_init

# Make sure we *have* an rodata section, even if nothing is in there
.section .rodata

.section .text
gc_scan_init:
  enter $0, $0

  # Mark end of stack
  movq %rsp, stack_end

  # Calculate max memory we could need for pointer storage into %rdi
  # - Stack size
  movq stack_start, %rdi
  subq %rsp, %rdi
  # - Data section size
  movq $.rodata, %rdx
  # Align to 8 byte boundary
  andq $0xfffffffffffffff8, %rdi

  movq $_end, %rcx
  subq %rdx, %rcx
  addq %rcx, %rdi
  # - Heap size
  movq heap_end, %rdx
  movq heap_start, %rdx
  addq %rdx, %rdi

  # The pointer space will be that many bytes
  # beyond the current heap end.
  movq pointer_list_start, %rdx
  addq %rdx, %rdi
  movq %rdi, pointer_list_end

  # pointer_list_start and _current start at the same
  movq %rdx, pointer_list_current

  # Move the current break to this point
  # (new break already in %rdi)
  movq $BRK_SYSCALL, %rax
  syscall

  leave
  ret
