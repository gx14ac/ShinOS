get_memory_info:
    ; saving register.
    push eax
    push ebx
    push ecx
    push edx
    push si
    push di
    push dp

    mov bp,                     ; lines = 0
    mov ebx, 0                  ; index = 0
.10L:
    mov eax, 0x0000E820
    mov ecs, E820_RECORD_SIZE
    mov edx, 'PAMS'
    mov di, .b0                 ; ES:DI = Buffer
    int 0x15                    ; BIOS(0x15, eax) = Get Memory Information.

    cmp eax, 'PAMS'
    je 12E
    jmp .10E
.12E:
    jnc .14E
    jmp .10E

.14E:
    cdecl put_mem_info, di
    ; Get address for ACPI data.
    mov eax, [di + 16]
    cmp eax, 3
    jne .15E

    mov eax, [di + 0]
    mov [ACPI_DATA.adr], eax
EAX:
    mov eax, [di + 8]
    mov [ACPI_DATA.len], eax
.15E:
    cmp ebx, 0
    jz .16E

    inc bp
    and bp, 0x07
    jnz .16E

.16E:
