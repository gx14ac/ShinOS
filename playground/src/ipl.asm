    ;;**********************************
    ;; BPB(BIOS Parameter Block)
    ;;**********************************

    ;;******************************************************
    ;; 0x00007c00 = 0x00007dff : Read Boot Sector Address.
    ;; don't access address
    ;;******************************************************

    CYLS    EQU     10          ; Max read value(Cylinders)

            ORG     0x7c00      ; Initial Program Load Address

    ;; FAT 12 Format Floppy Disk
    JMP     entry
    DB      0x90                ; BS_jmpBoot

    DB      "SHINIPL"           ; BS_jmpBoot
    DW      512                 ; BPB_BytsPerSec // sector size
    DB      1                   ; BPB_SecPerClus // alocation unit size(minimum 1 byte).
    DW      1                   ; BPB_RsvdSecCnt // reserve sector count
    DB      2                   ; BPB_NumFATs    // FAt count
    DW      224                 ; BPB_RootEntCnt // Root Dir Count
    DW      2880                ; BPB_TotSec16   // All Volume Sector
    DB      0xf0                ; BPB_Media      // Media Type
    DW      9                   ; BPB_FATSz16    // 1 FAT Sector count
    DW      18                  ; BPB_SecPerTrk  // Track Sector Count
    DW      2                   ; BPB_NumHeads   // Head Count
    DD      0                   ; BPB_HiddSec    // Physics Sector
    DD      2880                ; BPB_TotSec     // New 32bit Fields

    ;; Setting fields starting from offset 36
    DB      0x00                ; BS_DrvNum
    DB      0x00                ; BS_Reserved1
    DB      0x29                ; BS_BootSig

    DD      0xffffffff          ; Volume Serial Number
    DB      "Shin-OS   "        ; DiskName
    DB      "FAT12   "          ; Format Name
    RESB    18                  ; For now, leave open 18byte

;; Reset Register Value
entry:
    MOV     AX, 0               ; initialize acumulator
    MOV     SS, AX              ; stack segment
    MOV     SP, 0x7c00          ; stack pointer
    MOV     DS, AX              ; data segment

    ;; load disk
    MOV     AX, 0x0820
    MOV     ES, AX              ; extra segment : buffer address 0x820
    MOV     CH, 0               ; counter high  : cylinder 0
    MOV     DH, 0               ; data high     : head 0
    MOV     CL, 2               ; counter low   : sector 2

read_loop:
    MOV     SI, 0               ; calc retry count

retry:
    ;;*********************************************
    ;; **0x13(BIOS System Call)
    ;; - http://stanislavs.org/helppc/int_13.html
    ;;**********************************************
    MOV     AH, 0x02            ; acumulator high : 0x02 - read disk
    MOV     AL, 1               ; acumulator low  : sector 1
    MOV     BX, 0               ; buffer address 0x0000

    MOV     DL, 0x00            ; data low
    INT     0x13                ; BIOS Call
    JNC     next                ; jump if not carry

    ADD     SI, 1               ; increment SI
    CMP     SI, 5
    JAE     error               ; SI >= 5

    MOV     AH, 0x00            ; 0x00. reset AH Register
    MOV     DL, 0x00            ; Reset DataLow
    INT     0x13                ; reset drive
    JMP     retry

next:
    ;; add 0x20 to ES
    ;; 0x0820 + (0x0020 * 18)
    MOV     AX, ES
    ADD     AX, 0x0020
    MOV     ES, AX

    ;; increment CL(sector number)
    ADD     CL, 1
    CMP     CL, 18
    JBE     read_loop           ; CL <= 18

    ;; Back side of disc
    MOV     CL, 1               ; reset sector
    ADD     DH, 1               ; reverse HEAD
    CMP     DH, 2
    JB      read_loop

    ;; next Cylinder
    mov     DH, 0               ; reset HEAD
    ADD     CH, 1               ; cylinder += 1
    CMP     CH, CYLS
    JB      read_loop
fin:
    HLT
    JMP     fin

error:
    MOV     SI, msg

putloop:
    MOV     AL, [SI]
    ADD     SI, 1
    CMP     AL, 0
    JE      fin

    MOV     AH, 0x0e
    MOV     BX, 15
    INT     0x10                ; interrupt BIOS
    JMP     putloop

msg:
    DB      0x0a, 0x0a
    DB      "LOAD ERROR"
    DB      0x0a
    DB      0

    ;;  0x7cc-0x7dfe fill with 0
    RESB    0x7dfe-0x7c00-($-$$)

    DB      0x55, 0xaa
