%include "../include/define.asm"
%include "../include/macro.asm"

    ORG KERNEL_LOAD              ; kernel load address

[BITS 32]
;****************************
; Entry Point
;****************************
kernel:
    jmp $

;****************************
; Padding
;****************************
times KERNEL_SIZE - ($ - $$) db 0
