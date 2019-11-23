;*********************************************************************
;    Write Ouput Buffer of KBC
;=====================================================================
; ** Format           : word write_kbc_data(data);
;
; ** Arguments
;     data            : write data.
;
; ** return values    : success(Expect 0), failure(0)
;*********************************************************************

write_kbc_data:

    push bp
    mov bp, sp

    push cx                     ; cx is counter register.

    mov cx, 0
.10L:
    in al, 0x64                 ; checking KBC Status
    test al, 0x02               ; zf = AL & 0x02. can i write a keyboard?
    loopnz .10L                 ; --CX(not 0) && !ZF

    cmp cx, 0
    jz .20E                     ; if (cx == 0) {
    mov al, [bp + 4]            ;     al = date
    out 0x60, al                ;     outp(0x60, al). 0x60 is input keyboard key.
                                ; }
.20E:

    mov ax, cx

    pop cx

    mov sp, bp
    pop bp

    ret

read_kbc_date:
    push bp
    mov bp, sp

    push cx

    mov cx, 0
.10L:
    in al, 0x64
    test al, 0x01
    loopnz .10L

    cmp cx, 0
    jz .20E
    mov ah, 0x00                ;
    in al, 0x60

    mov di, [bp + 4]
    mov [di + 0], ax

.20E:

    mov ax, cx

    pop cx

    mov sp, bp
    pop bp

    ret
