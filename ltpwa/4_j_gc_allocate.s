# Contains the code for the gc_init function, which initializes the garbage collector. This saves
# the location of the beginning of the stack and initializes the beginning/end of the heap

.include "4_j_gc_defs.s"
.globl gc_allocate

.section .text

# Register usage:
# - %rdx - size requested
# - %rsi - pointer to current memory being examined
# - %rcx - copy of heap_end

allocate_move_break:
  # Old break is saved in %r8 to return to user
  movq %rcx, %r8

  # Calculate where we want the new break to be
  # (old break + size)
  movq %rcx, %rdi
  addq %rdx, %rdi
  # Save this value
  movq %rdi, heap_end

  # Tell Linux where the new break is
  movq $BRK_SYSCALL, %rax
  syscall

  # Address is in %r8 - mark size and availability
  movq $1, HDR_IN_USE_OFFSET(%r8)
  movq %rdx, HDR_SIZE_OFFSET(%r8)

  # Actual return value is beyond our header
  addq $HEADER_SIZE, %r8
  movq %r8, %rax
  ret

gc_allocate:
  enter $0, $0
  # Keep stack aligned
  pushq $0
  # Save for later
  pushq %rdi
  call gc_allocate_internal

  # Zero out the block to eliminate false pointers
  # Save original pointer
  movq %rax, %rdx
  # Get the size of the block
  popq %rcx
zeroloop:
  movb $0, (%rdx)
  incq %rdx
  loop zeroloop

  leave
  ret

gc_allocate_internal:
  # Save the amount requested into %rdx
  movq %rdi, %rdx
  # Actual amount needed is actually larger
  addq $HEADER_SIZE, %rdx
  # Align %rdx to a 16-bit boundary
  # Advance 16 bits
  addq $16, %rdx
  # Clear last bits
  andq $0xfffffffffffffff0, %rdx
  # Put heap start/end in %rsi/%rcx
  movq heap_start, %rsi
  movq heap_end, %rcx

allocate_loop:
  # If we have reached the end of memory
  # we have to allocate new memory by
  # moving the break.
  cmpq %rsi, %rcx
  je allocate_move_break

  # is the next block available?
  cmpq $0, HDR_IN_USE_OFFSET(%rsi)
  jne try_next_block

  # Is the next block big enough
  cmpq %rdx, HDR_SIZE_OFFSET(%rsi)
  jb try_next_block

  # This block is great!
  # Mark it as unavailable
  movq $1, HDR_IN_USE_OFFSET(%rsi)
  # Move beyond the header
  addq $HEADER_SIZE, %rsi
  # Return the value
  movq %rsi, %rax
  ret

try_next_block:
  # This block didn't work, move to the next one
  addq HDR_SIZE_OFFSET(%rsi), %rsi
  jmp allocate_loop

