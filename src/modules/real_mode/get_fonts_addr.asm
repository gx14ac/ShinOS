get_font_addr:
    ;----------------------
    ; - Create Stack Frame.
    ;----------------------

    ;; +4 | Font addres position.
    ;; +2 | IP(return position).
    ;; BP + 0 | Base Position.

    push bp
    mov  bp, sp

    ;----------------------
    ; - Saving Register.
    ;----------------------
    push ax
    push bx
    push si
    push es
    push bp

    ;----------------------
    ; - Get arg.
    ; - Saving font addr.
    ;----------------------
    mov si, [bp + 4]            ; si = Font address(bp+4)

    ;----------------------
    ; - Get font addr.
    ;----------------------
    mov ax, 0x1130              ; ax = Fontaddr.
    mov bh, 0x06                ; bh = 8x16 font(vga/mcga). size.
    int 10h                     ; es:bp(segment:offset) = Fontaddr.

    ;----------------------
    ; - Saving Font addr.
    ;----------------------
    mov [si + 0], es            ; dst[0] = segment,
    mov [si + 2], bp            ; dst[1] = offset.

    ;----------------------
    ; - Return Register.
    ;----------------------
    pop bp
    pop es
    pop si
    pop bx
    pop ax

    ;----------------------
    ; - Removing Stack Frame.
    ;----------------------
    mov sp, bp
    pop bp
    ret
