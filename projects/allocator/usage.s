.globl _start

.section .text
_start:
.equ LOCAL_ADDRESS_OF_ALLOCATION, -8
.equ LOCAL_ADDRESS_OF_FIRST_ALLOCATION, -16
  enter $16, $0

  call debugHeap

  # Allocate at the start
  # Blocks: 32 (allocated)
  movq $16, %rdi
  call allocate

  movq %rax, LOCAL_ADDRESS_OF_FIRST_ALLOCATION(%rbp)

  call debugHeap

  # Allocate a big block
  # Blocks: 32 (allocated), 80 (allocated)
  movq $64, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  call debugHeap

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated
  # Blocks: 32 (allocated), 80 (free)
  call deallocate

  call debugHeap

  # Allocate a subset of that big block - it should be split
  # Blocks: 32 (allocated), 32 (allocated), 48 (free)
  movq $16, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  call debugHeap

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated - it should be merged forwards
  # Blocks: 32 (allocated), 80 (free)
  call deallocate

  call debugHeap

  # Allocate a big block
  # Blocks: 32 (allocated), 80 (free), 144 (allocated)
  movq $128, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  call debugHeap

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated - it should be merged backwards
  # Blocks: 32 (allocated), 224 (free)
  call deallocate

  call debugHeap

  # Free the first allocation
  # Blocks: 256 (free)
  movq LOCAL_ADDRESS_OF_FIRST_ALLOCATION(%rbp), %rdi
  call deallocate

  call debugHeap

  movq %rax, %rdi
  call exit
