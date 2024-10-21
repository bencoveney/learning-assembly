.globl allocate, deallocate

.section .data

debugInitializing:
  .ascii "Initializing\n\0"

debugAllocating:
  .ascii "Allocating\n\0"

debugDeallocating:
  .ascii "Deallocating\n\0"

startOfHeap:
  .quad 0
endOfHeap:
  .quad 0

.section .text

# Allocates the specified amount of memory
# Param %rdi: The number of bytes to allocate.
# Return %rax: A pointer to the allocated memory.
allocate:
  enter $0, $0

  cmpq $0, startOfHeap
  je initialize

  initialized:

  movq $debugAllocating, %rdi
  call stringPrint

  # Initialize some more, just to see what happens
  mov startOfHeap, %rdi
  add $64, %rdi
  call brk

  leave
  ret

initialize:
  movq $debugInitializing, %rdi
  call stringPrint

  movq $0, %rdi
  call brk

  movq %rax, startOfHeap
  movq %rax, endOfHeap
  jmp initialized

# Allocates the specified amount of memory
# Param %rdi: The pointer to the beginning of the allocated memory.
deallocate:
  enter $0, $0

  movq $debugDeallocating, %rdi
  call stringPrint

  leave
  ret
