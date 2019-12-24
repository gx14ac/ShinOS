;; Boot Information
CYLS    EQU     0x0ff0      ; Config Boot Sector
LEDS    EQU     0x0ff1
VMODE   EQU     0x0ff2      ; Bit Color
SCRNX   EQU     0x0ff4      ; Resolution X
SCRNY   EQU     0x0ff6      ; Resolution Y
VRAM    EQU     0x0ff8      ; Start graphic buffer address

        ORG     0xc200              ; 0xc200 <- 0x8000 + 0x4200

        MOV     AL, 0x13            ; VGA Graphics, 320*200*8bit
        MOV     AH, 0x00            ; must config '0x00'
        INT     0x10

        MOV     BYTE [VMODE], 8
        MOV     WORD [SCRNX], 320
        MOV     WORD [SCRNY], 200
        MOV     DWORD [VRAM], 0x000a0000

        MOV     AH, 0x02
        INT     0x16                ; keyboard BIOS
        MOV     [LEDS], AL

fin:
    HLT
    JMP     fin
