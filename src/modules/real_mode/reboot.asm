reboot:
    ;; Show Message.
    cdecl putc, .s0             ; Show Rebooting Message.

    ;; Waiting for keyboard.
.10L:                           ; do
                                ; {
    mov ah, 0x10                ; // Wating for input keyboard.
    int 0x16                    ; // AL = BIOS(0x16, 0x10)
                                ;
    cmp al, ''                  ; ZF == AL == '';
    jne .10L                    ; } while(ZF)

    ;; Return Space.
    cdecl putc, .s1

    ;; Reboot.
    int 0x19                    ; BIOS(0x19); reboot()

    ;; Character Data.
.s0 db 0x0A, 0x0D, "Push SPACE key to reboot...", 0
.s1 db 0x0A, 0x0D, 0x0A, 0x0D, 0
