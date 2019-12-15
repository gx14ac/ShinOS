wait_tick:

    push ebp
    mov  ebp, esp

    push eax
    push ecx

    mov ecx, [ebp + 8]          ; ecx = wait count
    mov eax, [TIMER_COUNT]      ; eax = timer

.10L: cmp [TIMER_COUNT], eax    ; while(TIMER != eax)
    je    .10L                  ; (TIMER==eax)
    inc   eax                   ; eax++
    loop .10L                   ; loop

    pop ecx
    pop eax

    mov esp, ebp
    pop ebp

    ret
