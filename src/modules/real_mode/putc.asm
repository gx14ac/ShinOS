putc:
    ;---------------------
    ; Create Stack Frame.
    ;---------------------
    push bp          ; push to stack base pointer register.
    mov  bp, sp      ; bp = sp. set top stack.

    ;---------------------
    ; Saving Register.
    ;---------------------
    push ax         ; ax (ah, al)
    push bx         ; bx
    push si         ; si

    ;---------------------
    ; Get func argument.
    ;---------------------
    mov si, [bp + 4]

    ;---------------------
    ; Starting put process.
    ;---------------------
    mov ah, 0x0E    ; show Character output.
    mov bx, 0x0000  ; set page number & text color to 0
    cld             ; DF = 0.

.10L:               ; do
                    ; {
    lodsb           ; AL = *SI++.
                    ;
    cmp al, 0       ; if(0 == AL)
    je .10E         ; break
                    ;
    int 0x10        ; Int10(0x0E, AL); prrint char.
    jmp .10L        ;
.10E:               ; while(1)

    ;---------------------
    ; return Register.
    ;---------------------
    pop si
    pop bx
    pop ax

    ;---------------------
    ; reset Stack frame.
    ;---------------------
    mov sp, bp
    pop bp
    ret
