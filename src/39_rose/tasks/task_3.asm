task_3:
    mov ebp, esp

    push	dword 0
    push	dword 0
    push	dword 0
    push	dword 0
    push	dword 0

    ; initialize
    mov	esi, DRAW_PARAM     ; esi = param

    ; display the title
    mov	eax, [esi + rose.x0]
    mov	ebx, [esi + rose.y0]

    shr	eax, 3
    shr	ebx, 4
    dec	ebx
    mov	ecx, [esi + rose.color_s]
    lea	edx, [esi + rose.title]

    cdecl   draw_str, eax, ebx, ecx, edx

    ;*********************
    ; X middle Position
    ;*********************
    mov	eax, [esi + rose.x0]
    mov	ebx, [esi + rose.x1]
    sub	ebx, eax
    shr	ebx, 1
    add	ebx, eax
    mov	[ebp - 4], ebx

    ;*********************
    ; Y middle Position
    ;*********************
    mov	eax, [esi + rose.y0]
    mov	ebx, [esi + rose.y1]
    sub	ebx, eax
    shr	ebx, 1
    add	ebx, eax
    mov	[ebp - 8], ebx

    ;*********************
    ; draw X Position
    ;*********************
    mov	eax, [esi + rose.x0]
    mov	ebx, [ebp - 8]
    mov	ecx, [esi + rose.x1]

    cdecl   draw_line, eax, ebx, ecx, ebx, dword [esi + rose.color_x] ; X position

    ;*********************
    ; draw Y Position
    ;*********************
    mov	eax, [esi + rose.y0]
    mov	ebx, [ebp - 4]
    mov	ecx, [esi + rose.y1]

    cdecl   draw_line, ebx, eax, ebx, ecx, dword [esi + rose.color_y] ; Y position

    ;******************
    ; draw frame
    ;******************
    mov	eax, [esi + rose.x0]
    mov	ebx, [esi + rose.y0]
    mov	ecx, [esi + rose.x1]
    mov	edx, [esi + rose.y1]

    cdecl   draw_rect, eax, ebx, ecx, edx, dword [esi + rose.color_z] ; frame

    ;****************
    ; amplitube
    ;****************
    mov	eax, [esi + rose.x1] ; eax = x1 position
    sub	eax, [esi + rose.x0] ; eax -= x0 position
    shr	eax, 1               ; eax /= 2
    mov	ebx, eax             ; ebx = eax
    shr	ebx, 4               ; ebx /= 16
    sub	eax, ebx             ; eax -= ebx

    ;******************
    ; initialize FPU
    ;******************
    cdecl    fpu_rose_init              \
                 , eax                  \
                 , dword [esi + rose.n] \
                 , dword [esi + rose.d]

    ;******************
    ; main loop
    ;******************
.10L:
    ;******************
    ; calc position
    ;******************
    lea	ebx, [ebp - 12]
    lea	ecx, [ebp - 16]
    mov	eax, [ebp - 20]

    cdecl    fpu_rose_update \
                 , ebx       \
                 , ecx       \
                 , eax

    ;*****************************
    ; update rad(r = r % 36000)
    ;*****************************
    mov	edx, 0
    inc	eax
    mov	ebx, 360 * 100
    div	ebx
    mov	[ebp - 20], edx

    ;************
    ; draw dot
    ;************
    mov	ecx, [ebp - 12]
    mov	edx, [ebp - 16]

    add	ecx, [ebp - 4]
    add	edx, [ebp - 8]

    mov	ebx, [esi + rose.color_f]
    int	0x82

    ;***********
    ; wait
    ;***********
    cdecl    wait_tick, 2       ; wait_tick(2)

    ;******************
    ; draw dot(delete)
    ;******************
    mov	ebx, [esi + rose.color_b]
    int	0x82

    jmp	.10L

ALIGN 4, db 0
DRAW_PARAM:
  istruc	rose
        at	rose.x0,		dd		 16
        at	rose.y0,		dd		 32
        at	rose.x1,		dd		416
        at	rose.y1,		dd		432

        at	rose.n,		dd		2
        at	rose.d,		dd		1

        at	rose.color_x,	dd		0x0007
        at	rose.color_y,	dd		0x0007
        at	rose.color_z,	dd		0x000F
        at	rose.color_s,	dd		0x030F
        at	rose.color_f,	dd		0x000F
        at	rose.color_b,	dd		0x0003

        at	rose.title,	db		"Task-3", 0
  iend

;*****************************************************
; curve rose : init
;	x = A * sin(nθ) * cos(θ)
;	y = A * sin(nθ) * sin(θ)
;   k = (n/d)
;   r = π / 180, because rad = angle * (π / 180)
;*****************************************************
; ** format : void fpu_rose_init(A, n, d)
; ** arg
;        DWORD : A
;        DWORD : A
;        DWORD : A
;*****************************************************
fpu_rose_init:

    ;*********************************
    ; ebp +16 | d
    ; ebp +12 | n
    ; ebp + 8 | A
    ; ebp + 4 | eip(return value)
    ; ebp + 8 | ebp(base value)
    ;*********************************

    push ebp
    mov  ebp, esp

    push dword 180

    ;**********************
    ; using FPU process
    ;**********************
                                              ; ---------+---------+---------|---------|---------|---------|
                                              ;       ST0|      ST1|      ST2|      ST3|      ST4|      ST5|
                                              ; ---------+---------+---------|---------|---------|---------|
    fldpi                                     ;   pi     |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
    fidiv dword [ebp - 4]                     ;   pi/180 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
    fild  dword [ebp + 12]                    ;        n |  pi/180 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
    fidiv dword [ebp + 16]                    ;      n/d |         |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
    fild  dword [ebp + 8]                     ;        A |     n/d |  pi/180 |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
                                              ; ---------+---------+---------|---------|---------|---------|
                                              ;        A |       k |       r |xxxxxxxxx|xxxxxxxxx|xxxxxxxxx|
                                              ; ---------+---------+---------|---------|---------|---------|

    mov esp, ebp
    pop ebp

    ret

;*****************************************************
; curve rose : calu
;*****************************************************
; ** format : void fpu_rose_update(t, X, Y)
; ** arg
;        DWORD : angle
;        DWORD : Y pointer
;        DWORD : X pointer
;*****************************************************
fpu_rose_update:

    ;******************************
    ; ebp +16 | t(angle)
    ; ebp +12 | Y(float)
    ; ebp + 8 | X(float)
    ; ebp + 4 | eip(return value)
    ; ebp + 8 | ebp(base value)
    ;******************************
    push ebp
    mov  ebp, esp

    push eax
    push ebx

    ; saving X/Y register
    mov eax, [ebp + 8]          ; eax = pX
    mov ebx, [ebp + 12]         ; ebx = pY

    ;**********************
    ; using FPU process
    ;**********************

    fild dword [ebp + 16]
    fmul st0, st3
    fld  st0

    fsincos
    fxch    st2
    fmul    st0, st4
    fsin
    fmul	st0, st3

    fxch	st2
    fmul	st0, st2
    fistp	dword [eax]

    fmulp	st1, st0
    fchs
    fistp	dword [ebx]

    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret
