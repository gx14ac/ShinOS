;******************************************************************
; drawing street linen
;******************************************************************
; format : void draw_line(X0, Y0, X1, Y1, color)
; arg    :
;        X0    : start X position
;        Y0    : start Y position
;        X1    : end X position
;        Y1    : end Y position
;        color : drawing color
; return value : nothing
;******************************************************************
draw_line:

    ; ebp + 24 | drawing color
    ; ebp + 20 | Y1
    ; ebp + 16 | X1
    ; ebp + 12 | Y0
    ; ebp + 8  | X0
    push ebp
    mov  ebp, esp

    push dword 0                ; -4  | sum = 0
    push dword 0                ; -8  | x0 = 0
    push dword 0                ; -12 | dx = 0
    push dword 0                ; -16 | inc_x = 0
    push dword 0                ; -20 | x0 = 0
    push dword 0                ; -24 | dx = 0
    push dword 0                ; -28 | inc_x = 0

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ;****************************************
    ; calculate width(X Position)
    ;****************************************
    mov eax, [ebp + 8]
    mov ebx, [ebp + 16]
    sub ebx, eax
    jge .10F

    neg ebx
    mov esi, -1
    jmp .10E
.10F:
    mov esi, 1
.10E:
    ;****************************************
    ; calculate height(Y Position)
    ;****************************************
    mov ecx, [ebp + 12]
    mov edx, [ebp + 20]
    sub edx, ecx
    jge .20F

    neg edx
    mov edi, -1
    jmp .20E
.20F:
    mov edi, 1
.20E:
    ;****************************************
    ; X position
    ;****************************************
    mov [ebp - 8],  eax
    mov [ebp - 12], ebx
    mov [ebp - 16], esi

    ;****************************************
    ; Y position
    ;****************************************
    mov [ebp - 20], ecx
    mov [ebp - 24], edx
    mov [ebp - 28], edi

    ;**********************************
    ; Decide base position
    ;**********************************
    cmp ebx, edx
    jg  .22F

    lea esi, [ebp - 20]
    lea esi, [ebp - 8]

    jmp .22E
.22F:
    lea esi, [ebp - 8]
    lea edi, [ebp - 20]
.22E:
    mov ecx, [esi - 4]
    cmp ecx, 0
    jnz .30E
    mov ecx, 1
.30E:

.50L:
%ifdef USE_SYSTEM_CALL
    mov eax, ecx

    mov ebx, [ebp + 24]
    mov ecx, [ebp - 8]
    mov edx, [ebp - 20]
    int 0x82

    mov ecx, eax
%else
    cdecl draw_pixel, dword[ebp - 8], dword[ebp - 20], dword[ebp + 24]
%endif
    mov eax, [esi - 8]
    add [esi - 0], eax

    mov eax, [ebp - 4]
    add eax, [edi - 4]
    mov ebx, [esi - 4]

    cmp eax, ebx
    jl  .52E
    sub eax, ebx

    mov ebx, [edi - 8]
    add [edi - 0], ebx
.52E:
    mov [ebp - 4], eax
    loop .50L
.50E:

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret
