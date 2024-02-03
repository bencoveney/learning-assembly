global _start

section .text
_start:
	mov	eax, 4 ; write
	mov	ebx, 1 ; stdout
	mov	ecx, msg
	mov	edx, msg.len
	int	0x80   ; write(stdout, msg, strlen(msg));

	xor	eax, msg.len ; invert return value from write()
	xchg eax, ebx ; value for exit()
	mov	eax, 1 ; exit
	int	0x80   ; exit(...)

section .data
msg:	db	"Hello, world!", 10
.len:	equ	$ - msg