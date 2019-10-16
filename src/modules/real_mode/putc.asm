putc:
    ;;; Create Stack Frame.
    push bp         ; push to stack base pointer register.
    mov bp, sp      ; bp = sp. set top stack.
    
    ;;; Saving Register.
    push ax         ; ax (ah, al)
    push bx         ; bx
    
    ;;; Starting put process.
    mov al, [bp+4]  ; get Character output. access to first argument, al = arg.
    mov ah, 0x0E    ; show Character output.
    mov bx, 0x0000  ; set page number & text color to 0
    
    int 0x10        ; call VideoBios.

    ;;; return Register
    pop bx
    pop ax

    ;;; reset Stack frame.
    mov sp, bp
    pop bp
    ret