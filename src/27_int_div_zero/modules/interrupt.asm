;***********************************************
; initialize interrupt vector
;***********************************************
ALIGN 4
IDTR: dw 8 * 256 - 1            ; idt_limit
      dd VECT_BASE              ; idt location

;***********************************************
; initialize interrupt table
;***********************************************
;
;              |____________| _V___
;	  VECT_BASE| IntDefault |  |
;              | IntDefault |  | 8 * 256
;              |      :     |  |
;              |____________| _|___
;         +0800|////////////|
;              |            |
;
;                    ** IntDefault **
;                         8byte
;              |____________|____________|
;           [0]| Address Lo[15: 0]       |
;           [2]| Selector                |
;           [4]| Flags                   |
;           [6]|_Address Lo[32:16]_______|
;              |/////////////////////////|
;              |            |            |
;**********************************************
; ** format    : void init_int()
; ** arg       : nothing
; ** return    : nothing
;**********************************************
init_int:
    push eax
    push ebx
    push ecx
    push edi

    lea  eax, [int_default]     ; eax = interrupt addr
    mov  ebx, 0x0008_8E00       ; ebx = segment selector
    xchg ax, bx                 ; transform lower word

    mov ecx, 256                ; ecx = interrupt vector size
    mov edi, VECT_BASE          ; edi = vector table

.10L:                            ; do {
    mov  [edi + 0], ebx          ; [edi + 0] = interrupt descriptor(lower)
    mov  [edi + 4], eax          ; [edi + 4] = interrupt descriptor(higher)
    add  edi, 8                  ; edi += 8
    loop .10L                    ; } while (ecx--)

    ;***************************************
    ; configuration interrupt descriptor
    ;***************************************
    lidt [IDTR]                 ; load interrupt descriptor

    pop edi
    pop ecx
    pop ebx
    pop eax

    ret

;******************************************
; show the stack value & infinite loop
;******************************************
int_stop:
    cdecl draw_str, 25, 15, 0x060F, eax ; draw_str(EAX)

    mov eax, [esp + 0]                  ; eax = esp[0]
    cdecl itoa, eax, .p1, 8, 16, 0b0100 ; itoa(eax, 8, 16, 0b0100)

    mov eax, [esp + 4]
    cdecl itoa, eax, .p2, 8, 16, 0b0100 ; itoa(eax, 8, 16, 0b0100)

    mov eax, [esp + 8]
    cdecl itoa, eax, .p3, 8, 16, 0b0100 ; itoa(eax, 8, 16, 0b0100)

    mov eax, [esp + 12]
    cdecl itoa, eax, .p4, 8, 16, 0b0100 ; itoa(eax, 8, 16, 0b0100)

    cdecl draw_str, 25, 16, 0x0F04, .s1 ; draw_str("esp + 0")
    cdecl draw_str, 25, 17, 0x0F04, .s2 ; draw_str(" + 4")
    cdecl draw_str, 25, 18, 0x0F04, .s3 ; draw_str(" + 8")
    cdecl draw_str, 25, 19, 0x0F04, .s4 ; draw_str(" + 12")

    jmp $

.s1		db	"ESP+ 0:"
.p1		db	"________ ", 0
.s2		db	"   + 4:"
.p2		db	"________ ", 0
.s3		db	"   + 8:"
.p3		db	"________ ", 0
.s4		db	"   +12:"
.p4		db	"________ ", 0

;******************************************
; interrupt process : default process
;******************************************
int_default:
    pushf                  ; EFLAGS
    push cs
    push int_stop

    mov eax, .s0
    iret

.s0		db	" <    STOP    > ", 0

;******************************************
; interrupt process : zero divide
;******************************************
int_zero_div:
    pushf                       ; EFLAGS
    push cs                     ; cs
    push int_stop               ; display stack process

    mov eax, .s0
    iret

.s0		db	" <  ZERO DIV  > ", 0
