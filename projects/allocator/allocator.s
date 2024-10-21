.globl allocate, deallocate

.section .data

startOfHeap:
  .quad 0
endOfHeap:
  .quad 0

# Always allocate in chunks of 8 bytes. This will help with alignment, but also leaves some of the
# bits available (last 3 bits should always be 0).
.equ MIN_ALLOC, 8

# Header will be 8 bytes (64 bits - the wordsize) large
.equ HEADER_SIZE, 8

.section .text

# Allocates the specified amount of memory
# Param %rdi: The number of bytes to allocate.
# Return %rax: A pointer to the allocated memory.
allocate:
.equ LOCAL_AMOUNT_TO_ALLOCATE, -8
  enter $16, $0

  mov %rdi, LOCAL_AMOUNT_TO_ALLOCATE(%rbp)

  # If this is the first time we have called alloc, we need to take a quick detour and work out
  # where the heap is.
  cmpq $0, startOfHeap
  je initialize

  initialized:

  # Add space for the header, and then round the requested allocation up to preserve alignment.
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  addq $HEADER_SIZE, %rdi
  call roundToMultipleOf8
  movq %rax, LOCAL_AMOUNT_TO_ALLOCATE(%rbp)

  movq endOfHeap, %rdi
  addq %rax, %rdi

  call brk

  leave
  ret

initialize:

  # Call brk to work out where the heap begins. We will need to follow this up with another call
  # to brk to actually do the allocation. This could be optimised slightly using sbrk, as that
  # would let us allocate and get the heap address at the same time.
  movq $0, %rdi
  call brk

  movq %rax, startOfHeap
  movq %rax, endOfHeap
  jmp initialized

# Allocates the specified amount of memory
# Param %rdi: The pointer to the beginning of the allocated memory.
deallocate:
  enter $0, $0

  leave
  ret
