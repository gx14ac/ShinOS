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

    ;*******************************
    ; initialize
    ;*******************************
    cdecl    init_int              ; initialize interrupt vector
    set_vect 0x00, int_zero_div    ; register interrupt process : zero divide

    ; show the font list
    cdecl draw_font, 63, 13     ; show the font list
    cdecl draw_color_bar, 63, 4 ; show the color bar

    ; show the char
    cdecl draw_str, 25, 14, 0x010F, .s0 ; draw_str()

    ;***********************************
    ; calling interrupt by zero divide
    ;***********************************
    mov al, 0
    div al

    ; show the clock
.10L:
    cdecl rtc_get_time, RTC_TIME
    cdecl draw_time, 72, 0, 0x0700, dword[RTC_TIME]
    jmp .10L

    jmp $

.s0: db "Hello, Kernel!", 0

ALIGN 4, db 0
FONT_ADDR: dd 0
RTC_TIME:  dd 0

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
%include "../modules/protect/itoa.asm"
%include "../modules/protect/rtc.asm"
%include "../modules/protect/draw_time.asm"
%include "modules/interrupt.asm"

;****************************
; Padding
;****************************
times KERNEL_SIZE - ($ - $$) db 0
