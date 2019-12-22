acpi_find:
    push	ebp
    mov	ebp, esp

    push ebx
    push ecx
    push edi

    mov	edi, [ebp + 8]      ; edi = addr
    mov	ecx, [ebp + 12]     ; ecx = size
    mov	eax, [ebp + 18]     ; eax = search result data

    ;****************
    ; find by name
    ;****************
    cld                         ; clear the DF
.10L:
    repne    scasb              ; while(AL != *ED) EDI++

    cmp	ecx, 0              ; if (0 == ecx)
    jnz	.11E                ; {
    mov	eax, 0              ; eax = 0
    jmp	.10E                ; break
.11E:
    cmp	eax, [es:edi - 1]   ; if (eax != *edi) // match 4 char??
    jne	.10L

    dec	edi                 ; eax = edi - 1
    mov	eax, edi
.10E:                           ; // while(1)
    pop	edi
    pop	ecx
    pop	ebx

    mov	esp, ebp
    pop	ebp

    ret
