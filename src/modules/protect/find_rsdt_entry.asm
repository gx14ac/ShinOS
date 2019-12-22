find_rsdt_entry:
    push	ebp
    mov	ebp, esp

    push	ebx
    push	ecx
    push	esi
    push	edi

    mov	esi, [ebp + 8]
    mov	ecx, [ebp + 12]
    mov	ebx, 0

    ;*********************
    ; search ACPI Table
    ;*********************
    mov	edi, esi
    add	edi, [esi + 4]
    add	esi, 36
.10L:
    cmp	esi, edi            ; while(esi < edi)
    jge	.10E                ; {

    lodsd                       ; eax = [esi++]

    cmp	[eax], ecx          ; if(ecx == *eax)
    jne	.12E                ; {
    mov	ebx, eax            ; adr = eax
    jmp	.10E                ; break
.12E:  jmp .10L                 ; }
.10E:                           ; }
    mov	eax, ebx            ; return addr

    pop	edi
    pop	esi
    pop	ecx
    pop	ebx

    mov	esp, ebp
    pop	ebp

    ret
