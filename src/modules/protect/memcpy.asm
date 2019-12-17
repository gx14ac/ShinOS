;***************************
; copy the memory
;***************************
; ** format void memcpy(dst, src, size)
; ** arg
;       dst  : copy destination
;       src  : original
;       size : byte size
; ** return : nothing
;***************************
memcpy:

    ;************************************
    ; ebp + 16 | byte size
    ; ebp + 12 | orginal
    ; ebp + 8  | copy destination
    ; ebp + 4  | return addr
    ; ebp + 0  | base addr
    ;************************************
    push	ebp
    mov	ebp, esp

    push	ecx
    push	esi
    push	edi

    ;*****************
    ; copy in byte
    ;*****************
    cld                         ; df = 0
    mov	edi, [ebp + 8]      ; edi = copy destination
    mov	esi, [ebp + 12]     ; edi = original
    mov	ecx, [ebp + 16]     ; edi = byte size
    rep     movsb               ; while (*edi++ = *esi++)

    pop	edi
    pop	esi
    pop	ecx

    mov	esp, ebp
    pop	ebp

    ret
