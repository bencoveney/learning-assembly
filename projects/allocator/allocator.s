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

  # Loop through blocks of memory until we find a free one. For the duration:
  movq startOfHeap, %rcx
  checkNextBlock:

  # Set up loop variables:
  # - %rcx = pointer to memory being examined
  # - %rax = size of the block
  # - %rdi = whether it is allocated
  movq (%rcx), %rax
  movq %rax, %rdi
  andq $0xfffffffffffffff8, %rax
  andq $0x1, %rdi
  # Check if it is allocated already
  jnz moveToNextBlock

  # Check if it is big enough
  cmpq %rdi, LOCAL_AMOUNT_TO_ALLOCATE(%rbp)
  jbe blockFound

  moveToNextBlock:
  addq %rax, %rcx

  # Check if we have reached the end of the heap
  cmpq endOfHeap, %rcx
  jae reachedEndOfHeap

  jmp checkNextBlock

  reachedEndOfHeap:

  # Add space for the header, and then round the requested allocation up to preserve alignment.
  # This is duplicated below...
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  addq $HEADER_SIZE, %rdi
  call roundToMultipleOf8
  movq %rax, LOCAL_AMOUNT_TO_ALLOCATE(%rbp)

  jmp expandHeap

  blockFound:

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

  # Add space for the header, and then round the requested allocation up to preserve alignment.
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  addq $HEADER_SIZE, %rdi
  call roundToMultipleOf8
  movq %rax, LOCAL_AMOUNT_TO_ALLOCATE(%rbp)

expandHeap:

  # Calculate the new end of the heap.
  movq endOfHeap, %rdi
  addq %rax, %rdi

  # Set it!
  call brk

  # Before we mark the heap as expanded, we should take note of where it was before.
  # That will be the start of the new block.
  movq endOfHeap, %rcx

  # The heap has expanded, store the new end.
  movq %rax, endOfHeap

  # We only know how to allocate a single block at the moment, but we can set up the header.
  # Main part of the header will be the size
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  # We will add 1 to the address, to indicate the block is allocated.
  addq $0x1, %rdi
  movq %rdi, (%rcx)

  # Get ready to return the memory. To do that, we will need to:
  # - Take the start of the block (currently the start of the heap)
  movq %rcx, %rax
  # - Offset it by the size of the header
  addq $HEADER_SIZE, %rax

  leave
  ret

# Allocates the specified amount of memory
# Param %rdi: The pointer to the beginning of the allocated memory.
deallocate:
  enter $0, $0

  leave
  ret