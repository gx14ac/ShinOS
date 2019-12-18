task_1:
    ;*******************
    ; display the char
    ;*******************
    cdecl draw_str, 63, 0, 0x07, .s0 ; draw_str()
.10L:
    mov   eax, [RTC_TIME]         ; get the clock
    cdecl draw_time, 72, 0, 0x0700, eax ; display clock

    jmp .10L

.s0 db "Task-1", 0
