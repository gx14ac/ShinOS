int_pf:

    ;*********************************
    ; ebp + 12 | error code
    ; ebp + 8  | eip(return value)
    ; ebp + 4  | cs
    ; ebp + 0  | ebp(base value)
    ;*********************************
    push	ebp
    mov	ebp, esp

    pusha

    push	ds
    push	es

    mov	ax, 0x0010
    mov	ds, ax
    mov	es, ax

    mov	eax, cr2            ; cr2 is factor addr
    and	eax, ~0x0FFF        ; 4byte per page, so access with in 4k byte
    cmp	eax, 0x0010_7000    ; ptr = access addr
    jne	.10F                ; if (0x0010_7000 == ptr)

    mov	[0x00106000 + 0x107 * 4], dword 0x00107007 ; enalbe paging
    cdecl   memcpy, 0x0010_7000, DRAW_PARAM, rose_size ; draw parametear : task 3

    jmp	.10E
.10F:
    ;******************
    ; resize stack
    ;******************
    add	esp, 4              ; pop es
    add	esp, 4              ; pop ds
    popa
    pop	ebp

    ;*********************
    ; terminate process
    ;*********************
    pushf                       ; eflags
    push	cs
    push	int_stop            ; display stack process

    mov	eax, .s0            ; interrupt
    iret
.10E:
    pop	es
    pop	ds
    popa

    mov	esp, ebp
    pop	ebp

    add	esp, 4

    iret

.s0    db " < PAGE FAULT > ", 0
