test_and_set:
    push ebp
    mov  ebp, esp

    push eax
    push ebx

    mov eax, 0                  ; local = 0
    mov ebx, [ebp + 8]          ; global = addr
.10L:
    lock bts[ebx], eax          ; cf = TEST_AND_SET(IN_USE, 1)
    jnc  .10E                   ; if (0 == CF)
                                ;     break
.12L:
    bt [ebx], eax               ; cf = TEST(IN_USE, 1)
    jc .12L                     ; if (0 == CF)
                                ;     break
    jmp .10L                    ; }
.10E:
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp

    ret
