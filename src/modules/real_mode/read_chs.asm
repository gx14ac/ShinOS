;; Reading Sector Function.
read_chs:
    ;---------------------
    ; -Create Stack Frame.
    ;---------------------

    ;; +8 | copy to
    ;; +6 | sector count.
    ;; +4 | buffer parameter.
    ;; +2 | IP(return address.)
    ;; BP+0 | BP(base pointer)

    push bp
    mov  bp, sp
    push 3                      ; -2 | retry = 3
    push 0                      ; Reading sector count.

    ;; Saving Register.
    push bx
    push cx
    push dx
    push es
    push si

    ;; Starting Process.
    mov si, [bp + 4]                ; si = buffer parameter.

    ;; Configure CX Register
    mov ch, [si + drive.cyln + 0] ; ch = Cylinder Number.
    mov cl, [si + drive.cyln + 1] ; cl = Cylinder Number.

    shl cl, 6                     ; cl << 6 Shift to top 2 bits.
    or  cl, [si + drive.sect]    ; cl |= Sector Number.

    ;-------------------
    ; - Reading Sector.
    ;-------------------
    mov dh, [si + drive.head]     ; dh = Head Number.
    mov dl, [si + 0]              ; dl = Drive Number.
    mov ax, 0x0000                ; ax = 0x0000.
    mov es, ax                    ; es = Segment.
    mov bx, [bp + 8]              ; bx = Copy to

.10L:
    mov ah, 0x02                  ; ah = Reading Sector.
    mov al, [bp + 6]              ; al = sector count.

    int 0x13                      ; CF(0x13, 0x12)
    jnc .11E                      ; if(CF)

    mov al, 0                     ; al = 0
    jmp .10E                      ; break
.11E:
    cmp al, 0
    jne .10E

    mov ax, 0                       ; ret = 0
    dec word[bp - 2]                ;
    jnz .10L                        ; while(-retry)
.10E:
    mov ah, 0                       ; ah = 0. removing status information.

    ;--------------------
    ; - Return registers.
    ;--------------------
    pop si
    pop es
    pop dx
    pop cx
    pop bx

    ;--------------------
    ; - Remove Stack Frame.
    ;--------------------
    mov sp, bp
    pop bp
    ret
