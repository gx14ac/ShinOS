power_off:
    push	ebp
    mov	ebp, esp

    push eax
    push ebx

    ;*****************
    ; disable paging
    ;*****************
    mov	eax, cr0
    and	eax, 0x7FFF_FFFF    ; CR0 &= -PG
    mov	cr0, eax
    jmp	$ + 2               ; FLUSH()

    mov	eax, [0x7C00 + 512 + 4] ; eax = ACPI Addr
    mov	ebx, [0x7C00 + 512 + 8] ; ebx = length
    cmp	eax, 0                  ; if (0 == eax)
    je      .10E                    ; break

    ; find RSDT
    cdecl    acpi_find, eax, ebx, 'RSDT' ; eax = acpi_find('RSDT')
    cmp	 eax, 0                      ; if (0 == eax)
    je       .10E                        ; break

    ; find FACP Table
    cdecl   find_rsdt_entry, eax, 'FACP' ; eax = find_rsdt_entry('FACP')
    cmp	eax, 0                       ; if(0 = eax)
    je      .10E                         ; break

    mov	ebx, [eax + 40]     ; Get DSDT Address
    cmp	ebx, 0              ; if(0 == DSDT) // get DSDT Addr
    je      .10E                ; break

    mov	ecx, [eax + 64]     ; get ACPI register
    mov	[PM1a_CNT_BLK], ecx ; PM1a_CNT_BLK = FACP.PM1b_CNT_BLK

    mov	ecx, [eax + 68]     ; get ACPI register
    mov	[PM1b_CNT_BLK], ecx ; PM1a_CNT_BLK = FACP.PM1b_CNT_BLK

    ;********************
    ; Find S5 namespace
    ;********************
    mov	ecx, [ebx + 4]              ; ecx = DSDT.Length // Data Length
    sub	ecx, 36                     ; ecx -= 36
    add	ebx, 36                     ; ebx += 36
    cdecl   acpi_find, ebx, ecx, '_S5_' ; eax = acpi_find('_S5_')
    cmp	eax, 0                      ; if(0 == eax)
    je      .10E                        ; break

    add	eax, 4                      ; eax = head element
    cdecl   acpi_package_value, eax     ; eax = package data
    mov	[S5_PACKAGE], eax           ; S5_PACKAGE = eax
.10E:
    mov	eax, cr0            ; set the PG bit
    or	eax, (1 << 31)          ; CR0 |= PG
    mov	cr0, eax
    jmp	$ + 2               ; FLUSH()

    ;***********************
    ; get the ACPI register
    ;***********************
    mov	edx, [PM1a_CNT_BLK] ; edx = FACP.PM1a_CNT_BLK
    cmp	edx, 0              ; if(0 == edx)
    je      .20E                ; break

    ;***********************
    ; show count down timer
    ;***********************
    cdecl   draw_str, 38, 14, 0x020F, .s3 ; draw_str()
    cdecl   wait_tick, 100
    cdecl   draw_str, 38, 14, 0x020F, .s2
    cdecl   wait_tick, 100
    cdecl   draw_str, 38, 14, 0x020F, .s1
    cdecl   wait_tick, 100

    ;**************************
    ; configure PM1a_CNT_BLK
    ;**************************
    movzx	ax, [S5_PACKAGE.0]  ; // PM1a_CNT_BLK
    shl	ax, 10              ; ax = SLP_TYpx
    or      ax, 1 << 13         ; ax |= SLP_EN
    out	dx, ax              ; out(PM1a_CNT_BLK, AX)

    ;*************************
    ; check the PM1b_CNT_BLK
    ;*************************
    mov	edx, [PM1b_CNT_BLK] ; edx = FACP.PM1a_CNT_BLK
    cmp	edx,0               ; if (0 == EDX)
    je      .20E                ; break

    ;*************************
    ; configure PM1b_CNT_BLK
    ;*************************
    movzx	ax, [S5_PACKAGE.1]  ; PM1b_CNT_BLK
    shl	ax, 10              ; ax = SLP_TYPx
    or	ax, 1 << 13             ; ax = SLP_EN
    out	dx, ax              ; out(PM1b_CNT_BLK, x)
.20E:
    ;*************************
    ; waiting for poweroff
    ;*************************
    cdecl    wait_tick, 100

    ;******************
    ; failure message
    ;******************
    cdecl    draw_str, 38, 14, 0x020F, .s4 ; draw_str()

.s0: db "Poweroff...", 0
.s1: db "1", 0
.s2: db "2", 0
.s3: db "3", 0
.s4: db "Failed to Poweroff", 0

ALIGN 4. db 0
PM1a_CNT_BLK: dd 0
PM1b_CNT_BLK: dd 0
S5_PACKAGE:
.0: db 0
.1: db 0
.2: db 0
.3: db 0
