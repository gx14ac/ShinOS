Test: mov cx, 0
.L: cmp cx, 5
    jge .E
    ; do something
    inc cx
    jmp .L
.E: