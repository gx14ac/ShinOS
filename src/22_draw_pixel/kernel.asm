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

    ; output pixel
    cdecl	draw_pixel,  8, 4, 0x01
    cdecl	draw_pixel,  9, 5, 0x01
    cdecl	draw_pixel, 10, 6, 0x02
    cdecl	draw_pixel, 11, 7, 0x02
    cdecl	draw_pixel, 12, 8, 0x03
    cdecl	draw_pixel, 13, 9, 0x03
    cdecl	draw_pixel, 14,10, 0x04
    cdecl	draw_pixel, 15,11, 0x04

    cdecl	draw_pixel, 15, 4, 0x03
    cdecl	draw_pixel, 14, 5, 0x03
    cdecl	draw_pixel, 13, 6, 0x04
    cdecl	draw_pixel, 12, 7, 0x04
    cdecl	draw_pixel, 11, 8, 0x01
    cdecl	draw_pixel, 10, 9, 0x01
    cdecl	draw_pixel,  9,10, 0x02
    cdecl	draw_pixel,  8,11, 0x02

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
;****************************
; Padding
;****************************
times KERNEL_SIZE - ($ - $$) db 0
