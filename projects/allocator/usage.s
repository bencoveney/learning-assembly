.globl _start

.section .text
_start:
.equ LOCAL_ADDRESS_OF_ALLOCATION, -8
  enter $16, $0

  call debugHeap

  # Allocate!
  movq $16, %rdi
  call allocate

  call debugHeap

  # Allocate again!
  movq $24, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  call debugHeap

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated
  call deallocate

  call debugHeap

  # Allocate even more!
  movq $16, %rdi
  call allocate

  call debugHeap

  movq %rax, %rdi
  call exit
