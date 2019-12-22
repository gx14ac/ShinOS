;*******************************
; [CTRL + ALT + END]
;*******************************
; ** format : DWORD ctrl_and_alt(key)
; ** arg    : input keycode
; ** return : except 0
;*******************************
ctrl_alt_end:
    push	ebp
    mov	ebp, esp

    ;*******************
    ; saving key state
    ;*******************
    mov	eax, [ebp + 8]      ; eax = key
    btr	eax, 7              ; cf = eax & 0x80
    jc      .10F                ; if (0 == cf)
    bts	[.key_state], eax   ; {
    jmp	.10E                ; flag set
.10F:
    btc	[.key_state], eax   ; clear flag
.10E:
    mov	eax, 0x1D           ; eax = ctrl key
    bt      [.key_state], eax   ; if(0 == key)
    jnc	.20E                ; break

    mov	eax, 0x38           ; eax = alt key
    bt      [.key_state], eax   ; if('ALT' != key)
    jnc	.20E                ; break

    mov	eax, 0x4F           ; eax = end key
    bt      [.key_state], eax   ; if('End' != key)
    jnc	.20E                ; break

    mov	eax, -1             ; ret = -1
.20E:
    sar	eax, 8              ; ret >> 8

    mov	esp, ebp
    pop	ebp

    ret

.key_state: times 32 db 0
