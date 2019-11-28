;************************************************************************
; First Sector to BIOS
;************************************************************************

;************************************************************************
; Macro
;************************************************************************
%include "../include/define.asm"
%include "../include/macro.asm"

ORG BOOT_LOAD               ; Configuration Load Address.

;****************************
; Entry Point
;****************************
entry:
    ;****************************
    ; BPB(BIOS Parameter Block)
    ;****************************
    jmp ipl
    times 90 - ($ - $$) db 0x90

;********************************
; IPL(Initial Program Loader)
;********************************
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

    ;************************************
    ; Import all remaining sectors
    ;************************************
    mov bx, BOOT_SECT - 1         ; Remaing Boot Sector.
    mov cx, BOOT_LOAD + SECT_SIZE ; Next Loading Address.

    cdecl read_chs, BOOT, bx, cx  ; AX - read_chs(.chs, bx, cx)

    cmp ax, bx
.10Q: jz    .10E
.10T: cdecl putc, .e0
      call  reboot
.10E:
    ;************************************
    ; Jump to NextStage
    ;************************************
    jmp stage_2

;************************************
; Declaration Data
;************************************
.s0 db "Booting...", 0x0A, 0x0D, 0
.e0 db "Error sector read", 0

;************************************
; Boot Drive Information
;************************************
ALIGN 2, db 0
BOOT:
    istruc drive
        at drive.no,    dw 0
        at drive.cyln,  dw 0
        at drive.head,  dw 0
        at drive.sect,  dw 2
    iend

;*********************
; Modules
;*********************
%include "../modules/real_mode/putc.asm"
%include "../modules/real_mode/reboot.asm"
%include "../modules/real_mode/read_chs.asm"

;******************************
; Boot Flag
; terminate to first 512bytes
;******************************
  times 510 - ($ - $$) db 0x00
  db 0x55, 0xAA

;******************************
; This Inforamation when get read mode
;******************************
FONT:
.seg:       dw 0
.off:       dw 0
ACPI_DATA:                      ; ACPI data
.adr:       dd 0                ; ACPI data addr
.len:       dd 0                ; ACPI data length

 ;*********************
 ; Modules
 ;*********************
 %include "../modules/real_mode/itoa.asm"
 %include "../modules/real_mode/get_drive_param.asm"
 %include "../modules/real_mode/get_fonts_addr.asm"
 %include "../modules/real_mode/get_memory_info.asm"
 %include "../modules/real_mode/kbc.asm"
 %include "../modules/real_mode/lba_chs.asm"
 %include "../modules/real_mode/read_lba.asm"

stage_2:
      cdecl putc, .s0

      ;**************************
      ; Get drive information
      ;**************************
      cdecl get_drive_param, BOOT ; get_drive_param(DX, BOOT.CYLN).
      cmp   ax, 0
.10Q: jne .10E
.10T: cdecl putc, .e0
      call reboot
.10E:
    ;*************************
    ; Show drive information
    ;*************************
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

;*************************
; Declaration Data
;*************************

.s0		db	"2nd stage...", 0x0A, 0x0D, 0

.s1		db	" Drive:0x"
.p1		db	"  , C:0x"
.p2		db	"    , H:0x"
.p3		db	"  , S:0x"
.p4		db	"  ", 0x0A, 0x0D, 0

.e0		db	"Can't get drive parameter.", 0

stage_3:
    cdecl putc, .s0

    ;******************************************
    ; In protected mode, use the built-in BIOS
    ;******************************************
    cdecl get_font_addr, FONT

    cdecl itoa, word[FONT.seg], .p1, 4, 16, 0b0100
    cdecl itoa, word[FONT.off], .p2, 4, 16, 0b0100
    cdecl putc, .s1

    ;****************************************************
    ; Get Memory Information & Show Memory Inforamation
    ;****************************************************
    cdecl get_memory_info       ; get_memory_info()

    mov eax, [ACPI_DATA.adr]    ; eax = ACPI.DATA.ad
    cmp eax, 0
    je .10E

    cdecl itoa, ax, .p4, 4, 16, 0b0100
    shr   eax, 16
    cdecl itoa, ax, .p3, 4, 16, 0b0100
    cdecl putc, .s2
.10E:

    jmp stage_4

.s0: db "3rd stage...", 0x0A, 0x0D, 0

.s1: db " Font Address="
.p1: db "ZZZZ:"
.p2: db "ZZZZ", 0x0A, 0x0D, 0
     db 0x0A, 0x0D, 0

.s2: db " ACPI data="
.p3: db "ZZZZ"
.p4: db "ZZZZ", 0x0A, 0x0D, 0

stage_4:
    cdecl putc, .s0

    ;*****************************
    ; Enable A20 Gate
    ;*****************************

    cli                           ; don't allow interrupt
    cdecl write_kbc_command, 0xAD ; invalid keyboard
    cdecl write_kbc_command, 0xD0 ; output port read command
    cdecl read_kbc_data,     .key ; output port data

    mov bl, [.key]                ; bl = key
    or  bl, 0x02                  ;

    cdecl write_kbc_command, 0xD1 ; output port read command
    cdecl write_kbc_data,    bx   ; output port data

    cdecl write_kbc_command, 0xAE ; allow interrupt

    sti

    cdecl   putc, .s1

    cdecl   putc, .s2

    mov bx, 0

.10L:
    mov ah, 0x00                ; waiting for input keyboard value
    int 0x16                    ; AL(0x16, 0x00) calling keyboard service for bios

    ; al register = ascii code(value converted from ASCII input from keyboard)
    cmp al, '1'                 ; if(al < '1')
    jb .10E                     ; break

    cmp al, '3'                 ; if ('3'< al)
    ja .10E                     ; break

    mov cl, al                  ; cl = input Keyboard Value
    dec cl                      ; cl -=1
    and cl, 0x03                ; cl &= 0x03.  only allow the 0-2
    mov ax, 0x0001              ; ax = 0x0001. tranform bit
    shl ax, cl                  ; ax <<= cl.   0-2 left bit shift
    xor bx, ax                  ; bx ^= ax.    inversion bit

    ;*******************
    ; send led command
    ;*******************

    cli                                ; don't allow interrupt

    cdecl write_kbc_command, 0xAD      ; invalid keyboard

    cdecl write_kbc_data,    0xED      ; send LED Command
    cdecl read_kbc_data,     .key      ; receive response

    cmp   [.key],            byte 0xFA ; if (0xFA == key)
    jne   .11F

    cdecl write_kbc_data,    bx        ;

    jmp .11E                           ; else

.11F:
    ; show the recieve code
    cdecl itoa, word[.key], .e1, 2, 16, 0b0100
    cdecl putc, .e0
.11E:
    cdecl write_kbc_command, 0xAE ; allow keyboard

    sti                           ; allow interupt

    jmp .10L

.10E:
    cdecl putc, .s3

    ; terminating process
    jmp   stage_5

.s0:  db "4th stage...", 0x0A, 0x0D, 0
.s1:  db " A20 Gate Enabled", 0x0A, 0x0D, 0
.s2:  db " Keyboard LED Test...", 0
.s3:  db " (done)", 0x0A, 0x0D, 0
.e0:  db "["
.e1   db "ZZ]", 0

.key: dw 0

stage_5:
    cdecl putc, .s0

    ; Loading Kernel
    cdecl read_lba, BOOT, BOOT_SECT, KERNEL_SECT, BOOT_END ; ax = read_lba(...)

    cmp   ax, KERNEL_SECT       ; if (ax != cx)
.10Q:    jz    .10E             ; {
.10T:    cdecl putc, .e0        ;
    call  reboot                ; reboot
.10E:                           ; }
    jmp  $

.s0 db "5th stage...", 0x0A, 0x0D, 0
.e0 db "Failure load kernel...", 0x0A, 0x0D, 0

;*******************************
; Padding
;*******************************
times BOOT_SIZE - ($ - $$) db 0
