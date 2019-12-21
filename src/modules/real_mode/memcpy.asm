memcpy:
    push	bp          ; push to stack base pointer register.
    mov	bp, sp     ; ebp = esp. set top stack. // ebpレジスタの基準をebpレジスタに設定する

    push	cx          ; ecx is counter register.
    push	si          ; esi is original.
    push	di          ; edi is copy.

    cld               ; increment edi, esi, ecx register.

    mov	di, [bp + 4] ; edi = first argument(destination).
    mov	si, [bp + 6] ; esi = second argument(original).
    mov	cx, [bp + 8] ; ecx is counter register

    rep     movsb         ; copies bytes from esi to edi for ecx register count.

    pop	di           ; back to edi register.
    pop	si           ; back to esi register.
    pop	cx           ; back to ecx register.

    mov sp, bp      ; esp = ebp // espレジスタの値をこれまで基準としていた、ebpレジスタの値に設定し直す
    pop bp           ; ebpレジスタの値を取り出す

    ret
