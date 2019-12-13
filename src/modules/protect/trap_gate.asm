;*************************************
; system call: output 1 character
; eax : character code
; ebx : color
; ecx : column
; edx : line
;*************************************
trap_gate_81:
    ;**********************
    ; output 1 character
    ;**********************
    cdecl draw_char, ecx, edx, ebx, eax ; // output 1 character

    iret

;*************************************
; system call: output 1 dot
; ebx : color
; ecx : x
; edx : y
;*************************************
trap_gate_82:
    ;***************
    ; output 1 dot
    ;***************
    cdecl draw_pixel, ecx, edx, ebx

    iret
