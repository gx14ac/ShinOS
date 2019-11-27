;**************************
; Read Sector
; *************************
; ** usage : word read_lba(drive, lba, sect, dst)
; ** args:
;     ** drive : drive struct address
;     ** lba   : lba
;     ** sect  : read only size for number
;     ** dst   : to reading address
; ** return:
;        read sector number
;**************************
lba_chs:
    push bp
    mov  bp, sp

    push si

    mov si, [bp + 4]            ; si = drive info

    ; LBA -> CHS
    mov   ax, [bp + 6]
    cdecl lba_chs, si, ,chs, ax

    mov al, [si + drive.no]
    mov [.chs + drive.no], al

    cdecl read_chs, .chs, word[bp + 8], word[bp + 10]

    pop si

    mov sp, bp
    pop bp

    ret

ALIGN 2
.chs: times drive size db 0
