;********************************************
; Global Descriptor Table
;********************************************
GDT:			dq	0x0000000000000000			; NULL
.cs_kernel:		dq	0x00CF9A000000FFFF			; CODE 4G
.ds_kernel:		dq	0x00CF92000000FFFF			; DATA 4G
.ldt			dq	0x0000820000000000			; LDT descriptor

;********************************************
; Local Descriptor Table
;********************************************
LDT: dq 0x0000000000000000      ; NULL
.cs_task_0: dq 0x00CF9A000000FFFF  ; CODE 4G
.ds_task_0: dq 0x00CF92000000FFFF  ; DATA 4G
.cs_task_1: dq	0x00CF9A000000FFFF ; CODE 4G
.ds_task_1: dq	0x00CF92000000FFFF ; DATA 4G

; `| 4` means that the segment granularity is 4k
CS_TASK_0 equ (.cs_task_0 - LDT) | 4 ; designated task0 cs selecter
DS_TASK_0 equ (.ds_task_0 - LDT) | 4 ; designated task0 ds selecter
CS_TASK_1 equ (.cs_task_1 - LDT) | 4 ; designated task1 cs selecter
DS_TASK_1 equ (.ds_task_1 - LDT) | 4 ; designated task1 ds selecter

LDT_LIMIT equ .end - LDT - 1

;********************************************
; TSS(Task State Segment) for TASK_0
;********************************************
TSS_0:
.link:   dd 0
.esp0:   dd SP_TASK_0 - 512
.ss0:    dd DS_KERNEL
.esp1:   dd 0
.ss1:    dd 0
.esp2:   dd 0
.ss2:    dd 0
.cr3:    dd 0
.eip:    dd 0
.eflags: dd 0
.eax:    dd 0
.ecx:    dd 0
.edx:    dd 0
.ebx:    dd 0
.esp:    dd 0
.ebp:    dd 0
.esi:    dd 0
.edi:    dd 0
.es:     dd 0
.cs:     dd 0
.ss:     dd 0
.ds:     dd 0
.fs:     dd 0
.gs:     dd 0
.ldt:    dd 0
.io:     dd 0
