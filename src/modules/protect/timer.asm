;************************************************************
; configuration timer
;************************************************************
; allow interrupt counter0
;************************************************************
; ** format : void int_en_timer0(void)
; ** arg    : nothing
; ** return : nothing
;************************************************************
int_en_timer0:

    push eax

    ;**************************************************************************************
    ; 8254 Timer
    ; 0x2E9C(11932)=10[ms], CLK=1,193,182[Hz]
    ; 00  = select counter 0 // access counter
    ; 11  = access in order of lower and higher // how to access to counter?
    ; 010 = mode2 // action mode
    ; 0   = 16bit binary counter // BCD
    ;**************************************************************************************
    outp 0x43, 0b_00_11_010_0   ; counter0, top/lower byte, mode2, binary
    outp 0x40, 0x9C             ; lower byte
    outp 0x40, 0x2E             ; top byte

    pop eax

    ret
