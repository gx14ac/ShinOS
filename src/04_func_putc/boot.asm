;;; Configuration Boot Program.
BOOT_LOAD equ 0x7c00 ; load to start boot program address.

ORG BOOT_LOAD         ; instruction load address to assembler.

%include "../include/macro.asm"

;;; Entry Point.
entry:

    ; BPB(BIOS Parameter Block)
    jmp ipl
    times 90 - ($ - $$) db 0x90

;;; IPL(Initial Program Loader)
ipl:
    cli                  ; disable interrupt.
    
    mov ax, 0x0000       ; AX = 0x0000;
    mov ds, ax           ; DS = 0x0000;
    mov es, ax           ; ES = 0x0000;
    mov ss, ax           ; SS = 0x0000;
    mov sp, BOOT_LOAD    ; SP = 0x7c00;

    sti                  ; enable interrupt.

    mov [BOOT.DRIVE], dl ; saving Boot Drive. 

    cdecl putc, word'H'
    cdecl putc, word'E'
    cdecl putc, word'L'
    cdecl putc, word'L'
    cdecl putc, word'O'
    cdecl putc, word'_'
    cdecl putc, word'W'
    cdecl putc, word'O'
    cdecl putc, word'R'
    cdecl putc, word'L'
    cdecl putc, word'D'
    
    ; Terminate imp Proccess;
    jmp $ ; infinite loop.

ALIGN 2, db 0
BOOT:           ; boot info.
.DRIVE  dw 0    ; drive number.

%include "../modules/real_mode/putc.asm"

;;; Boot Flag.
times 510 - ($ - $$) db 0x00
db 0x55, 0xAA