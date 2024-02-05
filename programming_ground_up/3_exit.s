  # (Empty) Data section.
  .section .data
  # Text section.
  .section .text
  .globl _start
_start:
  # this is the linux kernel command number (system call) for exiting a program
  movl $1, %eax
  # this is the status number we will return to the operating system.
  movl $0, %ebx
  # this wakes up the kernel to run the exit command
  int $0x80
