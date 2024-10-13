.globl _start

.section .data
  .equ my_exception_code, 7

.section .text

myfunc:
  enter $0, $0

  push $0 # Needed to keep the stack aligned.
  push $myfunc_exceptionhandler
  call myfunc2
  # Do more stuff

myfunc_continuemyfunc:
  # Do more stuff here

  leave
  ret

myfunc_exceptionhandler:
  # handle exception - do any exception-handling code here

  # Go back to the code
  jmp myfunc_continuemyfunc

myfunc2:
  enter $0, $0

  pushq $0 # Needed to keep the stack aligned.
  pushq $myfunc2_exceptionhandler
  call myfunc3

  leave
  ret

myfunc2_exceptionhandler:
  # Nothing to do except go to the next handler

  # Restore %rsp/%rbp
  leave
  # Get rid of the return address
  addq $8, %rsp
  # Jump to exception handler
  jmp *(%rsp)

myfunc3:
  enter $0, $0

  # Throw

  # Store exception code
  movq $my_exception_code, %rax
  # Restore %rsp/%rbp
  leave
  # Get rid of return address
  addq $8, %rsp
  # Jump to exception handler
  jmp *(%rsp)

  # What would have happened if we didn't throw the exception
  leave
  ret

_start:
  call myfunc
  movq %rax, %rdi
  movq $60, %rax
  syscall
