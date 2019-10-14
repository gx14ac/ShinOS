; ax register is アキュムレータ(data)
; bx register is ベースレジスタ(memory)
Test: cmp ax, 10
    je .C10
    cmp ax, 15
    je .C15
    cmp ax, 18
    je .C18
    jmp .D
.C10:
    mov bx, 1
    jmp .E
.C15:
    mov bx, 2
    jmp .E
.C18:
    mov bx, 3
    jmp .E
.D:
    mov bx, 4
    jmp .E
.E: