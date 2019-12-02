;***********************************
; drawing rect
;***********************************
; ** format void draw_rect
; ** arg
;        X0    : start X position
;        Y0    : start Y position
;        X1    : end X position
;        Y1    : end Y position
;        color : drawing color
; ** return value : nothing
;***********************************
draw_rect:

    ; ebp + 8  | X0
    ; ebp + 12 | Y0
    ; ebp + 16 | X1
    ; ebp + 20 | Y2
    push ebp
    mov  ebp, esp

    push eax
    push ebx
    push ecx
    push edx
    push esi

    ;*****************************
    ; drawing rect
    ;*****************************
    mov eax, [ebp + 8]          ; eax = X0
    mov ebx, [ebp + 12]         ; ebx = Y0
    mov ecx, [ebp + 16]         ; ecx = X1
    mov edx, [ebp + 20]         ; edx = Y1
    mov esi, [ebp + 24]         ; esi = color

    ;*********************************************
    ; Determine the size of the coordinate axis
    ;*********************************************
    cmp  eax, ecx               ; if (X1 < X0)
    jl   .10E                   ; {
    xchg eax, ecx               ;   Swap X0 and X1
.10E:                           ; }
    cmp  ebx, edx
    jl   .20E
    xchg ebx, edx
.20E:
    ;****************
    ; drawing rect
    ;****************
    cdecl draw_line, eax, ebx, ecx, ebx, esi ; over line
    cdecl draw_line, eax, ebx, eax, edx, esi ; left side line

    dec edx                     ; edx--
    cdecl draw_line, eax, edx, ecx, edx, esi ; under line
    inc edx

    dec ecx                     ; ecx--
    cdecl draw_line, ecx, ebx, ecx, edx, esi ; right side line

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret
