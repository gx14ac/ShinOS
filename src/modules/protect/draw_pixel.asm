;**********************************************
; drawing pixel
;**********************************************
; ** format void draw_pixel(X, Y, color)
;
; ** arg
;        X        : X Position
;        Y        : Y Position
;        position : drawing color
; ** return value : nothing
;**********************************************
draw_pixel:

    push ebp
    mov  ebp, esp

    push eax
    push ebx
    push ecx
    push edi

    ;************************************
    ; Multiply Y coordinate by 80
    ;************************************
    mov edi, [ebp + 12]
    shl edi, 4
    lea edi, [edi * 4 + edi + 0xA_0000]

    ;************************************
    ; Add X coordinate 1/8
    ;************************************
    mov ebx, [ebp + 8]
    mov ecx, ebx
    shr ebx, 3
    add edi, ebx

    ;**************************************************************************
    ; Calculate bit position from remainder of X coordinate divided by 8
    ;**************************************************************************
    and ecx, 0x07
    mov ebx, 0x08
    shr ebx, cl

    ;******************************
    ; Select color
    ;******************************
    mov ecx, [ebp + 16]

    ;******************************
    ; Output per plane
    ;******************************
    cdecl vga_set_read_plane, 0x03
    cdecl vga_set_write_plane, 0x08
    cdecl vram_bit_copy, ebx, edi, 0x08, ecx

    cdecl vga_set_read_plane, 0x02
    cdecl vga_set_write_plane, 0x04
    cdecl vram_bit_copy, ebx, edi, 0x04, ecx

    cdecl vga_set_read_plane, 0x01
    cdecl vga_set_write_plane, 0x02
    cdecl vram_bit_copy, ebx, edi, 0x02, ecx

    cdecl vga_set_read_plane, 0x00
    cdecl vga_set_write_plane, 0x01
    cdecl vram_bit_copy, ebx, edi, 0x01, ecx

    pop edi
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret
