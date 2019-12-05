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
