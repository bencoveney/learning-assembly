  .section .data
  .section .text

  .globl _start
_start:
  # Push arguments (base and power - 2^3) onto the stack in reverse order
  pushl $3
  pushl $2
  # Call function
  call power
  # Move stack pointer back now that we don't need arguments
  addl $8, %esp
  # Save the result to the stack
  pushl %eax

  # Push arguments (base and power - 5^2) onto the stack in reverse order
  pushl $2
  pushl $5
  # Call function
  call power
  # Move stack pointer back now that we don't need arguments
  addl $8, %esp
  # Leave result in %eax

  # Pop prev result into %ebx
  popl %ebx
  # Add both results together
  addl %eax, %ebx

  # Exit syscall
  movl $1, %eax
  int $0x80

  .type power, @function
power:
  # Save the old base pointer and update it to point at the new function base
  pushl %ebp
  movl %esp, %ebp

  # Make room for a variable
  subl $4, %esp
  # Put the first parameter (base) into %ebx
  movl 8(%ebp), %ebx
  # Put the second parameter (power) into %ecx
  movl 12(%ebp), %ecx
  # Store the current result in out variable
  movl %ebx, -4(%ebp)

power_loop_start:
  # Exit condition: power has been decremented to 1
  cmpl $1, %ecx
  # If the exit condition is met, return
  je end_power
  # Move the current result into %eax so we can multiply
  movl -4(%ebp), %eax
  # Multiply the result-so-far by the base number
  imull %ebx, %eax
  # Store the result back into the variable
  movl %eax, -4(%ebp)
  # Decrement the power
  decl %ecx
  # Go around again
  jmp power_loop_start # run for the next power

end_power:
  # Set the result
  movl -4(%ebp), %eax
  # Restore the stack pointer
  movl %ebp, %esp
  # Restore the base pointer to the old base
  popl %ebp
  # Complete the function call and return back to _start
  ret
