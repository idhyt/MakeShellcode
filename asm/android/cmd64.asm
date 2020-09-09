 /*
    execve("/system/bin/sh", {"system/bin/sh", "-c", cmd, NULL}, NULL);
 */

.global _start
_start:
    SUB             SP, SP, #0x40
    STP             X29, X30, [SP, #0x30]
    /* set x0: /system/bin/sh */
    ADR             X0, shell
    /* set x1: /system/bin/sh -c ls -al */
    MOV             X5, 0
    STR             X5, [SP, #0x28]
    ADR             X5, cmd
    STR             X5, [SP, #0x20]
    ADR             X5, opt
    STR             X5, [SP, #0x18]
    STR             X0, [SP, #0x10]
    ADD             X1, SP, #0x10
    /* set x1: env */
    MOV             X5, 0
    STR             X5, [SP, #0x8]
    ADR             X5, env
    STR             X5, [SP]
    MOV             X2, SP
    /* syscall execve: 221 */
    MOV             X8, 221
    SVC             0
    /* return */
    LDP             X29, X30, [SP, #0x30]
    ADD             SP, SP, #0x40
    RET

shell:
    .ascii "/system/bin/sh\0"
opt:
    .ascii "-c\0"
cmd:
    .ascii "ls -al\0"
env:
    .ascii "PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin\0"
