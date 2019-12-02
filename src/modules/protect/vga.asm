;*************************************
; select read plane
;*************************************
; format : void vga_set_read_plane
; arg    : read plane
; return : nothing
;*************************************
vga_set_read_plane:

    ; ebp + 8 | plane(index)
    ; ebp + 4 | return address
    ; ebp + 0 | base address
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

    ; ebp + 8 | plane(plane bit)
    ; ebp + 4 | return address
    ; ebp + 0 | base address
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

;********************************************************
; write font
;********************************************************
; format : void vram_font_copy(font, vram, plane, color)
; arg
;     font  : font address
;     vram  : VRAM address
;     plane : output plane
;     color : color
; return : nothing
;********************************************************
vram_font_copy:

    ; ebp + 20 | color
    ; ebp + 16 | plane
    ; ebp + 12 | VRAM address
    ; ebp + 8  | Font address
    ; ebp + 4  | return value
    ; ebp + 0  | base address

    push ebp
    mov  ebp, esp

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov   esi, [ebp + 8]          ; esi = font addr
    mov   edi, [ebp +12]          ; edi = vram addr
    movzx eax, byte[ebp + 16]     ; eax = plane(select bit)
    movzx ebx, word[ebp + 20]     ; ebx = color

    test bh, al                 ; zf = (background color & plane)
    setz dh                     ; ah = zf ? 0x01 : 0x00
    dec  dh                     ; ah-- // 0x00 or 0xFF

    test bl, al                 ; zf = (foreground color & plane)
    setz dl                     ; al = zf ? 0x01 : 0x00
    dec  dl                     ; al-- // 0x00 or 0xFF

    ;****************************
    ; copy the 16 bit font
    ;****************************

    cld                         ; df = 0 // add address

    mov ecx, 16                 ; ecx = 16

.10L:

    lodsb                       ; al = *esi++ // font
    mov   ah, al                ; ah ~= al
    not   ah

    ;****************************
    ; foreground color
    ;****************************
    and al, dl                  ; al = foreground color & font

    ;****************************
    ; background color
    ;****************************
    test ebx, 0x0010            ; if(through mode)
    jz   .11F                   ; {
    and  ah, [edi]              ;      ah = !font & [edi] // current value
    jmp  .11E                   ; }
.11F:                           ; else
    and ah, dh                  ; ah = !font & background color
.11E:

    ;*****************************************
    ; composite background & foreground color
    ;*****************************************
    or al, ah

    ;****************************
    ; output new value
    ;****************************
    mov  [edi], al              ; [edi] = al // write plane
    add  edi, 80                ; edi += 80
    loop .10L                   ; while (--ecx)
.10E:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp

    pop ebp

    ret

;***********************************************
; wirte bit patern
; **********************
; ** format : vram_bit_copy(bit, vram, flag)
; ** arg
;        bit  : output bit patern
;        vram : vram addr
;        flag : 1:set, 0:clear
; ** return value : nothing
;***********************************************
vram_bit_copy:

    ; ebp + 20 | color(background/foreground)
    ; ebp + 16 | plane(select bit)
    ; ebp + 12 | vram addr
    ; ebp + 8  | output bit patern
    push ebp
    mov  ebp, esp

    push eax
    push ebx
    push edi

    mov   edi, [ebp + 12]       ; edi = vram addr
    movzx eax, byte[ebp + 16]   ; eax = plane(select bit)
    movzx ebx, word[ebp + 20]   ; ebx = display color

    test bl, al
    setz bl
    dec  bl

    ;******************************
    ; create mask data
    ;******************************
    mov al, [ebp + 8]
    mov ah, al
    not ah

    ;******************************
    ; get current output
    ;******************************
    and ah, [edi]
    and al, bl
    or  al, ah

    ;******************************
    ; output new value
    ;******************************
    mov [edi], al

    pop edi
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret
