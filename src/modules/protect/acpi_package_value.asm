acpi_package_value:
    push	ebp
    mov	ebp, esp

    push	esi

    mov	esi, [ebp + 8]

    ;**************************
    ; skip the packet header
    ;**************************
    inc	esi                 ; esi++ // Skip 'PackageOp'
    inc	esi                 ; esi++ // Skip 'PackageLength'
    inc	esi                 ; esi++ // Skip 'NumElements'

    ;*******************
    ; get only 2 bytes
    ;*******************
    mov	al, [esi]           ; al = *esi
    cmp	al, 0x0B            ; switch (AL)
    je      .c0B                ; {
    cmp	al, 0x0C            ;
    je      .c0C                ;
    cmp	al, 0x0E            ;
    je      .C0E                ;
    jmp	.c0A                ;
.C0B:                           ; case 0x0B // 'WordPrefix'
.C0C:                           ; case 0x0C // 'DWordPrefix'
.C0E:                           ; case 0x0E // 'QWordPrefix'
    mov	al, [esi + 1]       ; al = esi[1]
    mov	ah, [esi + 2]       ; ah = esi[2]
    jmp	.10E                ; break
.C0A:                           ; default: 'BytePrefix' | 'ConstObj'
    ; first 1 byte
    cmp	al, 0x0A            ; if (0x0A = AL)
    jne	.11E                ; {
    mov	al, [esi + 1]       ; al = *esi
    inc	esi                 ; esi++
.11E:
    ; first 1 byte
    inc	esi                 ; esi++

    mov	ah, [esi]           ; ah = esi++
    cmp	ah, 0x0A            ; if (0x0A == al)
    jne	.12E                ; {
    mov	ah, [esi + 1]       ; ah = esi[1]
.12E:
.10E:
    pop	esi

    mov	esp, ebp
    pop	ebp

    ret
