.globl _start

.section .text
_start:
.equ LOCAL_ADDRESS_OF_ALLOCATION, -8
  enter $16, $0

  call debugHeap

  # Allocate
  movq $16, %rdi
  call allocate

  call debugHeap

  # Allocate a big block
  movq $64, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  call debugHeap

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated
  call deallocate

  call debugHeap

  # Allocate a subset of that big block
  movq $16, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  call debugHeap

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated
  call deallocate

  call debugHeap

  movq %rax, %rdi
  call exit
