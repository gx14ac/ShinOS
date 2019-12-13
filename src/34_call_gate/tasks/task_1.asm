task_1:
    ;*******************
    ; display the char
    ;*******************
    cdecl SS_GATE_0:0, 63, 0, 0x07, .s0 ; draw_str()
.10L:
    mov   eax, [RTC_TIME]         ; get the clock
    cdecl draw_time, 72, 0, 0x0700, eax ; display clock

    jmp SS_TASK_0:0
    jmp .10L

.s0 db "Task-1", 0
