; create stack frame.
memcpy:
    push bp
    mov bp, sp

; saving register
    push cx
    push si
    push di

; copy in bytes
    cld            ; clear direction flag. DF=0 does mean increment.
    mov di, [bp+4] ; access to first arg. di desitination index.
    mov si, [bp+6] ; access to second arg. si is source index.
    mov cx, [bp+8] ; access to third arg. cx is counter register.
    
    rep movsb      ; siレジスタの１バイトのメモリ内容をDIレジスタの指すメモリに転送する(cxレジスタ分==byte分)

; return register
    pop di  
    pop si
    pop cx

; removing stack frame
    mov sp, bp
    pop bp

    ret            ; return 呼び出し元