;**************************************************
; TSS(Task State Segment) for TASK_0(Kernel Task)
; Size 104 bytes
;**************************************************
TSS_0:
.link:   dd 0                   ;
.esp0:   dd SP_TASK_0 - 512     ;*4:esp0
.ss0:    dd DS_KERNEL           ;*8
.esp1:   dd 0                   ;*12:esp1
.ss1:    dd 0                   ;*16
.esp2:   dd 0                   ;*20:esp2
.ss2:    dd 0                   ;*24
.cr3:    dd 0                   ; 28:CR3(PDBR)
.eip:    dd 0                   ; 32:EIP
.eflags: dd 0                   ; 36:EFlAGS
.eax:    dd 0                   ; 40:eax
.ecx:    dd 0                   ; 44:ecx
.edx:    dd 0                   ; 48:edx
.ebx:    dd 0                   ; 52:ebx
.esp:    dd 0                   ; 56:esp
.ebp:    dd 0                   ; 60:ebp
.esi:    dd 0                   ; 64:esi
.edi:    dd 0                   ; 68:edi
.es:     dd 0                   ; 72:es
.cs:     dd 0                   ; 76:cs
.ss:     dd 0                   ; 80:ss
.ds:     dd 0                   ; 84:ds
.fs:     dd 0                   ; 88:fs
.gs:     dd 0                   ; 92:gs
.ldt:    dd 0                   ;*96:ldt
.io:     dd 0                   ;100:I/O MapBaseAddress

;**************************************
; TSS(Task State Segment) for TASK_1
; Size 104 bytes
;**************************************
TSS_1:
.link:   dd 0
.esp0:   dd SP_TASK_1 - 512     ;*  4:esp0
.ss0:    dd DS_KERNEL           ;*  8:
.esp1:   dd 0                   ;* 12:esp1
.ss1:    dd 0                   ;* 16:
.esp2:   dd 0                   ;* 20:esp2
.ss2:    dd 0                   ;* 24:
.cr3:    dd 0                   ;* 28:CR3(PDBR)
.eip:    dd task_1              ;  32:eip(start task1 address)
.eflags: dd 0x0202              ;  36:EFLAGS(initial eflags value)
.eax:    dd 0                   ;  40:eax
.ecx:    dd 0                   ;  44:ecx
.edx:    dd 0                   ;  48:edx
.ebx:    dd 0                   ;  52:ebx
.esp:    dd SP_TASK_1           ;  56:esp(initial stack pointer)
.ebp:    dd 0                   ;  60:ebp
.esi:    dd 0                   ;  64:esi
.edi:    dd 0                   ;  68:edi
.es:     dd DS_TASK_1           ;  72:es
.cs:     dd CS_TASK_1           ;  76:cs(code segment selector for task1)
.ss:     dd DS_TASK_1           ;  80:ss(data segment selector for task1)
.ds:     dd DS_TASK_1           ;  84:ds(data segment selector for task1)
.fs:     dd DS_TASK_1           ;  88:fs(data segment selector for task1)
.gs:     dd DS_TASK_1           ;  92:gs(data segment selector for task1)
.ldt:    dd SS_LDT              ;* 96:ldt segment selecter
.io:     dd 0                   ; 100:I/O MapBaseAddress

;*****************************
; Global Descriptor Table
;*****************************
GDT:			dq	0x0000000000000000			; NULL
.cs_kernel:		dq	0x00CF9A000000FFFF		; CODE 4G
.ds_kernel:		dq	0x00CF92000000FFFF		; DATA 4G
.ldt			dq	0x0000820000000000			; LDT descriptor
.tss_0:             dq  0x0000890000000067      ; TSS descriptor
.tss_1:             dq  0x0000890000000067      ; TSS descriptor
.end:

;*********************************
; Global Descriptor Base Address
;*********************************
CS_KERNEL equ .cs_kernel - GDT
DS_KERNEL equ .ds_kernel - GDT
SS_LDT    equ .ldt       - GDT
SS_TASK_0 equ .tss_0	 - GDT
SS_TASK_1 equ .tss_1	 - GDT

GDTR: dw GDT.end - GDT - 1
      dd GDT

;********************************************
; Local Descriptor Table
;********************************************
LDT: dq 0x0000000000000000      ; NULL
.cs_task_0: dq 0x00CF9A000000FFFF  ; CODE 4G
.ds_task_0: dq 0x00CF92000000FFFF  ; DATA 4G
.cs_task_1: dq	0x00CF9A000000FFFF ; CODE 4G
.ds_task_1: dq	0x00CF92000000FFFF ; DATA 4G
.end:

; `| 4` means that the segment granularity is 4k
CS_TASK_0 equ (.cs_task_0 - LDT) | 4 ; designated task0 cs selecter
DS_TASK_0 equ (.ds_task_0 - LDT) | 4 ; designated task0 ds selecter
CS_TASK_1 equ (.cs_task_1 - LDT) | 4 ; designated task1 cs selecter
DS_TASK_1 equ (.ds_task_1 - LDT) | 4 ; designated task1 ds selecter

LDT_LIMIT equ .end - LDT - 1
