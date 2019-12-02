;***************************
; draw the char
;***************************
; ** fomat void draw_char(col, row, color, ch)
; ** arg
;      col   : column(0~79)
;      row   : row(0~29)
;      color : drawing color
;      ch    : character
; ** return value: nothing
;***************************
draw_char:

    ; ebp + 20 | character
    ; ebp + 16 | color
    ; ebp + 12 | (Y)
    ; ebp + 8  | (X)
    push ebp
    mov  ebp, esp

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ;****************************
    ; copy source font address
    ;****************************
    movzx esi, byte[ebp + 20]   ; cl = char code
    shl   esi, 4                ; cl *= 16
    add   esi, [FONT_ADDR]      ; esi = font addr

    ;*******************************************
    ; copy destination font address
    ; adr = 0xA00000 + (640 / 6 * 16) * y + x
    ;*******************************************
    mov edi, [ebp + 12]                ; Y
    shl edi, 8                         ; edi = y * 256
    lea edi, [edi * 4 + edi + 0xA0000] ; edi = y * 4 + Y
    add edi, [ebp + 8]                 ; X

    ;*******************************************
    ; Display font for one character
    ;*******************************************
    movzx ebx, word[ebp + 16]

    cdecl vga_set_read_plane,  0x03                  ; write plane = light
    cdecl vga_set_write_plane, 0x08                  ; read plane = light
    cdecl vram_font_copy,      esi, edi, 0x08, ebx

    cdecl vga_set_read_plane,  0x02                   ; read plane (Red)
    cdecl vga_set_write_plane, 0x04                   ; write plane (Red)
    cdecl vram_font_copy,      esi, edi, 0x04, ebx

    cdecl vga_set_read_plane,  0x01                   ; read plane (Green)
    cdecl vga_set_write_plane, 0x02                   ; write plane (Green)
    cdecl vram_font_copy,      esi, edi, 0x02, ebx

    cdecl vga_set_read_plane,  0x00                   ; read plane (Blue)
    cdecl vga_set_write_plane, 0x01                  ; write plane (Blue)
    cdecl vram_font_copy,      esi, edi, 0x01, ebx

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret
