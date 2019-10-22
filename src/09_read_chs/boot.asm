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

stage_2:
        ;---------------------
        ; - Second Stage.
        ;---------------------
        cdecl putc, .s0

        jmp $

.s0 db "2nd stage...", 0x0A, 0x0D, 0

    ;---------------------
    ; - Padding.
    ;---------------------

    times BOOT_SIZE - ($ - $$) db -0
