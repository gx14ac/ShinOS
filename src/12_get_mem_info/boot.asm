%include "../include/define.asm"
%include "../include/macro.asm"

ORG BOOT_LOAD               ; Configuration Load Address.

entry:
    jmp ipl
    times 90 - ($ - $$) db 0x90

    ;---------------------
    ; - IPL(Initiali Loading Program).
    ;---------------------
ipl:
    cli                         ; don't allow interrupt.
    mov ax, 0x0000              ; AX = 0x0000;

    mov ds, ax                  ; ds = ax.
    mov es, ax                  ; es = ax.
    mov ss, ax                  ; ss = ax.
    mov sp, BOOT_LOAD           ; sp = BOOT_:LOAD

    sti                         ; allow interupt.

    mov [BOOT + drive.no], dl   ; Saving Boot Drive.

    cdecl putc, .s0


    ;---------------------
    ; - Import all remaining sectors.
    ;---------------------

    mov bx, BOOT_SECT - 1         ; Remaing Boot Sector.
    mov cx, BOOT_LOAD + SECT_SIZE ; Next Loading Address.

    cdecl read_chs, BOOT, bx, cx  ; AX - read_chs(.chs, bx, cx)

    cmp ax, bx

.10Q: jz .10E
.10T: cdecl putc, .e0
    call reboot
.10E:
    jmp stage_2

.s0 db "Booting...", 0x0A, 0x0D, 0
.e0 db "Error sector read", 0

ALIGN 2, db 0

BOOT:
    istruc drive
    at drive.no,   dw 0
    at drive.cyln, dw 0
    at drive.head, dw 0
    at drive.sect, dw 2
    iend

;---------------------
; - Modules.
;---------------------
%include "../modules/real_mode/putc.asm"
%include "../modules/real_mode/reboot.asm"
%include "../modules/real_mode/read_chs.asm"

  ;---------------------
  ; - Boot Flag.
  ;---------------------
  times 510 - ($ - $$) db 0x00
  db 0x55, 0xAA

FONT:
.seg: dw 0
.off: dw 0

ACPI_DATA:                      ; ACPI data
.adr: dd 0                      ; ACPI data addr
.len: dd 0                      ; ACPI data length

 ;---------------------
 ; - Modules.
 ;---------------------
 %include "../modules/real_mode/itoa.asm"
 %include "../modules/real_mode/get_drive_param.asm"
 %include "../modules/real_mode/get_fonts_addr.asm"
 %include "../modules/real_mode/get_memory_info.asm"

stage_2:
 ;---------------------
 ; - Second Stage.
 ;---------------------
 cdecl putc, .s0

 ;---------------------
 ; - Get drive information.
 ;---------------------
 cdecl get_drive_param, BOOT ; get_drive_param(DX, BOOT.CYLN).
 cmp ax, 0
.10Q: jne .10E
.10T: cdecl putc, .e0
        call reboot
.10E:
  ;---------------------
  ; - Show drive information.
  ;---------------------
  mov   ax, [BOOT + drive.no]
  cdecl itoa, ax, .p1, 2, 16, 0b0100
  mov   ax, [BOOT + drive.cyln]
  cdecl itoa, ax, .p2, 4, 16, 0b0100
  mov   ax, [BOOT + drive.head]
  cdecl itoa, ax, .p3, 2, 16, 0b0100
  mov   ax, [BOOT + drive.sect]
  cdecl itoa, ax, .p4, 2, 16, 0b0100
  cdecl putc, .s1
  jmp stage_3

.s0 db "2nd stage...", 0x0A, 0x0D, 0

.s1 db "Drive:0x"
.p1 db " , C:0x"
.p2 db "   , H:0x"
.p3 db "  , S:0x"
.p4 db " ", 0x0A, 0x0D, 0

.e0 db "Can't get drive parameter.", 0

stage_3:
    cdecl putc, .s0
    cdecl get_font_addr, FONT

    cdecl itoa, word[FONT.seg], .p1, 4, 16, 0b0100
    cdecl itoa, word[FONT.off], .p2, 4, 16, 0b0100
    cdecl putc, .s1

    cdecl get_memory_info       ; get_memory_info()

    mov eax, [ACPI_DATA.adr]    ; eax = ACPI.DATA.ad
    cmp eax, 0
    je .10E

    cdecl itoa, ax, .p4, 4, 16, 0b0100
    shr eax, 16
    cdecl itoa, ax, .p3, 4, 16, 0b0100
    cdecl putc, .s2
.10E:

  jmp $

.s0: db "3rd stage...", 0x0A, 0x0D, 0
.s1: db "Font Address="
.p1: db "ZZZZ:"
.p2: db "ZZZZ", 0x0A, 0x0D, 0
    db 0x0A, 0x0D, 0

.s2: db " ACPI data="
.p3: db "ZZZZ"
.p4: db "ZZZZ", 0x0A, 0x0D, 0

times BOOT_SIZE - ($ - $$) db -0
