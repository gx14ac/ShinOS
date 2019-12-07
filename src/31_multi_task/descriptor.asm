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
