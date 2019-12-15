;*************************************************
; interrupt prcess : # can't use device
;*************************************************
int_nm:
    pusha
    push ds
    push es

    ;**********************************************
    ; configuration designated kernel selector
    ;**********************************************
    mov ax, DS_KERNEL
    mov ds, ax
    mov es, ax

    ; clear task switch flag
    clts           ; CR0.TS = 0

    ;**********************************************
    ; last/this time  use task
    ;**********************************************
    mov edi, [.last_tss]        ; edi = last time, using tss task
    str esi                     ; esi = this time, usign tss task
    and esi, ~0x0007            ; mask the privilege

    ;***********************************
    ; wherther is it use first time
    ;***********************************
    cmp edi, 0                  ; if(0 != edi) // did using task for last time
    je .10F                     ; {

    cmp esi, edi                ; if(esi != edi) // did using another task
    je .12E                     ; {

    cli                         ; don't allow interrupt process

    ;***********************************
    ; saving last time fpu context
    ;***********************************
    mov  ebx, edi               ; last time tass
    call get_tss_base           ; get tss addr
    call save_fpu_context       ; saving fpu context

    mov  ebx, esi               ; this time task
    call get_tss_base           ; get tss addr
    call load_fpu_context

    sti                         ; allow interrupt process
.12E:                           ; }
    jmp .10E                    ; }
.10F:
    cli                         ; don't allow interrupt process

    ;***********************************
    ; saving this time fpu context
    ;***********************************
    mov  ebx, esi               ; this time task
    call get_tss_base           ; get current tss addr
    call load_fpu_context       ; return fpu context

    sti
.10E:
    mov [.last_tss], esi        ; save task using rpu
    pop es
    pop ds
    popa

    iret
ALIGN 4, db 0
.last_tss: dd 0

;*************************************************
; Get TSS Base Address
;*************************************************
; [IN]  ebx : tss selector (protected memory space)
; [OUT] eax : base address
;*************************************************
get_tss_base:
    mov eax, [GDT + ebx + 2]    ; eax = tss[23 : 0]
    shl eax, 8                  ; eax << = 8
    mov al, [GDT + ebx + 7]     ; al = tss[31:24]
    ror eax, 8                  ; eax >>= 8

    ret

save_fpu_context:
    fnsave [eax + 104]             ; saving fpu context
    mov [eax + 104 + 108], dword 1 ; saved = 1 // saving flag

    ret

;*******************************
; return fpu context
;*******************************
; [IN] eax : tss head address
;*******************************
load_fpu_context:
    cmp [eax + 104 + 108], dword 0 ; if(0 == saved)
    jne .10F                       ; {
    fninit                         ; initialize fpu
    jmp .10E                       ; }
.10F:
    frstor [eax + 104]          ; return fpu context
.10E:
    ret
