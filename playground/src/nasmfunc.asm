section .text
    GLOBAL  io_hlt, io_cli, io_sti, io_stihlt
    GLOBAL  io_in8, io_in16, in_in32
    GLOBAL  io_out8, io_out16, io_out32
    GLOBAL  io_load_eflags, io_store_eflags
    GLOBAL  load_gdtr, load_idtr
    GLOBAL  asm_inthandler21, asm_inthandler2c, asm_inthandler27
    EXTERN  int_handler21, int_handler2c, int_handler27

io_hlt:
    HLT
    RET

io_cli:
    CLI
    RET

io_sti:
    STI
    RET

io_stihlt:
    STI
    HLT
    RET

io_in8:
    MOV     EDX, [ESP + 4]      ; port
    MOV     EAX, 0
    IN      AL, DX              ; Input character data from input device(PORT). 8bit
    RET

io_in16:
    MOV     EDX, [ESP + 4]      ; port
    MOV     EAX, 0
    IN      AX, DX              ; Input character data from input device(PORT). 16bit
    RET

io_in32:
    MOV     EDX, [ESP + 4]      ; port
    MOV     EAX, 0
    IN      EAX, DX              ; Input character data from input device(PORT). 32bit
    RET

io_out8:
    MOV     EDX, [ESP + 4]      ; port
    MOV     AL,  [ESP + 8]      ; data
    OUT     DX, AL              ; Input character data from output device(PORT). 8bit
    RET

io_out16:
    MOV     EDX, [ESP + 4]      ; port
    MOV     EAX,  [ESP + 8]     ; data
    OUT     DX, AX              ; Input character data from output device(PORT). 16bit
    RET

io_out32:
    MOV     EDX, [ESP + 4]      ; port
    MOV     EAX,  [ESP + 8]     ; data
    OUT     DX, EAX             ; Input character data from output device(PORT). 32bit
    RET

io_load_eflags:                 ; int io_load_eflags(void);
    PUSHFD                      ; push eflags double-word
    POP     EAX                 ; eax = eflags
    RET

io_store_eflags:
    MOV     EAX, [ESP + 4]
    PUSH    EAX                 ; eax = eflags
    POPFD                       ; elflags = eax
    RET

load_gdtr:
    MOV     AX, [ESP + 4]
    MOV     [ESP + 6], AX
    LGDT    [ESP + 6]
    RET

load_idtr:
    MOV     AX, [ESP + 4]
    MOV     [ESP + 6], AX
    LIDT    [ESP + 6]
    RET

asm_inthandler21:
    PUSH    ES
    PUSH    DS
    PUSHAD
    MOV     EAX, ESP
    PUSH    EAX
    MOV     AX, SS
    MOV     DS, AX
    MOV     ES, AX
    CALL    int_handler21
    POP     EAX
    POPAD
    POP     DS
    POP     ES
    IRETD

asm_inthandler27:
    PUSH    ES
    PUSH    DS
    PUSHAD
    MOV     EAX, ESP
    PUSH    EAX
    MOV     AX, SS
    MOV     DS, AX
    MOV     ES, AX
    CALL    int_handler27
    POP     EAX
    POPAD
    POP     DS
    POP     ES
    IRETD

asm_inthandler2c:
    PUSH    ES
    PUSH    DS
    PUSHAD
    MOV     EAX, ESP
    PUSH    EAX
    MOV     AX, SS
    MOV     DS, AX
    MOV     ES, AX
    CALL    int_handler2c
    POP     EAX
    POPAD
    POP     DS
    POP     ES
    IRETD
