.globl allocate, deallocate, debugHeap

.section .data

startOfHeap:
  .quad 0
endOfHeap:
  .quad 0

# Always allocate in chunks of 8 bytes. This will help with alignment, but also leaves some of the
# bits available (last 3 bits should always be 0).
.equ MIN_ALLOC, 8

# Header and footer will be 8 bytes (64 bits - the wordsize) large each
.equ HEADER_SIZE, 8
.equ FOOTER_SIZE, 8

.section .text

# Allocates the specified amount of memory
# Param %rdi: The number of bytes to allocate.
# Return %rax: A pointer to the allocated memory.
allocate:
.equ LOCAL_AMOUNT_TO_ALLOCATE, -8
.equ LOCAL_CURRENT_BLOCK_HEADER, -16
.equ LOCAL_CURRENT_BLOCK_SIZE, -24
.equ LOCAL_CURRENT_BLOCK_ALLOCATED, -32
  enter $32, $0

  call getAllocationSize
  movq %rax, LOCAL_AMOUNT_TO_ALLOCATE(%rbp)

  # If this is the first time we have called allocate, we need to take a quick detour and work out
  # where the heap is.
  cmpq $0, startOfHeap
  je initialize

  # Loop through blocks of memory until we find a free one. For the duration:
  movq startOfHeap, %rcx

  # %rcx = pointer to memory being examined
  # Jank: I don't think we should be relying on the assumption that nothing will touch %rcx
  checkNextBlock:

  # Read some information about the current block
  movq (%rcx), %rax
  movq %rax, LOCAL_CURRENT_BLOCK_HEADER(%rbp)
  # Get the size of the block being examined
  movq LOCAL_CURRENT_BLOCK_HEADER(%rbp), %rdi
  call readSizeFromHeader
  movq %rax, LOCAL_CURRENT_BLOCK_SIZE(%rbp)
  # Check if the block being examined is currently allocated
  movq LOCAL_CURRENT_BLOCK_HEADER(%rbp), %rdi
  call readAllocatedFromHeader
  movq %rax, LOCAL_CURRENT_BLOCK_ALLOCATED(%rbp)

  # Check if it is allocated already
  movq LOCAL_CURRENT_BLOCK_ALLOCATED(%rbp), %rax
  cmpq $0x1, %rax
  jz moveToNextBlock

  # Check if it is big enough
  # TODO: Does this check need to exclude the header size? What size are we actually storing?
  movq LOCAL_CURRENT_BLOCK_SIZE(%rbp), %rax
  cmpq %rax, LOCAL_AMOUNT_TO_ALLOCATE(%rbp)
  jbe blockFound

  moveToNextBlock:
  movq LOCAL_CURRENT_BLOCK_SIZE(%rbp), %rax
  addq %rax, %rcx

  # Check if we have reached the end of the heap
  cmpq endOfHeap, %rcx
  jae reachedEndOfHeap

  jmp checkNextBlock

  reachedEndOfHeap:

  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rax
  jmp expandHeap

  blockFound:

  # Mark the block as allocated.
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  movq %rcx, %rsi
  call allocateExistingBlock

  # Return the pointer to the content
  addq $HEADER_SIZE, %rcx
  movq %rcx, %rax

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

  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rax

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

  # Write the block's header
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  movq $0x1, %rsi
  movq %rcx, %rdx
  call writeHeader

  # Write the block's footer
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  movq %rcx, %rsi
  call writeFooter

  # Get ready to return the memory. To do that, we will need to:
  # - Take the start of the block (currently the start of the heap)
  movq %rcx, %rax
  # - Offset it by the size of the header
  addq $HEADER_SIZE, %rax

  leave
  ret

# Deallocates the chunk of memory
# Param %rdi: The pointer to the beginning of the allocated memory.
deallocate:
.equ LOCAL_TARGET_BLOCK_ADDR, -8
.equ LOCAL_TARGET_BLOCK_SIZE, -16
.equ LOCAL_NEXT_BLOCK_ADDR, -24
.equ LOCAL_PREV_BLOCK_ADDR, -32
  enter $32, $0

  # Step back from the memory address to find the header.
  subq $HEADER_SIZE, %rdi
  movq %rdi, LOCAL_TARGET_BLOCK_ADDR(%rbp)

  # Grab the size
  movq (%rdi), %rdi
  call readSizeFromHeader
  movq %rax, LOCAL_TARGET_BLOCK_SIZE(%rbp)

  # Look at the next block
  movq LOCAL_TARGET_BLOCK_ADDR(%rbp), %rax
  addq LOCAL_TARGET_BLOCK_SIZE(%rbp), %rax
  movq %rax, LOCAL_NEXT_BLOCK_ADDR(%rbp)

  movq LOCAL_NEXT_BLOCK_ADDR(%rbp), %rdi
  call readAllocatedFromHeader

  # If it is free
  cmpq $0x1, %rax
  jz deallocate_lookBackwards

  # Add in the size
  movq LOCAL_NEXT_BLOCK_ADDR(%rbp), %rdi
  movq (%rdi), %rdi
  call readSizeFromHeader
  addq LOCAL_TARGET_BLOCK_SIZE(%rbp), %rax
  movq %rax, LOCAL_TARGET_BLOCK_SIZE(%rbp)

  deallocate_lookBackwards:

  # Look at the previous block
  movq LOCAL_TARGET_BLOCK_ADDR(%rbp), %rax
  subq $FOOTER_SIZE, %rax
  movq (%rax), %rdi
  call readSizeFromFooter
  movq LOCAL_TARGET_BLOCK_ADDR(%rbp), %rdi
  sub %rax, %rdi
  movq %rdi, LOCAL_PREV_BLOCK_ADDR(%rbp)

  movq (%rdi), %rdi
  call readAllocatedFromHeader

  # If it is free
  cmpq $0x1, %rax
  jz deallocate_writeHeader

  # It will be the new start
  movq LOCAL_PREV_BLOCK_ADDR(%rbp), %rdi
  movq %rdi, LOCAL_TARGET_BLOCK_ADDR(%rbp)

  # Add in the size
  movq (%rdi), %rdi
  call readSizeFromHeader
  addq LOCAL_TARGET_BLOCK_SIZE(%rbp), %rax
  movq %rax, LOCAL_TARGET_BLOCK_SIZE(%rbp)

  # Write the new header
  deallocate_writeHeader:
  movq LOCAL_TARGET_BLOCK_SIZE(%rbp), %rdi
  movq $0x0, %rsi
  movq LOCAL_TARGET_BLOCK_ADDR(%rbp), %rdx
  call writeHeader

  # Write the new footer
  movq LOCAL_TARGET_BLOCK_SIZE(%rbp), %rdi
  movq LOCAL_TARGET_BLOCK_ADDR(%rbp), %rsi
  call writeFooter

  leave
  ret

# Reads the size of the block of memory, based on the header.
# Param %rdi: The value stored in the header.
# Return %rax: Whether the block is allocated.
readSizeFromHeader:
  enter $0, $0
  movq %rdi, %rax
  # Mask everything except the bottom 3 bits
  andq $0xfffffffffffffff8,%rax
  leave
  ret

# Reads the size of the block of memory, based on the header.
# Param %rdi: The value stored in the header.
# Return %rax: Whether the block is allocated.
readSizeFromFooter:
  enter $0, $0
  movq %rdi, %rax
  # Mask everything except the bottom 3 bits
  andq $0xfffffffffffffff8,%rax
  leave
  ret

# Reads whether the block of memory is allocated.
# Param %rdi: The value stored in the header.
# Return %rax: The size of the block.
readAllocatedFromHeader:
  enter $0, $0
  movq %rdi, %rax
  # The smallest bit has the allocated flag
  andq $0x1, %rax
  leave
  ret

# Allocates the specified amount of space from an existing block. If the block is larger than
# required, it will be split.
# Param %rdi: The size of the block.
# Param %rsi: The pointer to the location the block should be written to.
allocateExistingBlock:
.equ LOCAL_AMOUNT_TO_ALLOCATE, -8
.equ LOCAL_CURRENT_BLOCK_HEADER, -16
.equ LOCAL_CURRENT_BLOCK_SIZE, -24
.equ LOCAL_CURRENT_BLOCK_LOCATION, -32
  enter $32, $0
  movq %rdi, LOCAL_AMOUNT_TO_ALLOCATE(%rbp)
  movq %rsi, LOCAL_CURRENT_BLOCK_LOCATION(%rbp)

  # Find out about the memory block being allocated to, to know whether we should split it.
  movq (%rsi), %rax
  movq %rax, LOCAL_CURRENT_BLOCK_HEADER(%rbp)
  # Get the size of the block being examined
  movq LOCAL_CURRENT_BLOCK_HEADER(%rbp), %rdi
  call readSizeFromHeader
  movq %rax, LOCAL_CURRENT_BLOCK_SIZE(%rbp)

  # For us to be able to split the block, it needs to be able to hold the desired block, plus
  # enough space for another block.
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rax
  addq $HEADER_SIZE, %rax
  addq $MIN_ALLOC, %rax
  addq $FOOTER_SIZE, %rax
  cmpq %rax, LOCAL_CURRENT_BLOCK_SIZE(%rbp)
  jge allocateExistingBlock_split

  allocateExistingBlock_keep:
  # The block is not big enough to split, so we need to allocate the whole thing. Use the block
  # size rather than the desired size when allocating
  movq LOCAL_CURRENT_BLOCK_SIZE(%rbp), %rdi
  movq $0x1, %rsi
  movq LOCAL_CURRENT_BLOCK_LOCATION(%rbp), %rdx
  call writeHeader

  movq LOCAL_CURRENT_BLOCK_SIZE(%rbp), %rdi
  movq LOCAL_CURRENT_BLOCK_LOCATION(%rbp), %rsi
  call writeFooter

  leave
  ret

  allocateExistingBlock_split:
  # The block is big enough to split. Make the allocation as normal.
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  movq $0x1, %rsi
  movq LOCAL_CURRENT_BLOCK_LOCATION(%rbp), %rdx
  call writeHeader

  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  movq LOCAL_CURRENT_BLOCK_LOCATION(%rbp), %rsi
  call writeFooter

  # Create a free block in the remainder.
  # Take the allocated size from the block size to calculate the delta which is left as free.
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rax
  movq LOCAL_CURRENT_BLOCK_SIZE(%rbp), %rdi
  subq %rax, %rdi
  movq $0x0, %rsi
  # Add the delta to the allocation location to get the free block's location.
  movq LOCAL_CURRENT_BLOCK_LOCATION(%rbp), %rdx
  addq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdx
  call writeHeader

  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rax
  movq LOCAL_CURRENT_BLOCK_SIZE(%rbp), %rdi
  subq %rax, %rdi
  movq LOCAL_CURRENT_BLOCK_LOCATION(%rbp), %rsi
  addq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rsi
  call writeFooter

  leave
  ret

# Writes the header for a block of memory.
# Param %rdi: The size of the block.
# Param %rsi: Whether the block is allocated.
# Param %rdx: The pointer to the location the header should be written to.
writeHeader:
  enter $0, $0
  cmpq $0x1, %rsi
  jnz writeHeader_write
  # Mark the block as allocated.
  addq $0x1, %rdi
  writeHeader_write:
  movq %rdi, (%rdx)
  leave
  ret

# Writes the footer for a block of memory.
# Param %rdi: The size of the block.
# Param %rsi: The pointer to the location the header should be written to.
writeFooter:
  enter $0, $0
  # Move to the end of the block
  addq %rdi, %rsi
  # Step back, so we are writing within the block
  subq $FOOTER_SIZE, %rsi
  movq %rdi, (%rsi)
  leave
  ret

# Determines how much memory we need to make an allocation of N bytes when the
# header and alignment are factored in.
# Param %rdi: The desired number of bytes.
# Return %rax: The value to store in the header.
getAllocationSize:
  enter $0, $0
  addq $HEADER_SIZE, %rdi
  addq $FOOTER_SIZE, %rdi
  call roundToMultipleOf8
  # %rax will already have the result.
  leave
  ret

# Takes the given value, and rounds it up (if required) to be a multiple of 8.
# Param %rdi: The value to round.
# Return %rax: The rounded value.
roundToMultipleOf8:
  enter $0, $0
  movq %rdi, %rax
  # Mask off the last 3 bits
  andq $0xfffffffffffffff8, %rax
  # If the value matches what was initially passed, then it is already divisible by 8.
  cmpq %rdi, %rax
  je roundToMultipleOf8_done
  # Otherwise, add 8.
  add $8, %rax
  roundToMultipleOf8_done:
  leave
  ret

.section .data

debugMessage:
  .ascii "\n--------\n\nHeap Content\n\0"

heapStartMessage:
  .ascii "\nHeap Start:\n\0"

heapEndMessage:
  .ascii "Heap End:\n\0"

heapSizeMessage:
  .ascii "Heap Size:\n\0"

locationMessage:
  .ascii "\nBlock At\n\0"

sizeMessage:
  .ascii "Size\n\0"

allocatedMessage:
  .ascii "Allocated\n\0"

freeMessage:
  .ascii "Free\n\0"

heapNotInitializedMessage:
  .ascii "\nHeap Not Initialized\n\0"

.section .text

# Walks the heap and prints information about the chunks.
debugHeap:
.equ LOCAL_CURRENT_BLOCK, -8
  enter $16, $0

  movq $debugMessage, %rdi
  call stringPrint

  cmpq $0, startOfHeap
  je heapNotInitialized

  # Log the heap start and end
  movq $heapStartMessage, %rdi
  call stringPrint
  movq startOfHeap, %rdi
  call hexPrint
  movq $heapEndMessage, %rdi
  call stringPrint
  movq endOfHeap, %rdi
  call hexPrint
  movq $heapSizeMessage, %rdi
  call stringPrint
  movq endOfHeap, %rdi
  subq startOfHeap, %rdi
  call uintPrint

  # Loop through blocks of memory until we find a free one. For the duration:
  movq startOfHeap, %rcx
  debugBlock:

  movq %rcx, LOCAL_CURRENT_BLOCK(%rbp)

  movq $locationMessage, %rdi
  call stringPrint

  movq LOCAL_CURRENT_BLOCK(%rbp), %rdi
  call hexPrint

  movq $sizeMessage, %rdi
  call stringPrint

  movq LOCAL_CURRENT_BLOCK(%rbp), %rcx
  movq (%rcx), %rdi
  andq $0xfffffffffffffff8, %rdi
  call uintPrint

  movq LOCAL_CURRENT_BLOCK(%rbp), %rcx
  movq (%rcx), %rdi
  andq $0x1, %rdi
  jnz allocated

  movq $freeMessage, %rdi
  call stringPrint
  jmp debugToNextBlock

  allocated:
  movq $allocatedMessage, %rdi
  call stringPrint

  debugToNextBlock:

  # Grab the size again - could be refactored
  movq LOCAL_CURRENT_BLOCK(%rbp), %rcx
  movq (%rcx), %rdi
  andq $0xfffffffffffffff8, %rdi
  addq %rdi, %rcx
  # Check if we have reached the end of the heap
  cmpq endOfHeap, %rcx
  jb debugBlock

  leave
  ret

  heapNotInitialized:

  movq $heapNotInitializedMessage, %rdi
  call stringPrint

  leave
  ret
