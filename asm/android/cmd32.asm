.globl _start
_start:   
    adr r0, bin_sh_1
    adr r5, opt_1
    adr r6, cmd_1
    mov r8, #0
    push {r0, r5, r6, r8}
    mov r1, sp
    mov r2, #0
    movw r7, #11
    swi $0

bin_sh_1:
    .asciz "/system/bin/sh"

opt_1:
    .asciz "-c"

cmd_1:
    .asciz "ls -al"
