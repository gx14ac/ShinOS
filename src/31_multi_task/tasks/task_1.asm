task_1:
    ;*******************
    ; display the char
    ;*******************
    cdecl draw_str, 63, 0, 0x07, .s0 ; draw_str()

    iret
.s0 db "Task-1", 0
