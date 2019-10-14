memcpy:
    push ebp          ; push to stack base pointer register.
    mov  ebp, esp     ; ebp = esp. set top stack.
    push ecx          ; ecx is counter register.
    push esi          ; esi is original.
    push edi          ; edi is copy.
    cld               ; increment edi, esi, ecx register.
    mov edi, [ebp+8]  ; edi = first argument(destination).
    mov esi, [ebp+12] ; esi = second argument(original).
    mov ecx, [ebp+16] ; ecx is counter register
    rep movsb         ; copies bytes from esi to edi for ecx register count.