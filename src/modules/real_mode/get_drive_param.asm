get_drive_param:
    ;---------------------
    ; - Create Stack Frame.
    ;---------------------

    ;; +4 | parameter buffer.
    ;; +2 | IP (return postion).
    ;; BP + 0 | BP(base position).

    push bp
    mov  bp, sp

    ;---------------------
    ; - Saving Register.
    ;---------------------

    push bx
    push cx
    push es
    push si
    push di

    mov si, [bp + 4]            ; si = buffer.
    mov ax, 0                   ; Initialize Disk Base Table Pointer
    mov es, ax                  ; es = 0.
    mov di, ax                  ; di = 0.

    mov ah, 0x08                   ; get drive parameter(geometry).
    mov dl, [si + drive.no]     ; dl = drive number.
    int 0x13                    ; CF = BIOS(0x13, 8). (0x13, 8) is get driver geometry.

.10Q: jc .10F                   ; if (0 == CF) {
.10T:
    mov al, cl                  ; ax = sector number.
    and ax, 0x3F                ; enable worst 6 bits.

    shr cl, 6
    ror cx, 8                   ; cx = cylnder count.
    inc cx

    movzx bx, dh                ; bx = head count(1 base).
    inc bx

    mov [si + drive.cyln], cx   ; drive.syln = cx
    mov [si + drive.head], bx   ; drive.head = bx
    mov [si + drive.sect], ax   ; drive.sect = ax

    jmp .10E
.10F:                           ; else {
    mov ax, 0                   ; ax = 0. // failure.
.10E:                           ; }

    ;-----------------------
    ; - Return register.
    ;-----------------------
    pop di
    pop si
    pop es
    pop cx
    pop bx

    ;-----------------------
    ; - Remove stack frame.
    ;-----------------------
    mov sp, bp
    pop bp

    ret
