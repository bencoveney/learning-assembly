  .section .data
  # Define the label "data items"
data_items:
  # The list of values, with a terminating 0.
  # .long is the wordsize - 4 bytes.
  .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0
  .section .text
  .globl _start
_start:
  # Index register used for the index into the list.
  # Should be 0 as we are at the start.
  movl $0, %edi
  # %eax used for value being checked.
  # Load it from data_items.
  # Addressing says "from beginning address (of data_items), jump (index) times 4 bytes".
  # A word size of 4 matches up with "long" in the .data section.
  movl data_items(,%edi,4), %eax
  # %ebx used for highest we have found so far.
  # Since we are just starting, the first item will be the biggest (and smallest) by default.
  movl %eax, %ebx
  # Mark the start of the loop, so we can jump back here for the next iteration.
start_loop:
  # Compare the current list value to 0. We are using that to signify the end of the list.
  # Result will be stored in the eflags register.
  cmpl $0, %eax
  # If the values "equal" (as stored in the eflags register), jump to the loop_exit label.
  je loop_exit
  # Incrementing the index register effectively moves us to the next number of the list.
  incl %edi
  # Load the next number from the list.
  movl data_items(,%edi,4), %eax
  # Compare the current number to the highest one we have found so far.
  cmpl %ebx, %eax
  # If the current number is lower than (or equal to) the highest, then there's nothing more to do.
  # We can jump back to the start of the loop and begin the process again for the next item in the list.
  jle start_loop
  # Otherwise, execution will flow on further...
  # As we didn't jump away, the number must be higher. We should update %ebx to keep track of it.
  movl %eax, %ebx
  # We can jump back to the start of the loop and begin the process again for the next item in the list.
  jmp start_loop
loop_exit:
  # Get ready to call the exit syscall.
  # %ebx would contain the return value. It already contains the highest number, so we don't need to do anything to update it.
  movl $1, %eax
  # Do the syscall.
  int $0x80
