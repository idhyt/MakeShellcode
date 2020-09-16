/* entry point. */
.globl _start
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

_child:
    /* syscall write(int fd, const void *buf, size_t count) */
    mov     %r0, $1     /* fd := STDOUT_FILENO */
    ldr     %r1, =_msg   /* buf := msg */
    ldr     %r2, =_len   /* count := len */
    mov     %r7, $4     /* write is syscall #4 */
    swi     $0          /* invoke syscall */

    /* syscall exit(int status) */
    mov     %r0, $0     /* status := 0 */
    mov     %r7, $1     /* exit is syscall #1 */
    swi     $0          /* invoke syscall */

_msg:
    .ascii      "Hello, Shellcode!\n"
_len: 
    .short 16
