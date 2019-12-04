;*******************************************
; allow interrupt of rtc
;*******************************************
; ** format void rtc_int_en(bit);
; ** arg
;        bit : allow interrupt bit
; ** return value : nothing
;*******************************************
rtc_int_en:

    ; ebp + 8 | bit
    push ebp
    mov  ebp, esp

    ;*****************************
    ; interrupt enable setting
    ;*****************************
    outp 0x70, 0x0B             ; outp(0x70, al)
    in   al, 0x71               ; al = port(0x71)
    or   al, [ebp + 8]          ; al |= bit // set the specified set
    out  0x71, al               ; outp(0x71, al) // wrote al

    pop eax

    mov esp, ebp
    pop ebp

    ret
;*******************************************
; interrupt process : RTC
;*******************************************
int_rtc:
    pusha
    push ds
    push es

    ; 0x0010 from GPT Head Byte
    mov ax, 0x0010
    mov ds, ax
    mov es, ax

    ;****************************************
    ; get clock from rtc
    ;****************************************
    cdecl rtc_get_time, RTC_TIME ; eax = get_time(&RTC_TIME)

    ;****************************************
    ; get RTC interrupt source
    ;****************************************
    outp 0x70, 0x0C             ; outp(0x70, 0x0C)
    in   al, 0x71

    ;****************************************
    ; clear the interrupt flag(EOI)
    ;****************************************
    outp 0xA0, 0x20             ; outp(0xA0, EOI)
    outp 0x20, 0x20             ; outp(0x20, EOI)

    pop es
    pop ds
    popa

    iret	; I will also clear the EFLAG register and return, so use iret.
