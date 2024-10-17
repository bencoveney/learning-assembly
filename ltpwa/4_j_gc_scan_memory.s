// # This takes a location in memory and the size of that memory and scans it for potential pointers
// # to the heap

// # This file is described in the book, but I think not actually included...
// Somebody else's example here: https://github.com/zapw/miscellaneous/blob/master/gc_scan_memory.s

.globl gc_scan_memory
.section .text

// Called from:
// - gc_scan_base_objects, with the stack (bottom to top) and .rodata.
// - gc_walk_pointers with region of the heap.

// - Start address is in rdi
// - Size is in rsi

gc_scan_memory:
  enter $0, $0

  // Book describes:
  //   Walk through memory and look for anything that "looks like" a pointer (i.e., the value could
  //   be pointing somewhere on the heap).

  // Also:
  //   We will assume that every pointer is stored on an 8-byte boundary.

  # Load the current location in the pointer list.
  movq pointer_list_current, %rdx

  # Make rsi point to the end of the region
  addq %rdi, %rsi

check_on_heap:
  # Load the value rdi points to, this is the candidate pointer.
  movq (%rdi), %rcx

  # See if it is within the heap
  cmpq %rcx, heap_start
  jae go_to_next_address
  cmpq %rcx, heap_end
  jb go_to_next_address

  # Confirmed it points within the heap. Add it to the list.
  movq %rcx, (%rdx)
  # Move to the next position in the list.
  addq $8, %rdx

go_to_next_address:
  # Move to the next memory location
  addq $8,  %rdi

  # Continue checking, if we haven't reached the end of the block yet.
  cmpq %rsi, %rdi
  jne check_on_heap

  # We may have added some pointers to the list, so we need to update the current position
  movq %rdx, pointer_list_current

  leave
  ret
