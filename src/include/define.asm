BOOT_LOAD        equ 0x7C00                    ; Start Boot Program position
BOOT_SIZE        equ (1024 * 8)                ; Boot Code Size
SECT_SIZE        equ (512)                     ; Sector Size
BOOT_SECT        equ (BOOT_SIZE / SECT_SIZE)   ; Boot Program to Sector Count
E820_RECORD_SIZE equ 20                        ; Memory Size
KERNEL_LOAD      equ 0x0010_1000               ; Kernel load addr
KERNEL_SIZE      equ (1024 * 8)                ; Kernel size
BOOT_END         equ (BOOT_LOAD + BOOT_SIZE)
BOOT_SECT        equ (BOOT_SIZE / SECT_SIZE)
KERNEL_SECT      equ (KERNEL_SIZE / SECT_SIZE)
