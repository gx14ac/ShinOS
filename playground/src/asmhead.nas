BOTPAK  EQU     0x00280000      ; BOOTPACK     | Bootpack loading destination
DSKCAC  EQU     0x00100000      ; DISK CACHE   | Disk Cache Place
DSKCAC0 EQU     0x00008000      ; DISK CAHCE 0 | Disk Cahce Place(real mode)

;; Boot Information
CYLS    EQU     0x0ff0      ; Config Boot Sector
LEDS    EQU     0x0ff1      ; LED State
VMODE   EQU     0x0ff2      ; Bit Color
SCRNX   EQU     0x0ff4      ; Resolution X
SCRNY   EQU     0x0ff6      ; Resolution Y
VRAM    EQU     0x0ff8      ; Start graphic buffer address

        ORG     0xc200              ; 0xc200 <- 0x8000 + 0x4200

        MOV     AL, 0x13            ; VGA Graphics, 320*200*8bit
        MOV     AH, 0x00            ; must config '0x00'
        INT     0x10

        MOV     BYTE [VMODE], 8          ; Video Mode
        MOV     WORD [SCRNX], 320        ; Screen X
        MOV     WORD [SCRNY], 200        ; Screnn Y
        MOV     DWORD [VRAM], 0x000a0000 ; VideoRAM
                                         ; VRAM Size is 0xa0000～0xaffff(64KB)

        ;********************************************************************************
        ; [INT(0x16) - Keyboard Info]
        ; GetKey Lock & Shift State
        ; AH = 0x02
        ; return : nothing
        ; AL == state code :
        ;       bit 0 : right shift
        ;       bit 1 : left shift
        ;       bit 2 : ctrl
        ;       bit 3 : alt
        ;       bit 4 : scroll lock
        ;       bit 5 : num lock
        ;       bit 6 : caps lock
        ;       bit 7 : insert mode
        ; Get From BIOS(16 bit mode)
        ;*********************************************************************************
        MOV     AH, 0x02
        INT     0x16                ; keyboard BIOS
        MOV     [LEDS], AL

        ;**************************************************
        ; Prevent PIC from accepting any interrupts
        ;**************************************************
        MOV     AL, 0xff
        OUT     0x21, AL
        NOP
        OUT     0xa1, AL

        ; Disable interrupt CPU Level
        CLI

        ; Set A20Gate, becasuse that CPU can access memory of 1MB or more
        CALL    waitkbdout
        MOV     AL, 0xd1
        OUT     0x64, AL
        CALL    waitkbdout
        MOV     AL, 0xdf        ; enable A20
        OUT     0x60, AL
        CALL    waitkbdout

        ; Move Protect Mode
[INSTRSET "i486p"]        
        LGDT    [GDTR0]         ; Configure GDT
        MOV     EAX, CR0
        AND     EAX, 0x7fffffff ; Set bit31 to 0
        OR      EAX, 0x00000001 ; Set bit0 to 1(To enter Protect Mode)
        MOV     CR0, EAX
        JMP     pipelineflush

pipelineflush:
    MOV     AX, 1*8             ; 32bit readable / writable segment
    MOV     DS, AX
    MOV     ES, AX
    MOV     FS, AX
    MOV     GS, AX
    MOV     SS, AX

    ; Transfer BootPack
    MOV     ESI, bootpack       ; Backwarding Destination
    MOV     EDI, BOTPAK         ; Fowarding Desination
    MOV     ECX, 512*1024/4
    CALL    memcpy

    MOV		ESI,0x7c00
	MOV		EDI,DSKCAC
	MOV		ECX,512/4
	CALL	memcpy

	MOV		ESI,DSKCAC0+512
    MOV		EDI,DSKCAC+512
    MOV		ECX,0
    MOV		CL,BYTE [CYLS]
    IMUL	ECX,512*18*2/4
    SUB		ECX,512/4
    CALL	memcpy

    ; Launching BootPack
    MOV     EBX, BOTPAK
    MOV     ECX, [EBX+16]
    ADD     ECX, 3
    SHR     ECX, 2
    JZ      skip                ; Nothing to Transfer
    MOV     ESI, [EBX+20]       ; Backwording Destination
    ADD     ESI, EBX
    MOV     EDI, [EBX+12]       ; Fowarding Destination
    CALL    memcpy

skip:
    MOV     ESP, [EBX+12]
    JMP     DWORD 2*8:0x0000001b

waitkbdout:
    IN      AL, 0x64
    AND     AL, 0x02
    JNZ     waitkbdout          ; if the result of AND is not 0, go to waitkbdout
    RET

memcpy:
    MOV     EAX, [ESI]
    ADD     ESI, 4
    MOV     [EDi], EAX
    ADD     EDI, 4
    SUB     ECX, 1
    JNZ     memcpy
    RET

    ALIGNB 16

GDT0:
    RESB    8                           ; Null Selector
    DW      0xffff,0x0000,0x9200,0x00cf ; Reeadable / Writable segment 32bit
    DW      0xffff,0x0000,0x9a28,0x0047 ; Executable segment 32bit（original bootpack）

    DW      0

GDTR0:
    DW  8*3-1
    DD  GDT0

    ALIGNB 16
bootpack: