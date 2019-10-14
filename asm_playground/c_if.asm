Test: cmp ax, 3
    jae .False
.True: mov bx, 2
    jmp .End
.False: mov bx, 1
.End: