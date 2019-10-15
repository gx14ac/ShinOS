BOOT_LOAD equ 0x7c00            ; load to start boot program position.

ORG BOOT_LOAD                   ; instruction load addres to assembler.

entry:
    jmp ipl
    times 90 - ($ - $$) db 0x90

ipl:
    cli                         ; disable interrupt.
    
    mov ax, 0x0000              ; ax=0x0000
    mov ds, ax                  ; ds=0x0000
    mov es, ax                  ; es=0x0000
    mov ss, ax                  ; ss=0x0000
    mov sp, BOOT_LOAD           ; sp=0x7c00

    sti                         ; enable interrupt.

    mov [BOOT.DRIVE], dl        ; Saving BootDrive.

    mov al, 'A'                 ; al = A;
    mov ah, 0x0E                ; teletype
    mov bx, 0x0000              ; set page number & text color.

    int 0x10                    ; call BIOS Video.

    jmp $

ALIGN 2, db 0
BOOT:                           ; infomation BootDrive.
.DRIVE  dw 0                    ; drive number.

    times 510 - ($ - $$) db 0x00
    db 0x55, 0xAA