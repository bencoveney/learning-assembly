.globl _start

.section .text
_start:
.equ LOCAL_ADDRESS_OF_ALLOCATION, -8
.equ LOCAL_ADDRESS_OF_FIRST_ALLOCATION, -16
  enter $16, $0

  call debugHeap

  # Allocate at the start
  # Size: 4096
  # Blocks: 32 allocated, 4064 free
  movq $16, %rdi
  call allocate

  movq %rax, LOCAL_ADDRESS_OF_FIRST_ALLOCATION(%rbp)

  call debugHeap

  # Allocate a big block
  # Size: 4096
  # Blocks: 32 allocated, 80 allocated, 3984 free
  movq $64, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  call debugHeap

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated
  # Size: 4096
  # Blocks: 32 allocated, 4064 free
  call deallocate

  call debugHeap

  # Allocate a subset of that big block - it should be split
  # Size: 4096
  # Blocks: 32 allocated, 32 allocated, 4032 free
  movq $16, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  call debugHeap

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated - it should be merged forwards
  # Size: 4096
  # Blocks: 32 allocated, 4064 free
  call deallocate

  call debugHeap

  # Allocate a big block
  # Size: 4096
  # Blocks: 32 allocated, 144 allocated, 3920 free
  movq $128, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  call debugHeap

  # Free the first allocation
  # Size: 4096
  # Blocks: 32 free, 144 allocated, 3920 free
  movq LOCAL_ADDRESS_OF_FIRST_ALLOCATION(%rbp), %rdi

  break_here:
  call deallocate

  call debugHeap

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated - it should be merged backwards
  # Size: 4096
  # Blocks: 4064 free
  call deallocate

  call debugHeap

  # Allocate a really big block to fill most of the heap.
  # Size: 8192
  # Blocks: 3088 allocated, 1008 free
  movq $3072, %rdi
  call allocate

  call debugHeap

  # Allocate another really big block - the heap will need to grow.
  # Size: 8192
  # Blocks: 3088 allocated, 3088 allocated, 2016 free
  movq $3072, %rdi
  call allocate

  call debugHeap

  movq %rax, %rdi
  call exit
