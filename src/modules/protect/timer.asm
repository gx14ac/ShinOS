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

    outp 0x43, 0b_00_11_010_0   ; counter0, top/lower byte, mode2, binary
    outp 0x40, 0x9C             ; lower byte
    outp 0x40, 0x2E             ; top byte

    pop eax

    ret
