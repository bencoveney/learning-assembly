.globl _start

.section .data

logMessage:
  .ascii "Hello\n\0"

.section .text
_start:
.equ LOCAL_ADDRESS_OF_ALLOCATION, -8
  enter $16, $0

  movq $logMessage, %rdi
  call stringPrint

  # Allocate!
  movq $16, %rdi
  call allocate

  movq %rax, %rdi
  call hexPrint

  # Allocate again!
  movq $16, %rdi
  call allocate

  mov %rax, LOCAL_ADDRESS_OF_ALLOCATION(%rbp)

  movq %rax, %rdi
  call hexPrint

  mov LOCAL_ADDRESS_OF_ALLOCATION(%rbp), %rdi

  # Free what we just allocated
  call deallocate

  # Allocate even more!
  movq $16, %rdi
  call allocate

  movq %rax, %rdi
  call hexPrint

  movq %rax, %rdi
  call exit
