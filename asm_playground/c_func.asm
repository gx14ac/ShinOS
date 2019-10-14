func_test:
    push bp             ; configuraton base address. like bp[0], bp[1], bp[2]...
    mov bp, sp          ; bp = sp;
    sub sp, 2           ; -2 | short i; sub is subtract 
    push 0              ; - 4 | short j = 0 

    mov [bp-2], word 10 ; i = 10
    mov [bp-4], word 20 ; i = 20
    
    mov ax, [bp+4]      ; access to arguments 1;
    add ax, [bp+6]      ; access to arguments 2 & ax = [bp+4] + [bp+6];

    mov ax, 1           ; return 1;
    
    ;remove stack frame.
    mov sp, bp          ; back to sp register. pop to all localize variables.
    pop bp              ; pop to bp register.
    ret                 ; back to stack return value.