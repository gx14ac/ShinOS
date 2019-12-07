;************************************************
; File to edit each time a task is added
;************************************************

int_timer:
    pushad
    push ds
    push es

    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    ; refresh interrupt count
    inc dword[TIMER_COUNT]

    ; clear the interrupt flag
    outp 0x20, 0x20

    pop es
    pop ds
    popad

    iret
ALIGN 4, db 0
TIMER_COUNT: dd 0
