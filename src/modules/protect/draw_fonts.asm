;**********************************************************
; show font list
;**********************************************************
; ** format : void draw_font(col, row)
; ** arg
;        col : column
;        row : line
; ** return value : nothing
;
;**********************************************************
draw_font:
    push ebp
    mov  ebp, esp

    push eax
    push ebx
    push ecx
    push edx
    push edi
    push esi

    ;********************
    ; display position
    ;********************
    mov esi, [ebp + 8]          ; esi = X
    mov edi, [ebp + 12]         ; edi = Y

    ;***********************
    ; show the font list
    ;***********************
    mov ecx, 0                  ; for (ecx = 0
.10L:
    cmp ecx, 256                ;      ecx < 256
    jae .10E                    ; ecx++)

    mov eax, ecx                ; eax = ecx
    and eax, 0x0F               ; eax &= 0x0F. fill upper 4 bits
    add eax, esi                ; eax += x

    mov ebx, ecx                ; ebx = ecx
    shr ebx, 4                  ; ebx /= 16. There is a line break every 16 characters
    add ebx, edi                ; ebx += y

    cdecl draw_char, eax, ebx, 0x07, ecx ; draw_char()

    inc ecx                     ; // ecx++
    jmp .10L
.10E:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret
