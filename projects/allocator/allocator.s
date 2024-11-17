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

# When increasing the program break, how much extra space should we make sure we have available?
# This can help avoiding extra syscalls, because it is possible that subsequent allocations will
# fit within this margin.
.equ MARGIN, 1024

# Align the allocation changes to the (assumed) page-size boundaries, because the OS will be using
# pages behind the scenes anyway.
.equ PROGRAM_BREAK_ALIGNMENT, 4096

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
  je allocate_initialize

  # Loop through blocks of memory until we find a free one. For the duration:
  movq startOfHeap, %rcx

  # %rcx = pointer to memory being examined
  # Jank: I don't think we should be relying on the assumption that nothing will touch %rcx
  allocate_checkNextBlock:

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
  jz allocate_moveToNextBlock

  # Check if it is big enough
  # TODO: Does this check need to exclude the header size? What size are we actually storing?
  movq LOCAL_CURRENT_BLOCK_SIZE(%rbp), %rax
  cmpq %rax, LOCAL_AMOUNT_TO_ALLOCATE(%rbp)
  jbe allocate_blockFound

  allocate_moveToNextBlock:
  movq LOCAL_CURRENT_BLOCK_SIZE(%rbp), %rax
  addq %rax, %rcx

  # Check if we have reached the end of the heap
  cmpq endOfHeap, %rcx
  jae allocate_reachedEndOfHeap

  jmp allocate_checkNextBlock

  allocate_reachedEndOfHeap:

  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rax
  jmp allocate_expandHeap

  allocate_blockFound:

  # Mark the block as allocated.
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  movq %rcx, %rsi
  call allocateExistingBlock

  # Return the pointer to the content
  addq $HEADER_SIZE, %rcx
  movq %rcx, %rax

  leave
  ret

  allocate_initialize:

  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  call initialise

  leave
  ret

  allocate_expandHeap:

  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  call expandHeap

  leave
  ret

# Initializes the heap.
# Param %rdi: The amount to allocate.
# Return %rax: The address of the allocation.
initialise:
.equ LOCAL_TARGET_SIZE, -8
.equ LOCAL_DESIRED_HEAP_SIZE, -16
  enter $16, $0

  movq %rdi, LOCAL_TARGET_SIZE(%rbp)

  # Call brk to work out where the heap begins.
  movq $0, %rdi
  call brk
  movq %rax, startOfHeap

  movq LOCAL_TARGET_SIZE(%rbp), %rdi
  movq %rax, %rsi
  call expandHeapFrom

  leave
  ret

# Expands the heap to accomodate an allocation which would not fit in any existing blocks.
# Param %rdi: The amount to allocate.
# Return %rax: The address of the allocation.
expandHeap:
.equ LOCAL_TARGET_SIZE, -8
.equ LOCAL_GROW_FROM, -16
.equ LOCAL_PREV_BLOCK_ADDR, -24
.equ LOCAL_DESIRED_HEAP_END, -32
  enter $32, $0

  movq %rdi, LOCAL_TARGET_SIZE(%rbp)

  # Assume we will be growing from the end of the heap.
  movq endOfHeap, %rax
  movq %rax, LOCAL_GROW_FROM(%rbp)

  # Check if the current last block is free. If so, the allocation can start from there.
  movq endOfHeap, %rax
  subq $FOOTER_SIZE, %rax
  movq (%rax), %rdi
  call readSizeFromFooter
  movq endOfHeap, %rdi
  sub %rax, %rdi
  movq %rdi, LOCAL_PREV_BLOCK_ADDR(%rbp)

  movq (%rdi), %rdi
  call readAllocatedFromHeader

  # If it is free
  cmpq $0x1, %rax
  jz expandHeap_locationFound
  movq LOCAL_PREV_BLOCK_ADDR(%rbp), %rax
  movq %rax, LOCAL_GROW_FROM(%rbp)

  expandHeap_locationFound:
  movq LOCAL_TARGET_SIZE(%rbp), %rdi
  movq LOCAL_GROW_FROM(%rbp), %rsi

  call expandHeapFrom

  leave
  ret

# Expands the heap from a specified point to accomodate an allocation.
# Param %rdi: The amount to allocate.
# Param %rsi: The location to expand from
# Return %rax: The address of the allocation.
expandHeapFrom:
.equ LOCAL_TARGET_SIZE, -8
.equ LOCAL_GROW_FROM, -16
.equ LOCAL_DESIRED_HEAP_END, -24
  enter $32, $0

  movq %rdi, LOCAL_TARGET_SIZE(%rbp)
  movq %rsi, LOCAL_GROW_FROM(%rbp)

  # Calculate the new end of the heap.
  movq LOCAL_GROW_FROM(%rbp), %rdi
  addq LOCAL_TARGET_SIZE(%rbp), %rdi
  add $MARGIN, %rdi
  movq $PROGRAM_BREAK_ALIGNMENT, %rsi
  call roundUp
  movq %rax, LOCAL_DESIRED_HEAP_END(%rbp)

  # Grow the heap.
  movq LOCAL_DESIRED_HEAP_END(%rbp), %rdi
  call brk

  movq LOCAL_DESIRED_HEAP_END(%rbp), %rax
  movq %rax, endOfHeap

  # Write the allocated block.
  movq LOCAL_TARGET_SIZE(%rbp), %rdi
  movq $0x1, %rsi
  movq LOCAL_GROW_FROM(%rbp), %rdx
  call writeBlock

  # Write the remainder.
  movq endOfHeap, %rdi
  subq LOCAL_GROW_FROM(%rbp), %rdi
  subq LOCAL_TARGET_SIZE(%rbp), %rdi
  movq $0x0, %rsi
  movq endOfHeap, %rdx
  subq %rdi, %rdx
  call writeBlock

  # Return the allocated address.
  movq LOCAL_GROW_FROM(%rbp), %rax
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

  # Check if it is off the end of the heap
  cmpq endOfHeap, %rax
  jae deallocate_lookBackwards

  movq LOCAL_NEXT_BLOCK_ADDR(%rbp), %rdi
  movq (%rdi), %rdi
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

  # Check if it is at the start of the heap
  movq LOCAL_TARGET_BLOCK_ADDR(%rbp), %rax
  cmpq startOfHeap, %rax
  jbe deallocate_writeHeader

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
  call writeBlock

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
  call writeBlock

  leave
  ret

  allocateExistingBlock_split:
  # The block is big enough to split. Make the allocation as normal.
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdi
  movq $0x1, %rsi
  movq LOCAL_CURRENT_BLOCK_LOCATION(%rbp), %rdx
  call writeBlock

  # Create a free block in the remainder.
  # Take the allocated size from the block size to calculate the delta which is left as free.
  movq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rax
  movq LOCAL_CURRENT_BLOCK_SIZE(%rbp), %rdi
  subq %rax, %rdi
  movq $0x0, %rsi
  # Add the delta to the allocation location to get the free block's location.
  movq LOCAL_CURRENT_BLOCK_LOCATION(%rbp), %rdx
  addq LOCAL_AMOUNT_TO_ALLOCATE(%rbp), %rdx
  call writeBlock

  leave
  ret

# Writes the header and footer for a block of memory.
# Param %rdi: The size of the block.
# Param %rsi: Whether the block is allocated.
# Param %rdx: The pointer to the location the block should be written to.
writeBlock:
.equ LOCAL_BLOCK_SIZE, -8
.equ LOCAL_BLOCK_LOCATION, -16
  enter $16, $0
  movq %rdi, LOCAL_BLOCK_SIZE(%rbp)
  movq %rdx, LOCAL_BLOCK_LOCATION(%rbp)

  call writeHeader

  movq LOCAL_BLOCK_SIZE(%rbp), %rdi
  movq LOCAL_BLOCK_LOCATION(%rbp), %rsi
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
# Param %rsi: The pointer to the location of the block's header.
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
  movq $0x8, %rsi
  call roundUp
  # %rax will already have the result.
  leave
  ret

# Takes the given value, and rounds it up (if required) to the nearest multiple of a power of 2.
# Param %rdi: The value to round.
# Param %rsi: The power of 2 to round to a multiple of (e.g. round to nearest multiple of 8, if 8 is passed).
# Return %rax: The rounded value.
roundUp:
  enter $0, $0
  # Create the mask
  movq %rsi, %rdx
  blsmskq %rsi, %rdx
  subq %rsi, %rdx
  notq %rdx
  # Mask off the bits
  movq %rdi, %rax
  andq %rdx, %rax
  # If the value matches what was initially passed, then it is already divisible.
  cmpq %rdi, %rax
  je roundUp_done
  # Otherwise, increment by the power of 2.
  add %rsi, %rax
  roundUp_done:
  leave
  ret

.section .data

borderMessage:
  .ascii "\n--------\n\0"

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

  movq $borderMessage, %rdi
  call stringPrint

  cmpq $0, startOfHeap
  je debugHeap_heapNotInitialized

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
  debugHeap_debugBlock:

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
  jnz debugHeap_allocated

  movq $freeMessage, %rdi
  call stringPrint
  jmp debugHeap_debugToNextBlock

  debugHeap_allocated:
  movq $allocatedMessage, %rdi
  call stringPrint

  debugHeap_debugToNextBlock:

  # Grab the size again - could be refactored
  movq LOCAL_CURRENT_BLOCK(%rbp), %rcx
  movq (%rcx), %rdi
  andq $0xfffffffffffffff8, %rdi
  addq %rdi, %rcx
  # Check if we have reached the end of the heap
  cmpq endOfHeap, %rcx
  jb debugHeap_debugBlock

  leave
  ret

  debugHeap_heapNotInitialized:

  movq $heapNotInitializedMessage, %rdi
  call stringPrint

  leave
  ret
