memcmp:
    push bp
    mov bp, sp
    
    push bx
    push cx
    push dx
    push si
    push di

    cld
    mov si, [bp+4]
    mov di, [bp+6]
    mov cx, [bp+8]
    
    repe cmpsb ; si == di
    jnz .10F   ; false jmp to .10F
    mov ax, 0  ; return true
    jmp .10E   ; end
.10F
    mov ax, -1 ; return false
.10E

    pop di
    pop si
    pop dx
    pop cx
    pop bx

    mov sp, bp
    pop bp

    ret