;************************************************
; transform numeric to character
;************************************************
; ** format : void itoa(num, buff, size, radix, flags)
; ** arg
;        num   : transform num
;        buff  : destination buffer addr
;        size  : destination buffer size
;        radix : base radix(2, 8, 10 or 16)
;        flags :
;              : B2 : 1 = fill with zeros for blank
;              :      0 = fill with ` `(space) for blank
;              : B1 : 1 = show the sign(+/-)
;              :      0 = not show the sign(+/-)
;              : B0 : 1 = signed int
;              :      0 = unsigned int
; ** return value : nothing
;************************************************
itoa:
    ; ebp + 24 | flags
    ; ebp + 20 | radix
    ; ebp + 16 | buffer size
    ; ebp + 12 | buffer addr
    ; ebp + 8  | num
    ; ebp + 4  | eip(return addr)
    ; ebp + 0  | ebp(basee addr)

    push ebp
    mov  ebp, esp

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ;*********************
    ; get args
    ;*********************
    mov eax, [ebp + 8]          ; eax = num
    mov esi, [ebp + 12]         ; esi = buffer addr
    mov ecx. [ebp + 16]         ; ecx = buffer size

    mov edi, esi                ; edi = last buffer addr
    add edi, ecx                ; edi += ecx
    dec edi                     ; edi-- // edi = ecx[size -1]
    mov ebx, [ebp + 24]         ; ebx = flags

    ;******************************************************
    ; judgement signed
    ; *****************************************************
    ; flag == 0x01 && eax < 0 { ebx = 2 // signed }
    ;******************************************************
    test ebx, 0b0001            ; if (flags & 0x01) // signed
.10Q:
    je .10E                     ; {
    cmp eax, 0                  ; if (eax < 0)
.12Q:
    jge .12E                    ; {
    or  ebx, 0b0010             ; flags |= 2 // show the signed
.12E:
.10E:
    ;******************************************************
    ; judgement output signed
    ;******************************************************
    test ebx, 0b0010            ; if(flags & 0x02)
.20Q:
    je  .20E                    ; {
    cmp eax, 0                  ; if (eax < 0)
.22Q:
    jge .22F                    ; {
    neg eax                     ; eax *= -1 // sign inversion
    mov [esi], byte '-'         ; *esi = '-' // display sign
    jmp .22E                    ; }
.22F:                           ; else {
    mov [esi], byte '+'         ; esi = '+'
.22E:                           ; }
    dec ecx                     ; size--
.20E:                           ; }
    ;******************************************************
    ; transform ascii
    ;******************************************************
    mov ebx, [ebp + 20]         ; ebx = radix
.30L:
    mov edx, 0
    div ebx                     ; edx = edx:eax % base
                                ; eax = edx:eax / base
    mov esi, edx                ; esi = edx
    mov dl, byte[.ascii + esi]  ; dl = ascii[dx] // reference table

    mov [edi], dl               ; *edi = dl
    dec edi                     ; edi--

    cmp     eax, 0              ;
    loopnz .30L                 ; while(eax)
.30E:

    ;***************************
    ; fill the space
    ;***************************
    cmp ecx, 0                  ; if (size)
.40Q:
    je .40E                     ; {
    mov al, ' '                 ; al = ' '
    cmp [ebp + 24], word 0b0100 ; if (flags & 0x04)
.42Q:
    jne .42E                    ; {
    mov al, '0'                 ; al = '0'
.42E:                           ; }
    std                         ; df = 1
    rep stosb                   ; while (--cx) *di-- = ' '
.40E:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret

.ascii db "0123456789ABCDEF"    ; transform table
