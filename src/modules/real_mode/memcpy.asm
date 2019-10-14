memcpy:
    push ebp          ; push to stack base pointer register.
    mov  ebp, esp     ; ebp = esp. set top stack. // ebpレジスタの基準をebpレジスタに設定する

    push ecx          ; ecx is counter register.
    push esi          ; esi is original.
    push edi          ; edi is copy.

    cld               ; increment edi, esi, ecx register.
    mov edi, [ebp+8]  ; edi = first argument(destination).
    mov esi, [ebp+12] ; esi = second argument(original).
    mov ecx, [ebp+16] ; ecx is counter register
    rep movsb         ; copies bytes from esi to edi for ecx register count.

    pop edi           ; back to edi register.
    pop esi           ; back to esi register.
    pop ecx           ; back to ecx register.
    
    mov esp, ebp      ; esp = ebp // espレジスタの値をこれまで基準としていた、ebpレジスタの値に設定し直す
    pop ebp           ; ebpレジスタの値を取り出す
    ret