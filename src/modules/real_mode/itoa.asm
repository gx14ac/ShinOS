itoa:
    ;---------------------
    ; - Create Stack Frame.
    ;---------------------
                          ; +12 | flag.
                          ; +10 | base.
                          ; +8  | buffer size.
                          ; +6  | buffer address.
                          ; +4  | numeric.
                          ; +2  | return value.
                          ; +0  | base value.
    push bp
    mov bp, sp

    ;---------------------
    ; - Saving Register.
    ;---------------------
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ;---------------------
    ; - Get argments.
    ;---------------------
    mov ax, [bp+4]             ; val = numeric.
    mov bx, [bp+6]             ; dst = buffer address.
    mov cx, [bp+8]             ; size = remaining buffer size.
         
    mov di, si                 ; last buffer.
    add di, cx                 ; dst = &dst[size -1]
    dec di                     ;
         
    mov bx, word [bp+12]       ; flags = options.
    
    ;---------------------
    ; - Signed handling.
    ;---------------------
    test bx, 0b0001            ; if(flags & 0x01)
.10Q: je .10E                  ; {
    cmp ax, 0                  ; if (val < 0)
.12Q: jge .12E                 ; {
    or bx, 0b0010              ; flags |= 2; 符号表示
.12E:                          ; }
.10E:                          ; }

    ;---------------------
    ; - Sign output judgment.
    ;---------------------
    test bx, 0b0010            ; if(flags & 0x02)
.20Q: je .20E                  ; {
    cmp ax, 0                  ; if(val < 0)
.22Q: jge .22F                 ; {
    neg ax                     ;     val *=-1; // 符号反転
    mov [si], byte '-'         ;     dst ='-'  // 符号表示
    jmp .22E                   ; }
.22F:                          ; else
                               ; {
    mov [si], byte '+'         ; *dst = '+';
.22E:                          ; }
    dec cx                     ; size --; // 残りバッファサイズの計算
.20E:                          ; }

    ;---------------------
    ; - translate ascii.
    ;---------------------
    mov bx, [bp+10]            ; bx = 基数
.30L:                          ; do
                               ; {
    mov dx, 0                  ;
    div bx                     ; DX = DK:AK % 基数
                               ; AX = DX:AL / 基数
    mov si, dx                 ; // Reference Table.
    mov dl, byte [.ascii + si] ; DL = ASCII[DX]
  
    mov [di], dl               ; *dst = DL;
    dec di                     ; dst--;
         
    cmp ax, 0                  ;
    loopnz .30L                ; } while (AX);
.30E:

    ;---------------------  
    ; - Remove space.  
    ;---------------------  
    cmp cx, 0  
.40Q: je .40E                  ; {
    mov al, ''                 ; AL = ''; ''で埋める
    cmp [bp+12], word 0b0100   ; if(flags & 0x04)
.42Q: jne .42E                 ; {
    mov al, '0'                ; AL=0
.42E:                          ; }
    std                        ; DF = 1 (-方向)
    rep stosb                  ; while(--CX) *DI-- = '';
.40E                           ; }
      
    ;---------------------  
    ; - Return Register.  
    ;---------------------
    pop di
    pop si
    pop cx
    pop bx
    pop ax

    ;---------------------  
    ; - Remove Stack Frame.  
    ;---------------------

    mov sp, bp
    pop bp
    ret
.ascii db "0123456789ABCDEF"   ; transfer table.