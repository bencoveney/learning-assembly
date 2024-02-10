.globl _start

.section .data
count:
  .quad 7
numbers:
  .quad 5, 20, 33, 80, 52, 10, 1

.section .text
_start:
  movq count, %rcx
  movq $0, %rbx
  movq $0, %rdi

  # If there's no numbers to check, jump to the end
  cmp $0, %rcx
  je exit

loop:
  # Load the next number (using a lookup based on the index into the list)
  movq numbers(,%rbx,8), %rax

  # If it is <= the highest found so far, jump to the next iteration.
  cmp %rdi, %rax
  jbe loopcontrol

  # If it is > the highest found so far, store it as the new highest.
  movq %rax, %rdi

loopcontrol:
  # Step to the next entry in the list (by incrementing the index we use for lookups).
  incq %rbx

  # Decrement the count (%rcx) and loop if still not 0.
  loopq loop

exit:
  # Exit syscall. %rdi should already contain the result.
  movq $60, %rax
  syscall
