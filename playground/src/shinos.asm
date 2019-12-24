    ORG     0xc200              ; 0xc200 <- 0x8000 + 0x4200

    MOV     AL, 0x13            ; VGA Graphics, 320*200*8bit
    MOV     AH, 0x00            ; must config '0x00'
    INT     0x10

fin:
    HLT
    JMP     fin
