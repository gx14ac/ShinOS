;**********************************************************
; interrupt process : keyboard
;**********************************************************
; get keycode from KBC(key board controller), by the way
; saving exclusive ring buffer
;**********************************************************
int_keyboard:
    pusha
    push  ds
    push  es

    ;*****************************
    ; segment settings for data
    ;*****************************
    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    ;**********************
    ; receive KBC Buffer
    ;**********************
    in al, 0x60

    ;*****************************
    ; saving keycode
    ;*****************************
    cdecl ring_wr, _KEY_BUFF, eax

    ;**********************************
    ; send interrupt terminate command
    ;**********************************
    outp 0x20, 0x20

    pop es
    pop ds

    iret ; return interrupt process
ALIGN 4, db 0
_KEY_BUFF: times ring_buff_size db 0
