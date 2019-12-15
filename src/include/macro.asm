;*********************************************
; designed for calling function macro
;*********************************************
%macro cdecl 1-*.nolist

    %rep %0 - 1
        push %{-1:-1}
        %rotate -1
    %endrep
    %rotate -1

        call %1

    %if 1 < %0
        add sp, (__BITS__ >> 3) * (%0-1)
    %endif

%endmacro

;*********************************************
; designed for configuration interrupt vector
;*********************************************
%macro set_vect 1-*.nolist
    push eax
    push edi

    mov  edi, VECT_BASE + (%1 * 8) ; vector addr
    mov  eax, %2

    %if 3 == %0
        mov [edi + 4], %3       ; flag
    %endif

    mov [edi + 0], ax           ; expect addr[15 : 0]
    shr eax, 16
    mov [edi + 6], ax           ; expect addr[31 : 16]

    pop edi
    pop eax
%endmacro

%macro outp 2
    mov al, %2
    out %1, al
%endmacro

;*********************************************
; drive param
;*********************************************
struc drive
        .no   resw  1               ; Drive Number.
        .cyln resw  1               ; Cylinder.
        .head resw  1               ; Head.
        .sect resw  1               ; Sector.
endstruc

;*********************************************
; ring buffer
;*********************************************
%define RING_ITEM_SIZE (1 << 4)
%define RING_INDEX_MASK (RING_ITEM_SIZE - 1)

struc ring_buff
    .rp    resd 1               ; read position
    .wp    resd 1               ; write position
    .item  resb RING_ITEM_SIZE  ; buffer
endstruc

;*********************************************
; setting for descriptor base & limit addr
;*********************************************
; ** arg
;        first arg  : descriptor addr
;        second arg : base addr
;        third arg  : limit
;*********************************************
%macro set_desc 2-*
    push eax                    ; // ax, ah, al
    push edi                    ; // designated remember addr

    mov edi,  %1                  ; descriptor addr
    mov eax,  %2                  ; base addr

    %if 3 == %0
        mov [edi + 0], %3        ; setting limit
    %endif

    mov [edi + 2], ax            ; base([15:0])
    shr eax, 16
    mov [edi + 4], al            ; base([23:16])
    mov [edi + 7], ah            ; base([31:24])

    pop edi
    pop eax
%endmacro

;*********************************************
; setting for gate descriptor offset
;*********************************************
; ** arg
;        first arg  : descriptor addr
;        second arg : offset addr
;*********************************************
%macro set_gate 2-*
    push eax
    push edi

    mov edi, %1                 ; edi = descriptor address
    mov eax, %2                 ; eax = base address

    mov [edi + 0], ax           ; base ([15:0])
    shr eax, 16
    mov [edi + 6], ax           ; base([31:16])

    pop edi
    pop eax
%endmacro

;*****************************
; rose parameter
;*****************************
struc rose
    .x0      resd 1
    .y0      resd 1
    .x1      resd 1
    .y1      resd 1

    .n       resd 1
    .d       resd 1

    .color_x resd 1
    .color_y resd 1
    .color_z resd 1
    .color_s resd 1
    .color_f resd 1
    .color_b resd 1

    .title   resb 16
endstruc
