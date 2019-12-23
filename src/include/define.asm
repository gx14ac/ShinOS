BOOT_LOAD        equ 0x7C00                    ; Start Boot Program position
BOOT_SIZE        equ (1024 * 8)                ; Boot Code Size
BOOT_SECT        equ (BOOT_SIZE / SECT_SIZE)   ; Boot Program to Sector Count
BOOT_END         equ (BOOT_LOAD + BOOT_SIZE)

SECT_SIZE        equ (512)                     ; Sector Size
E820_RECORD_SIZE equ 20                        ; Memory Size

KERNEL_LOAD      equ 0x0010_1000               ; Kernel load addr
KERNEL_SIZE      equ (1024 * 8)                ; Kernel size
KERNEL_SECT      equ (KERNEL_SIZE / SECT_SIZE)

VECT_BASE        equ 0x0010_0000               ; 0010_0000:0010_07FF

STACK_BASE       equ 0x0010_3000               ; task dedicated stack area
STACK_SIZE       equ 1024                      ; size per stack(0x400)

SP_TASK_0        equ STACK_BASE + (STACK_SIZE * 1) ; 0x0010_3400
SP_TASK_1        equ STACK_BASE + (STACK_SIZE * 2) ; 0x0010_3800
SP_TASK_2        equ STACK_BASE + (STACK_SIZE * 3) ; 0x0010_4200
SP_TASK_3        equ STACK_BASE + (STACK_SIZE * 4) ; 0x0010_4600
SP_TASK_4        equ STACK_BASE + (STACK_SIZE * 5) ; 0x0010_5000
SP_TASK_5        equ STACK_BASE + (STACK_SIZE * 6) ; 0x0010_5400
SP_TASK_6        equ STACK_BASE + (STACK_SIZE * 7) ; 0x0010_5800

CR3_BASE         equ 0x0010_5000 ; page transfer table : designated task 3

CR3_TASK_4       equ 0x0020_0000 ; page transfer table 4
CR3_TASK_5       equ 0x0020_2000 ; page transfer table 5
CR3_TASK_6       equ 0x0020_4000 ; page transfer table 6

PARAM_TASK_4      equ 0x0010_8000 ; draw parameter : designated task4
PARAM_TASK_5      equ 0x0010_9000 ; draw parameter : designated task5
PARAM_TASK_6      equ 0x0010_A000 ; draw parameter : designated task6

;************************************************************************
;	disk image
;************************************************************************
;(SECT/SUM)  file img
;                       ____________
;( 16/  0)   0000_0000 |       (8K) | boot
;                      =            =
;                      |____________|
;( 16/ 16)   0000_2000 |       (8K) | kernel
;                      =            =
;                      |____________|
;(256/ 32)   0000_4000 |     (128K) | FAT-1
;                      |            |
;                      |            |
;                      =            =
;                      |____________|
;(256/288)   0002_4000 |     (128K) | FAT-2
;                      |            |
;                      |            |
;                      =            =
;                      |____________|
;( 32/544)   0004_4000 |      (16K) | root directory field
;                      |            | (32 sector /512entry)
;                      =            =
;                      |____________|
;(   /576)   0004_8000 |            | data field
;                      |            |
;                      =            =
;                      |            |
;                      |____________|
;(   /640)   0005_0000 |////////////|
;                      |            |

FAT_SIZE			equ		(1024 * 128)	; FAT-1/2
ROOT_SIZE			equ		(1024 *  16)	; root directory field

ENTRY_SIZE			equ		32				; entry size

FAT_OFFSET			equ		(BOOT_SIZE + KERNEL_SIZE)
FAT1_START			equ		(KERNEL_SIZE)
FAT2_START			equ		(FAT1_START + FAT_SIZE)
ROOT_START			equ		(FAT2_START + FAT_SIZE)
FILE_START			equ		(ROOT_START + ROOT_SIZE)

; file type
ATTR_READ_ONLY		equ		0x01
ATTR_HIDDEN         equ		0x02
ATTR_SYSTEM		equ		0x04
ATTR_VOLUME_ID		equ		0x08
ATTR_DIRECTORY		equ		0x10
ATTR_ARCHIVE		equ		0x20
