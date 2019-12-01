;*****************************
; display of char
;*****************************
; ** format void draw_str(col, row, color, p)
; ** arg
;        col
;        row
;        color : drawing color
;        p : char addr
; ** return value : nothing
;*****************************
draw_str:

    ; ebp + 20 | *p(char addr)
    ; ebp + 16 | color
    ; ebp + 12 | row
    ; ebp + 8  | col

    push ebp
    mov  ebp, esp

    push eax
    push ebx
    push ecx
    push edx
    push esi

    mov   ecx, [ebp + 8]        ; ecx = col
    mov   edx, [ebp + 12]       ; edx = row
    movzx ebx, word[ebp + 16]   ; ebx = drawing color
    mov   esi, [ebp + 20]       ; esi = char addr

    cld
.10L:
    lodsb
    cmp al, 0
    je .10E
    cdecl draw_char, ecx, edx, ebx, eax

    inc ecx                     ; ecx++ // add col
    cmp ecx, 80                 ; if (80 <= ecx) // 80 characters or more ?
    jl  .12E                    ; {
    mov ecx, 0                  ; ecx = 0
    inc edx                     ; edx++
    cmp edx, 30                 ; if (30 <= edx)
    jl  .12E                    ; {
    mov edx, 0                  ; edx = 0
                                ; }
.12E:
    jmp .10L
.10E:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret
