%include "../include/define.asm"
%include "../include/macro.asm"

    ORG KERNEL_LOAD              ; kernel load address

;Instruct the assembler to 32bit
[BITS 32]
;****************************
; Entry Point
;****************************
kernel:
    ;****************
    ; Get Font Addr
    ;****************

    mov   esi, BOOT_LOAD + SECT_SIZE ; esi = 0x7C00 + 512
    movzx eax, word[esi + 0]         ; eax = [esi + 0] // segment
    movzx ebx, word[esi + 2]         ; ebx = [esi + 2] // offset

    shl   eax, 4               ; eax << 4 // left bit shift
    add   eax, ebx             ; eax += ebx
    mov   [FONT_ADDR], eax     ; [FONT]0 = eax

    ;************************
    ; display char
    ;************************
    cdecl draw_char, 0, 0, 0x010F, 'A'
    cdecl draw_char, 1, 0, 0x010F, 'B'
    cdecl draw_char, 2, 0, 0x010F, 'C'

    cdecl draw_char, 0, 0, 0x0402, '0'
    cdecl draw_char, 1, 0, 0x0212, '1'
    cdecl draw_char, 2, 0, 0x0212, '_'

    ;************************
    ; 8bit horizontal line
    ;************************
    mov ah, 0x07                ; ah = select 'write plane'
    mov al, 0x02                ; al = map mask register
    mov dx, 0x03c4              ; dx = controllable sequence port
    out dx, ax                  ; output port
    mov [0x000A_0000 + 0], byte 0xFF

    mov ah, 0x04                ; ah = select 'write plane'
    out dx, ax                  ; output port
    mov [0x000A_0000 + 1], byte 0xFF

    mov ah, 0x02                     ; ah = select 'write plane'
    out dx, ax                       ; output port
    mov [0x000A_0000 + 2], byte 0xFF

    mov ah, 0x01                     ; ah = select 'write plane'
    out dx, ax                       ; output port
    mov [0x000A_0000 + 3], byte 0xFF

    ;************************
    ; vertical line
    ;************************
    mov ah, 0x02
    out dx, ax

    lea edi, [0x000A_0000 + 80] ; edi = VRAM address
    mov ecx, 80                 ; ecx = loop count
    mov al, 0x0FF               ; al = bit pattern
    rep stosb                   ; edi++ = al

    ;****************************
    ; 8dot short in second line
    ;****************************
    mov edi, 1

    shl edi, 8                        ; edi *= 8(2^8)
    lea edi, [edi*4 + edi + 0xA_0000] ; edi = VRAM address

    mov [edi + (80*0)], word 0xFF
    mov [edi + (80*1)], word 0xFF
    mov [edi + (80*2)], word 0xFF
    mov [edi + (80*3)], word 0xFF
    mov [edi + (80*4)], word 0xFF
    mov [edi + (80*5)], word 0xFF
    mov [edi + (80*6)], word 0xFF
    mov [edi + (80*7)], word 0xFF

    ;*******************************
    ; show the char in third line
    ;*******************************
    mov esi, 'A'                ; esi = char code
    shl esi, 4                  ; esi *=16(char code^4)
    add esi, [FONT_ADDR]        ; esi = FONT_ADDR[char code]

    mov edi, 2                        ; edi = rows
    shl edi, 8                        ; edi *= 8(2^8)
    lea edi, [edi*4 + edi + 0xA_0000] ; edi = VRAM address

    mov ecx, 16                       ; ecx = 16

.10L:
    movsb                       ; *edi++ = *esi
    add edi, 80 - 1             ; edi += 79
    loop .10L

    jmp $
ALIGN 4, db 0
FONT_ADDR: dd 0

;****************************
; Modules
;****************************
%include "../modules/protect/vga.asm"
%include "../modules/protect/draw_char.asm"

;****************************
; Padding
;****************************
times KERNEL_SIZE - ($ - $$) db 0
