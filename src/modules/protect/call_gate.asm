;******************************************************************************************
; call intersegmnetal
; called by inter-segment call instruction, function code segment comes into ebp + 4
;******************************************************************************************
call_gate:
    ;*******************************************
    ; ebp + 12 | X         // first arg
    ; ebp + 16 | Y         // second arg
    ; ebp + 20 | color     // third arg
    ; ebp + 24 | character // forth arg
    ;*******************************************
    ; ebp + 8 | cs(code segment)
    ; ebp + 4 | return addr
    ; ebp + 0 | base value
    ;*******************************************
    push ebp
    mov ebp, esp

    pusha
    push ds
    push es

    ;***************************************
    ; configure designated data segment
    ;***************************************
    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    ;*****************
    ; show the char
    ;*****************
    mov eax, dword[ebp + 12]           ; eax = X
    mov ebx, dword[ebp + 16]           ; ebx = Y
    mov ecx. dword[ebp + 20]           ; ecx = color
    mov edx, dword[ebp + 24]           ; edx = char
    cdecl draw_str, eax, ebx, ecx, edx ; draw_str()

    pop es
    pop ds
    popa

    mov esp, ebp
    pop ebp

    retf 4 * 4
