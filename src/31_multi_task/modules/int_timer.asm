;************************************************
; File to edit each time a task is added
;************************************************

int_timer:
    pusha
    push ds
    push es

    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    ; refresh interrupt count
    inc dword [TIMER_COUNT]

    ; clear the interrupt flag
    outp 0x20, 0x20

    pop es
    pop ds
    popa

    iret
ALIGN 4, db 0
TIMER_COUNT: dd 0
