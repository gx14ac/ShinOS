;**************************
; Decimal arithmetic
;**************************
task_2:

    ;***************************
    ; Initialize
    ;***************************

                                    ; ---------+---------+---------|---------|---------|---------|
                                    ;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
    ; fild is set FPU integer stack ; ---------+---------+---------|---------|---------|---------|
    fild  dword [.c1000]            ;     1000 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
    fldpi                           ;       pi |    1000 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
    fidiv dword [.c180]             ;   pi/180 |    1000 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
    fldpi                           ;       pi |  pi/180 |    1000 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
    fadd st0, st0                   ;     2*pi |  pi/180 |    1000 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
    fldz                            ;   θ = 0 |    2*pi |  pi/180 |    1000  |xxxxxxxxx|xxxxxxxxx|
                                    ; ---------+---------+---------|---------|---------|---------|
                                    ;   θ = 0 |    2*pi |       d |    1000  |xxxxxxxxx|xxxxxxxxx|
                                    ; ---------+---------+---------|---------|---------|---------|
    ;*******************
    ; main loop
    ;*******************
.10L:
    fadd  st0, st2
    fprem
    fld   st0
    fsin
    fmul  st0, st4

    fbstp [.bcd]

    mov   eax, [.bcd]           ; eax = 1000 * sin(t)
    mov   ebx, eax              ; ebx = eax

    and   eax, 0x0F0F           ; mask of upper 4bit
    or    eax, 0x3030           ; setting 0x3 in upper 4bit

    shr   ebx, 4                ; ebx >> 4
    and   ebx, 0x0F0F           ; mask in upper 4bit
    or    ebx, 0x3030           ; setting 0x3 in uppper 4bit

    mov   [.s2 + 0], bh         ; 1digits
    mov   [.s3 + 0], ah         ; decimal 2digits
    mov   [.s3 + 1], bl         ; decimal 3digits
    mov   [.s3 + 2], al         ; decimal 4digits

    mov   eax, 7                ; display of sign
    bt    [.bcd + 9], eax       ; cf = bcd[9] & 0x80
    jc	  .10F                  ; if (cf)
                                ; {
    mov   [.s1 + 0], byte '+'   ;     *s1 = '+'
    jmp   .10E                  ; }
.10F:                           ; else
                                ; {
    mov   [.s1 + 0], byte '-'   ; *s1 = '-'
.10E:                           ; }
    cdecl draw_str, 72, 1, 0x07, .s1 ;draw_str(.s1)

    mov ecx, 20                 ; ecx = 20
.20L: mov eax, [TIMER_COUNT]
.21L: cmp [TIMER_COUNT], eax
    je .21L
    loop .20L

    jmp .10L

ALIGN 4, db 0
.c1000: dd 1000
.c180:  dd 180

.bcd: times 10 db 0x00

.s0 db "Task-2", 0
.s1: db "-"
.s2: db "0."
.s3: db "000", 0
