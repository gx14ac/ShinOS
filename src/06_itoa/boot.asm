;---------------------
; - Configration Start to Boot Program Address.
;---------------------
BOOT_LOAD equ 0x7c00    ; load to start boot program address.
ORG       BOOT_LOAD     ; instruction load address to assembler.

;---------------------
; - Declaration Macro.
;---------------------
%include "../include/macro.asm"

entry:
    ;---------------------
    ; - BPB(BIOS Parameter Block).
    ; - First calling to ipl label.
    ; - BIOS Needs Information.
    ; - 0x90 set to 90bytes.
    ; - NOP(do no something).
    ;---------------------
    jmp ipl
    times 90 - ($ - $$) db 0x90

ipl:
    cli                 ; disable interrupt.

    ;------------------
    ; - Configuration Segment Register.
    ; - Segment is separate memory blocks.
    ; - Initialize Register.
    ;-------------------
    mov ax, 0x0000      ; AX = 0x0000;

    mov ds, ax          ; DS = 0x0000;
    mov es, ax          ; ES = 0x0000;
    mov ss, ax          ; SS = 0x0000;

    ;---------------------
    ; - Stack the boot program start position on the stack pointer.
    ;---------------------
    mov sp, BOOT_LOAD    ; SP = 0x7c00;

    sti                 ; enable interrupt.

    ;---------------------
    ; - Saving Boot Drive.
    ; - dl register is I/O register.
    ;---------------------
    mov [BOOT.DRIVE], dl

    ;--------------------
    ; - Call putc function, argument is '.s0'.
    ;--------------------
    cdecl putc, .s0

    ;--------------------
    ; - Call itoa function, argument is '.s0'.
    ;--------------------
    ; cdecl itoa, 8086, .s1, 8, 10, 0b0001; "8086"
    ; cdecl putc, .s1

cdecl	itoa,  8086, .s1, 8, 10, 0b0001	; "    8086"
cdecl	putc, .s1
cdecl	itoa,  8086, .s1, 8, 10, 0b0011	; "+   8086"
cdecl	putc, .s1
cdecl	itoa, -8086, .s1, 8, 10, 0b0001	; "-   8086"
cdecl	putc, .s1
cdecl	itoa,    -1, .s1, 8, 10, 0b0001	; "-      1"
cdecl	putc, .s1
cdecl	itoa,    -1, .s1, 8, 10, 0b0000	; "   65535"
cdecl	putc, .s1
cdecl	itoa,    -1, .s1, 8, 16, 0b0000	; "    FFFF"
cdecl	putc, .s1
cdecl	itoa,    12, .s1, 8,  2, 0b0100	; "00001100"
cdecl	putc, .s1

    ;--------------------
    ; - Terminate imp Proccess;
    ;--------------------
    jmp $               ; Infinite loop.

;--------------------
; - 0x0A is LF(Line Feed).
; - 0x0D is CR(Caridge Return).
;--------------------
.s0 db "Booting...", 0x0A, 0x0D, 0
.s1 db "--------",   0x0A, 0x0D, 0

;--------------------
; - Place every 2 bytes.
;--------------------
ALIGN 2, db 0
BOOT:
.DRIVE  dw 0            ; drive number.

;--------------------
; - Declaration Module.
;--------------------
%include "../modules/real_mode/putc.asm"
%include "../modules/real_mode/itoa.asm"

;--------------------
; - Boot Flag.
; - Maybe Reserve the first 512 bytes.
; - Write 0x55 and 0xAA to 510bytes.
;--------------------
times 510 - ($ - $$) db 0x00
db 0x55, 0xAA
