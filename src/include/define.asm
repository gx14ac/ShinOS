BOOT_LOAD equ 0x7C00                    ; Start Boot Program position.
BOOT_SIZE equ (1024 * 8)                ; Boot Code Size.
SECT_SIZE equ (512)                     ; Sector Size.
BOOT_SECT equ (BOOT_SIZE / SECT_SIZE)   ; Boot Program to Sector Count.
