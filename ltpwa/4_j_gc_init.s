# Contains the code for the gc_init function, which initializes the garbage collector. This saves
# the location of the beginning of the stack and initializes the beginning/end of the heap.

.globl gc_init

.section .text
gc_init:
  # Assume %rbp has the previous stack frame,
  # and is properly aligned
  movq %rbp, stack_start

  # Save the location of the heap
  movq $BRK_SYSCALL, %rax
  movq $0, %rdi
  syscall

  movq %rax, heap_start
  movq %rax, heap_end

  ret
