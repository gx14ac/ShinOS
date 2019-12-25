section .text
    GLOBAL  io_hlt
    GLOBAL  write_mem8

io_hlt:
    HLT
    RET

write_mem8:
    MOV     ECX,   DWORD [ESP+4]      ; ECX = [ESP + 4](addr)
    MOV     AL,    BYTE  [ESP+8]      ; AL = [ESP + 8](data)

    MOV     BYTE [ECX], AL
    RET
