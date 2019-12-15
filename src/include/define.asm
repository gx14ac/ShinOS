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
