;************************************
; get clock data from rtc
;************************************
; ** format  : dword rtc_get_time(dst)
; ** arg
;        dst : Destination address
; ** return value : nothing
;************************************
rtc_get_time:

    ; ebp + 8 | destination address
    push ebp
    mov  ebp, esp

    push ebx

    ;**************************
    ; ** get clock data from rtc
    ; ** output parameter
    ; 0x00 | second
    ; 0x02 | minutes
    ; 0x04 | hour
    ; 0x07 | day
    ; 0x08 | month
    ; 0x09 | year
    ; **
    ;**************************
    mov  al, 0x0A               ; al = 0x0A
    out  0x70, al               ; output(0x70, AL)
    in   al, 0x71               ; al
    test al, 0x80
    je   .10F
    mov  eax, 1
    jmp  .10E
.10F:
    mov al, 0x04
    out 0x70, al
    in  al, 0x71
    shl eax, 8

    mov al, 0x02
    out 0x70, al
    in  al, 0x71
    shl eax, 8

    mov al, 0x00
    out 0x70, al
    in  al, 0x71
    shl eax, 8

    and eax, 0x00_FF_FF_FF      ; Only the lower 3 bytes are valid
    mov ebx, [ebp + 8]          ; dst = destination register
    mov [ebx], eax              ; [dst] = clock

    mov eax, 0                  ; ret = 0
.10E:
    pop ebx

    mov esp, ebp
    pop ebp

    ret
