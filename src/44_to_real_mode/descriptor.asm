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
.cr3:    dd CR3_BASE            ; 28:CR3(PDBR)
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
.fp_save: times 108 + 4 db 0    ; FPU context storage area

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
.cr3:    dd CR3_BASE            ;* 28:CR3(PDBR)
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
.fp_save: times 108 + 4 db 0    ; FPU context storage area

;**************************************
; TSS(Task State Segment) for TASK_2
; Size 104 bytes
;**************************************
TSS_2:
.link:    dd 0
.esp0:    dd SP_TASK_2 - 512     ;*  4:esp0
.ss0:     dd DS_KERNEL           ;*  8:
.esp1:    dd 0                   ;* 12:esp1
.ss1:     dd 0                   ;* 16:
.esp2:    dd 0                   ;* 20:esp2
.ss2:     dd 0                   ;* 24:
.cr3:     dd CR3_BASE            ;* 28:CR3(PDBR)
.eip:     dd task_2              ;  32:eip(start task1 address)
.eflags:  dd 0x0202              ;  36:EFLAGS(initial eflags value)
.eax:     dd 0                   ;  40:eax
.ecx:     dd 0                   ;  44:ecx
.edx:     dd 0                   ;  48:edx
.ebx:     dd 0                   ;  52:ebx
.esp:     dd SP_TASK_2           ;  56:esp(initial stack pointer)
.ebp:     dd 0                   ;  60:ebp
.esi:     dd 0                   ;  64:esi
.edi:     dd 0                   ;  68:edi
.es:      dd DS_TASK_2           ;  72:es
.cs:      dd CS_TASK_2           ;  76:cs(code segment selector for task1)
.ss:      dd DS_TASK_2           ;  80:ss(data segment selector for task1)
.ds:      dd DS_TASK_2           ;  84:ds(data segment selector for task1)
.fs:      dd DS_TASK_2           ;  88:fs(data segment selector for task1)
.gs:      dd DS_TASK_2           ;  92:gs(data segment selector for task1)
.ldt:     dd SS_LDT              ;* 96:ldt segment selecter
.io:      dd 0                   ; 100:I/O MapBaseAddress
.fp_save: times 108 + 4 db 0     ; FPU context storage area

;**************************************
; TSS(Task State Segment) for TASK_2
; Size 104 bytes
;**************************************
TSS_3:
.link:    dd 0
.esp0:    dd SP_TASK_3 - 512     ;*  4:esp0
.ss0:     dd DS_KERNEL           ;*  8:
.esp1:    dd 0                   ;* 12:esp1
.ss1:     dd 0                   ;* 16:
.esp2:    dd 0                   ;* 20:esp2
.ss2:     dd 0                   ;* 24:
.cr3:     dd CR3_BASE            ;* 28:CR3(PDBR)
.eip:     dd task_3              ;  32:eip(start task1 address)
.eflags:  dd 0x0202              ;  36:EFLAGS(initial eflags value)
.eax:     dd 0                   ;  40:eax
.ecx:     dd 0                   ;  44:ecx
.edx:     dd 0                   ;  48:edx
.ebx:     dd 0                   ;  52:ebx
.esp:     dd SP_TASK_3           ;  56:esp(initial stack pointer)
.ebp:     dd 0                   ;  60:ebp
.esi:     dd 0                   ;  64:esi
.edi:     dd 0                   ;  68:edi
.es:      dd DS_TASK_3           ;  72:es
.cs:      dd CS_TASK_3           ;  76:cs(code segment selector for task1)
.ss:      dd DS_TASK_3           ;  80:ss(data segment selector for task1)
.ds:      dd DS_TASK_3           ;  84:ds(data segment selector for task1)
.fs:      dd DS_TASK_3           ;  88:fs(data segment selector for task1)
.gs:      dd DS_TASK_3           ;  92:gs(data segment selector for task1)
.ldt:     dd SS_LDT              ;* 96:ldt segment selecter
.io:      dd 0                   ; 100:I/O MapBaseAddress
.fp_save: times 108 + 4 db 0     ; FPU context storage area

TSS_4:
.link:    dd 0
.esp0:    dd SP_TASK_4 - 512     ;*  4:esp0
.ss0:     dd DS_KERNEL           ;*  8:
.esp1:    dd 0                   ;* 12:esp1
.ss1:     dd 0                   ;* 16:
.esp2:    dd 0                   ;* 20:esp2
.ss2:     dd 0                   ;* 24:
.cr3:     dd CR3_TASK_4          ;* 28:CR3(PDBR)
.eip:     dd task_3              ;  32:eip(start task1 address)
.eflags:  dd 0x0202              ;  36:EFLAGS(initial eflags value)
.eax:     dd 0                   ;  40:eax
.ecx:     dd 0                   ;  44:ecx
.edx:     dd 0                   ;  48:edx
.ebx:     dd 0                   ;  52:ebx
.esp:     dd SP_TASK_4           ;  56:esp(initial stack pointer)
.ebp:     dd 0                   ;  60:ebp
.esi:     dd 0                   ;  64:esi
.edi:     dd 0                   ;  68:edi
.es:      dd DS_TASK_4           ;  72:es
.cs:      dd CS_TASK_3           ;  76:cs(code segment selector for task1)
.ss:      dd DS_TASK_4           ;  80:ss(data segment selector for task1)
.ds:      dd DS_TASK_4           ;  84:ds(data segment selector for task1)
.fs:      dd DS_TASK_4           ;  88:fs(data segment selector for task1)
.gs:      dd DS_TASK_4           ;  92:gs(data segment selector for task1)
.ldt:     dd SS_LDT              ;* 96:ldt segment selecter
.io:      dd 0                   ; 100:I/O MapBaseAddress
.fp_save: times 108 + 4 db 0     ; FPU context storage area

TSS_5:
.link:    dd 0
.esp0:    dd SP_TASK_5 - 512     ;*  4:esp0
.ss0:     dd DS_KERNEL           ;*  8:
.esp1:    dd 0                   ;* 12:esp1
.ss1:     dd 0                   ;* 16:
.esp2:    dd 0                   ;* 20:esp2
.ss2:     dd 0                   ;* 24:
.cr3:     dd CR3_TASK_5          ;* 28:CR3(PDBR)
.eip:     dd task_3              ;  32:eip(start task1 address)
.eflags:  dd 0x0202              ;  36:EFLAGS(initial eflags value)
.eax:     dd 0                   ;  40:eax
.ecx:     dd 0                   ;  44:ecx
.edx:     dd 0                   ;  48:edx
.ebx:     dd 0                   ;  52:ebx
.esp:     dd SP_TASK_5           ;  56:esp(initial stack pointer)
.ebp:     dd 0                   ;  60:ebp
.esi:     dd 0                   ;  64:esi
.edi:     dd 0                   ;  68:edi
.es:      dd DS_TASK_5           ;  72:es
.cs:      dd CS_TASK_3           ;  76:cs(code segment selector for task1)
.ss:      dd DS_TASK_5           ;  80:ss(data segment selector for task1)
.ds:      dd DS_TASK_5           ;  84:ds(data segment selector for task1)
.fs:      dd DS_TASK_5           ;  88:fs(data segment selector for task1)
.gs:      dd DS_TASK_5           ;  92:gs(data segment selector for task1)
.ldt:     dd SS_LDT              ;* 96:ldt segment selecter
.io:      dd 0                   ; 100:I/O MapBaseAddress
.fp_save: times 108 + 4 db 0     ; FPU context storage area

TSS_6:
.link:    dd 0
.esp0:    dd SP_TASK_6 - 512     ;*  4:esp0
.ss0:     dd DS_KERNEL           ;*  8:
.esp1:    dd 0                   ;* 12:esp1
.ss1:     dd 0                   ;* 16:
.esp2:    dd 0                   ;* 20:esp2
.ss2:     dd 0                   ;* 24:
.cr3:     dd CR3_TASK_6          ;* 28:CR3(PDBR)
.eip:     dd task_3              ;  32:eip(start task1 address)
.eflags:  dd 0x0202              ;  36:EFLAGS(initial eflags value)
.eax:     dd 0                   ;  40:eax
.ecx:     dd 0                   ;  44:ecx
.edx:     dd 0                   ;  48:edx
.ebx:     dd 0                   ;  52:ebx
.esp:     dd SP_TASK_6           ;  56:esp(initial stack pointer)
.ebp:     dd 0                   ;  60:ebp
.esi:     dd 0                   ;  64:esi
.edi:     dd 0                   ;  68:edi
.es:      dd DS_TASK_6           ;  72:es
.cs:      dd CS_TASK_3           ;  76:cs(code segment selector for task1)
.ss:      dd DS_TASK_6           ;  80:ss(data segment selector for task1)
.ds:      dd DS_TASK_6           ;  84:ds(data segment selector for task1)
.fs:      dd DS_TASK_6           ;  88:fs(data segment selector for task1)
.gs:      dd DS_TASK_6           ;  92:gs(data segment selector for task1)
.ldt:     dd SS_LDT              ;* 96:ldt segment selecter
.io:      dd 0                   ; 100:I/O MapBaseAddress
.fp_save: times 108 + 4 db 0     ; FPU context storage area

;*****************************
; Global Descriptor Table
;*****************************
GDT:			dq  0x0000000000000000          ; NULL
.cs_kernel:		dq	0x00CF9A000000FFFF		; CODE 4G
.ds_kernel:		dq	0x00CF92000000FFFF		; DATA 4G
.cs_bit16:     dq   0x000F9A000000FFFF          ; Code Segment(16 bit)
.ds_bit16:     dq   0x000F92000000FFFF          ; Data Segment(16 bit)
.ldt			dq	0x0000820000000000			; LDT descriptor
.tss_0:             dq  0x0000890000000067      ; TSS descriptor
.tss_1:             dq  0x0000890000000067      ; TSS descripto
.tss_2:             dq  0x0000890000000067      ; TSS descriptor
.tss_3:             dq  0x0000890000000067      ; TSS descriptor
.tss_4:             dq  0x0000890000000067      ; TSS descriptor
.tss_5:             dq  0x0000890000000067      ; TSS descriptor
.tss_6:             dq  0x0000890000000067      ; TSS descriptor
.call_gate:     dq  0x0000EC0400080000          ; 386 call gate (DPL = 3, count = 4, SEL = 8)
.end:

;*********************************
; Global Descriptor Base Address
;*********************************
CS_KERNEL equ .cs_kernel - GDT
DS_KERNEL equ .ds_kernel - GDT
SS_LDT    equ .ldt       - GDT
SS_TASK_0 equ .tss_0	 - GDT
SS_TASK_1 equ .tss_1	 - GDT
SS_TASK_2 equ .tss_2	 - GDT
SS_TASK_3 equ .tss_3	 - GDT
SS_TASK_4 equ .tss_4	 - GDT
SS_TASK_5 equ .tss_5	 - GDT
SS_TASK_6 equ .tss_6	 - GDT
SS_GATE_0 equ .call_gate - GDT

GDTR: dw GDT.end - GDT - 1
      dd GDT

LDT:			dq	0x0000000000000000			; NULL
.cs_task_0:		dq	0x00CF9A000000FFFF			; CODE 4G
.ds_task_0:		dq	0x00CF92000000FFFF			; DATA 4G
.cs_task_1:		dq	0x00CFFA000000FFFF			; CODE 4G
.ds_task_1:		dq	0x00CFF2000000FFFF			; DATA 4G
.cs_task_2:		dq	0x00CFFA000000FFFF			; CODE 4G
.ds_task_2:		dq	0x00CFF2000000FFFF			; DATA 4G
.cs_task_3:		dq	0x00CFFA000000FFFF			; CODE 4G
.ds_task_3:		dq	0x00CFF2000000FFFF			; DATA 4G
.ds_task_4:		dq	0x00CFF2000000FFFF			; DATA 4G
.ds_task_5:		dq	0x00CFF2000000FFFF			; DATA 4G
.ds_task_6:		dq	0x00CFF2000000FFFF			; DATA 4G
.end:

; `| 4` means that the segment granularity is 4k
;*********************
; privillege level 0
;*********************
CS_TASK_0 equ (.cs_task_0 - LDT) | 4     ; designated task0 cs segment selecter
DS_TASK_0 equ (.ds_task_0 - LDT) | 4     ; designated task0 ds segment selecter

;*********************
; privillege level 3
;*********************
CS_TASK_0		equ	(.cs_task_0 - LDT) | 4
DS_TASK_0		equ	(.ds_task_0 - LDT) | 4
CS_TASK_1		equ	(.cs_task_1 - LDT) | 4 | 3
DS_TASK_1		equ	(.ds_task_1 - LDT) | 4 | 3
CS_TASK_2		equ	(.cs_task_2 - LDT) | 4 | 3
DS_TASK_2		equ	(.ds_task_2 - LDT) | 4 | 3
CS_TASK_3		equ	(.cs_task_3 - LDT) | 4 | 3
DS_TASK_3		equ	(.ds_task_3 - LDT) | 4 | 3
DS_TASK_4		equ	(.ds_task_4 - LDT) | 4 | 3
DS_TASK_5		equ	(.ds_task_5 - LDT) | 4 | 3
DS_TASK_6		equ	(.ds_task_6 - LDT) | 4 | 3

LDT_LIMIT equ .end - LDT - 1
