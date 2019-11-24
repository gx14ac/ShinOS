;---------------------------------------------------------------
; show memory info.
;---------------------------------------------------------------
; - format : void get_memory_info(void);
; - arg    : none
; - return value : none
get_memory_info:
    ; saving register.
    push eax
    push ebx
    push ecx
    push edx
    push si
    push di
    push bp

    cdecl putc, .s0

    mov bp, 0                   ; lines = 0
    mov ebx, 0                  ; index = 0
.10L:
    mov eax, 0x0000E820
    mov ecx, E820_RECORD_SIZE   ; 21bytes. 21 <-> 0 == 0x15??
    mov edx, 'PAMS'
    mov di, .b0                 ; ES:DI = Buffer
    int 0x15                    ; BIOS(0x15, eax) = Get Memory Information.

    cmp eax, 'PAMS'             ; if (eax == SMAP)
    je  .12E                     ; true
    jmp .10E                    ; false
.12E:
    jnc .14E                    ; if(CF). jnc is comapare CF flag.
    jmp .10E                    ; break
.14E:
    cdecl put_memory_info, di      ; show the just one memory record.
    ; Get address for ACPI data.
    mov eax, [di + 16]          ; eax = record
    cmp eax, 3                  ; if (eax == 3)
    jne .15E                    ; (eax != 3)

    mov eax, [di + 0]           ; eax = base addr.
    mov [ACPI_DATA.adr], eax    ; saving base addr.
    mov eax, [di + 8]           ; eax = addr length.
    mov [ACPI_DATA.len], eax    ; saving addr length.
.15E:
    cmp ebx, 0                  ; ebx
    jz .16E                     ; (ebx == 0)

    inc bp                      ; lines++
    and bp, 0x07                ; lines &= 0x07
    jnz .16E                    ; (ebx != 0)

    cdecl putc, .s2

    mov ah, 0x10                ; waiting for input key
    int 0x16                    ; AL = BIOS(0x16, 0x10)

    cdecl putc, .s3             ; delete cancel message.
.16E:
    cmp ebx, 0
    jne .10L                    ; (ebx != 0)
.10E:                           ; while(0 == EBX)
    cdecl putc, .s1

    pop bp
    pop di
    pop si
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret
.s0:	db " E820 Memory Map:", 0x0A, 0x0D
        db " Base_____________ Length___________ Type____", 0x0A, 0x0D, 0
.s1:	db " ----------------- ----------------- --------", 0x0A, 0x0D, 0
.s2:	db " <more...>", 0
.s3:	db 0x0D, "          ", 0x0D, 0

ALIGN 4, db 0
.b0:	times E820_RECORD_SIZE db 0

put_memory_info:
    ;----------------------
    ; [Create Stack Frame]
    ;----------------------
    push bp
    mov  bp, sp

    push bx
    push si

    ;-----------------
    ; [Get Arguments]
    ;-----------------
    mov si, [bp + 4]

    ;-------------------
    ; [Show Memory map]
    ;-------------------

    ; Base(64bit)
    cdecl itoa, word[si + 6], .p2 + 0, 4, 16, 0b0100
    cdecl itoa, word[si + 4], .p2 + 4, 4, 16, 0b0100
    cdecl itoa, word[si + 2], .p3 + 0, 4, 16, 0b0100
    cdecl itoa, word[si + 0], .p3 + 4, 4, 16, 0b0100

    ; Length(64bit)
    cdecl itoa, word[si + 14], .p4 + 0, 4, 16, 0b0100
    cdecl itoa, word[si + 12], .p4 + 4, 4, 16, 0b0100
    cdecl itoa, word[si + 10], .p5 + 0, 4, 16, 0b0100
    cdecl itoa, word[si + 8],  .p5 + 4, 4, 16, 0b0100

    ; Type(32bit)
    cdecl itoa, word[si + 18], .p6 + 0, 4, 16, 0b0100
    cdecl itoa, word[si + 16], .p6 + 4, 4, 16, 0b0100

    cdecl putc, .s1

    mov bx, [si + 16]
    and bx, 0x07
    shl bx, 1
    add bx, .t0
    cdecl putc, word[bx]

    pop si
    pop bx

    mov sp, bp
    pop bp

    ret

.s1:	db " "
.p2:	db "ZZZZZZZZ_"
.p3:	db "ZZZZZZZZ "
.p4:	db "ZZZZZZZZ_"
.p5:	db "ZZZZZZZZ "
.p6:	db "ZZZZZZZZ", 0

.s4:	db " (Unknown)", 0x0A, 0x0D, 0
.s5:	db " (usable)", 0x0A, 0x0D, 0
.s6:	db " (reserved)", 0x0A, 0x0D, 0
.s7:	db " (ACPI data)", 0x0A, 0x0D, 0
.s8:	db " (ACPI NVS)", 0x0A, 0x0D, 0
.s9:	db " (bad memory)", 0x0A, 0x0D, 0

.t0:	dw .s4, .s5, .s6, .s7, .s8, .s9, .s4, .s4
