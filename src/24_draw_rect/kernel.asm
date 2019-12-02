%include "../include/define.asm"
%include "../include/macro.asm"

    ORG KERNEL_LOAD              ; kernel load address

;Instruct the assembler to 32bit
[BITS 32]
;****************************
; Entry Point
;****************************
kernel:
    ;****************
    ; Get Font Addr
    ;****************

    mov   esi, BOOT_LOAD + SECT_SIZE ; esi = 0x7C00 + 512
    movzx eax, word[esi + 0]         ; eax = [esi + 0] // segment
    movzx ebx, word[esi + 2]         ; ebx = [esi + 2] // offset

    shl   eax, 4               ; eax << 4 // left bit shift
    add   eax, ebx             ; eax += ebx
    mov   [FONT_ADDR], eax     ; [FONT]0 = eax


    ; show the font list
    cdecl draw_font, 63, 13     ; show the font list
    cdecl draw_color_bar, 63, 4 ; show the color bar

    ; show the char
    cdecl draw_str, 25, 14, 0x010F, .s0 ; draw_str()

    ; drawing rect
    cdecl draw_rect, 100, 100, 200, 200, 0x03
    cdecl draw_rect, 400, 250, 150, 150, 0x05
    cdecl draw_rect, 350, 400, 300, 100, 0x06

    jmp $

.s0: db "Hello, Kernel!", 0

ALIGN 4, db 0
FONT_ADDR: dd 0

;****************************
; Modules
;****************************
%include "../modules/protect/vga.asm"
%include "../modules/protect/draw_char.asm"
%include "../modules/protect/draw_fonts.asm"
%include "../modules/protect/draw_str.asm"
%include "../modules/protect/draw_color_bar.asm"
%include "../modules/protect/draw_pixel.asm"
%include "../modules/protect/draw_line.asm"
%include "../modules/protect/draw_rect.asm"

;****************************
; Padding
;****************************
times KERNEL_SIZE - ($ - $$) db 0
