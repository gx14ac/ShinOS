;**********************************************************
; show the timer
;**********************************************************
; ** format  : void draw_time(col, row, color, time)
; ** arg
;        col   : column
;        row   : row
;        color : drawing color
;        time  : time data
; ** return value : nothing
;**********************************************************
draw_time:
    ; ebp + 20 | time data
    ; ebp + 16 | color
    ; ebp + 12 | row
    ; ebp + 8  | column
    push ebp
    mov  ebp, esp

    push eax
    push ebx

    mov  eax, [ebp + 20]         ; eax = time data
    cmp  eax, [.last]            ; if(current != after)
    je   .10E

    mov [.last], eax            ; update last time value

    mov ebx, 0                  ; ebx = 0
    mov bl, al                  ; ebx = second
    cdecl itoa, ebx, .sec, 2, 16, 0b0100 ; sec to character

    mov bl, ah                           ; ebx = minutes
    cdecl itoa, ebx, .min, 2, 16, 0b0100 ; min to character

    shr eax, 16                           ; ebx = hour
    cdecl itoa, eax, .hour, 2, 16, 0b0100 ; hour to character

    ; show the clock
    cdecl draw_str, dword[ebp + 8], dword[ebp + 12], dword[ebp + 16], .hour
.10E:
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret

ALIGN 2, db 0
.temp: dq 0
.last: dq 0
.hour: db "ZZ:"
.min:  db "ZZ:"
.sec:  db "ZZ", 0
