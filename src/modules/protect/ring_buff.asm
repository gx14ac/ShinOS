;****************************************************
; reading from ring buffer
;****************************************************
; ** format dword ring_rd(buff, data)
; ** arg
;        buff : ring buffer data
;        data : destination data address
; ** return value : yes data(expect 0), no data(0)
;****************************************************
ring_rd:

    ; ebp + 8  | ring data
    ; ebp + 12 | destination data address
    push ebp
    mov  ebp, esp

    push ebx
    push esi
    push edi

    ; get arg
    mov esi, [ebp + 8]          ; esi = ring data
    mov edi, [ebp + 12]         ; edi = destination data address

    ; checking reading position
    mov eax, 0                     ; eax = 0
    mov ebx, [esi + ring_buff.rp] ; ebx = reading positiom
    cmp ebx, [esi + ring_buff.wp]  ; if (ebx != wp)
    je  .10E                       ; {

    mov al, [esi + ring_buff.item + ebx] ; al = buff[rp] // register keycode
                                         ; al = [ring buffer head addr + 4 + writeposition]
    mov [edi], al                        ; edi = al // register keycode data

    inc ebx                       ; ebx++
    and ebx, RING_INDEX_MASK      ; ebx &= 0x0F(15) // valid index ring size
    mov [esi + ring_buff.rp], ebx ; wp = ebx // saving next reading position
    mov eax, 1                    ; yes data
.10E:
    pop edi
    pop esi
    pop ebx

    mov esp, ebp
    pop ebp

    ret

;****************************************************
; writing data to ring buffer
;****************************************************
; ** format dword ring_wr(buff, data)
; ** arg
;        buff : ring buffer data
;        data : destination data address
; ** return value : yes data(expect 0), no data(0)
;****************************************************
ring_wr:

    ; ebp + 8  | ring data
    ; ebp + 12 | destination data address
    push ebp
    mov  ebp, esp

    push ebx
    push ecx
    push esi

    ; get arg
    mov esi, [ebp + 8]          ; esi = ring data

    ; checking writing position
    mov eax, 0                    ; eax
    mov ebx, [esi + ring_buff.wp] ; ebx = wp // writing position
    mov ecx, ebx                  ; ecx = ebx
    inc ecx                       ; ecx++
    and ecx, RING_INDEX_MASK      ; ecx &= 0x0F

    cmp ecx, [esi + ring_buff.rp] ; if(ecx != rp)
    je  .10E                      ; {

    mov al, [ebp + 12]            ; al = data

    mov [esi + ring_buff.item + ebx], al ; buff[wp] = al // register keycode
    mov [esi + ring_buff.wp], ecx        ; wp = ecx // wirte position
    mov eax, 1                           ; eax = 1
.10E:
    pop esi
    pop ecx
    pop ebx

    mov esp, ebp
    pop ebp

    ret

;****************************************************
; show the keycode history
;****************************************************
; ** format void draw_key(col, row, buff)
; ** arg
;        col  : column
;        row  : row
;        buff : ring buffer
; ** return value : nothing
;****************************************************
draw_key:

    ; ebp + 8  | col
    ; ebp + 12 | row
    ; ebp + 16 | ring buffer
    push ebp
    mov  ebp, esp

    pusha

    ;***************************
    ; get args
    ;***************************
    mov edx, [ebp + 8]
    mov edi, [ebp + 12]
    mov esi, [ebp + 16]

    ;*************************************
    ; get from ring buffer infromation
    ;*************************************
    mov ebx, [esi + ring_buff.rp]   ; ebx = read position
    lea esi, [esi + ring_buff.item] ; esi = &KEY_BUFF[EBX]
    mov ecx, RING_ITEM_SIZE         ; ecx = RING_ITEM_SIZE(element size)
; loop (ebx == RING_INDEX_MASK)
.10L:
    dec ebx                     ; ebx-- // reading position
    and ebx, RING_INDEX_MASK    ; ebx &= RING_INDEX_MASK(ring_buff.wp - 1)
    mov al, [esi + ebx]         ; eax = KEY_BUFF[ebx]

    cdecl itoa, eax, .tmp, 2, 16, 0b0100 ; transform keycode to character
    cdecl draw_str, edx, edi, 0x02, .tmp ; display character

    add edx, 3                  ; refresh char position

    loop .10L
.10E:
    popa

    mov esp, ebp
    pop ebp

    ret

.tmp db "-- ", 0
