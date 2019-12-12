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
    shl   eax, 4                     ; eax << 4 // left bit shift
    add   eax, ebx                   ; eax += ebx
    mov   [FONT_ADDR], eax           ; FONT_ADDR[0] = eax

    ;******************************
    ; configure tss descriptor
    ;******************************
    set_desc GDT.tss_0, TSS_0   ; conf tss for task0
    set_desc GDT.tss_1, TSS_1   ; conf tss for task1

    ;***********************************************
    ; configure LDT
    ;***********************************************
    ; descriptor addr   : ldt descriptor addr
    ; base addr         : ldt base addr
    ; descriptor limit  : limit
    ;***********************************************
    set_desc GDT.ldt, LDT, word LDT_LIMIT

    ;********************
    ; load GDT(reconf)
    ;********************
    lgdt [GDTR]                 ; reload global descriptor table

    ;********************
    ; conf stack
    ;********************
    mov esp, SP_TASK_0          ; set up a stack for task 0

    ;****************************
    ; initialize task register
    ;****************************
    mov ax, SS_TASK_0
    ltr ax

    ;*******************************
    ; initialize
    ;*******************************
    cdecl    init_int              ; initialize interrupt vector
    cdecl    init_pic              ; initialize interrupt controller

    ;************************************************************
    ;                         PIC Map
    ;************************************************************

    ;****************************
    ; master pic
    ;****************************
    ;outp 0x20, 0x11             ; MASTER.ICW1 = 0x11
    ;outp 0x21, 0x20             ; MASTER.ICW2 = 0x20
    ;outp 0x21, 0x04             ; MASTER.ICW3 = 0x04
    ;outp 0x21, 0x05             ; MASTER.ICW4 = 0x05
    ;outp 0x21, 0xFF             ; interrupt master mask

    ;****************************
    ; slave pic
    ;****************************
    ;outp 0xA0, 0x11             ; SLAVE.ICW1 = 0x11
    ;outp 0xA1, 0x28             ; SLAVE.ICW2 = 0x28 // rtc
    ;outp 0xA1, 0x02             ; SLAVE.ICW3 = 0x02
    ;outp 0xA1, 0x01             ; SLAVE.ICW4 = 0x01
    ;outp 0xA1, 0xFF             ; interrupt slave mask

    set_vect 0x00, int_zero_div    ; register interrupt process : zero divide
    set_vect 0x20, int_timer       ; register interrupt process : timer // master pic IRQ0
    set_vect 0x21, int_keyboard    ; register interrupt process : kbc   // default IRQ
    set_vect 0x28, int_rtc         ; register interrupt process : rtc   // slave pic IRQ0

    ; interrupt enable device setting
    cdecl rtc_int_en, 0x10

    ;***********************************************
    ; configuration IMR(interrupt mask register)
    ;***********************************************
    outp 0x21, 0b_1111_1000      ; enable interrupt : pic/kbc/timer
    outp 0xA1, 0b_1111_1110      ; enalbe interrupt : rtc

    ;***********************************************
    ; interrupt enable cpu
    ;***********************************************
    sti

    ; show the font list
    cdecl draw_font, 63, 13     ; show the font list
    cdecl draw_color_bar, 63, 4 ; show the color bar

    ; show the char
    cdecl draw_str, 25, 14, 0x010F, .s0 ; draw_str()

.10L:
    ; show the clock
    mov   eax, [RTC_TIME]               ; get the oclock
    cdecl draw_time, 72, 0, 0x0700, eax ; show the oclock

    ; display the rotation bar
    cdecl draw_rotation_bar

    ; get the keycode
    cdecl ring_rd, _KEY_BUFF, .int_key ; eax = ring_rd(buff, &int_key)
    cmp   eax, 0                       ; if (eax == 0)
    je    .10E

    ; display the keycode
    cdecl draw_key, 2, 29, _KEY_BUFF

.10E:
    jmp .10L

.s0: db "Hi, MR.ROBOT", 0

ALIGN 4, db 0
.int_key:	dd	0

ALIGN 4, db 0
FONT_ADDR:	dd	0
RTC_TIME:	dd	0

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
%include "../modules/protect/interrupt.asm"
%include "../modules/protect/int_rtc.asm"
%include "../modules/protect/pic.asm"
%include "../modules/protect/int_keyboard.asm"
%include "../modules/protect/ring_buff.asm"

%include "../modules/protect/draw_rotation_bar.asm"
%include "../modules/protect/timer.asm"
%include "modules/int_timer.asm"

;****************************
; Padding
;****************************
times KERNEL_SIZE - ($ - $$) db 0x00
