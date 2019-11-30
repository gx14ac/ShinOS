;*************************************
; select read plane
;*************************************
; format : void vga_set_read_plane
; arg    : read plane
; return : nothing
;*************************************
vga_set_read_plane:

    ; ebp + 8 plane(index)
    ; ebp + 4 return address
    ; ebp + 0 base address
    push ebp
    mov  ebp, esp

    push eax
    push edx

    ;*****************************
    ; only select read plane
    ;*****************************
    mov ah, [ebp + 8]           ; ah = select read plane(3=light, 2~0=RGB)
    and ah, 0x03                ; ah &= 0x03 (mask to no used bit)
    mov al, 0x04                ; al = only select read plane register
    mov dx, 0x03CE              ; dx = controll graphics port
    out dx, ax                  ; output port

    pop edx
    pop eax

    mov esp, ebp
    pop ebp

    ret

;*************************************
; select write plane
;*************************************
; format : void vga_set_write_plane
; arg    : write plane
; return : nothing
;*************************************
vga_set_write_plane:

    ; ebp + 8 plane(plane bit)
    ; ebp + 4 return address
    ; ebp + 0 base address
    push ebp
    mov  ebp, esp

    push eax
    push edx

    ;*****************************
    ; only select write plane
    ;*****************************
    mov  ah, [ebp + 8]          ; ah = select write plane(Bit: ----IRGB)
    and  ah, 0x0F               ; ah = 0x0F (mask to no used bit)
    mov  al, 0x02               ; al = only select write plane register
    mov  dx, 0x03C4             ; dx = cotroll sequece port
    out  dx, ax                 ; output port

    pop edx
    pop eax

    mov esp, ebp
    pop ebp

    ret
