;---------------------
; - Variable display function.
;---------------------
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
    mov  bp, sp

    ;---------------------
    ; - Saving Register.
    ;---------------------
    push ax               ; ax(ax, al)
    push bx               ; bx is 
    push cx               ; cx is counter register.
    push dx               ; dx
    push si               ; si is source index.
    push di               ; di is destination index.

    ;---------------------
    ; - Get argments.
    ;---------------------
    mov ax, [bp+4]             ; numeric.
    mov si, [bp+6]             ; buffer address.
    mov cx, [bp+8]             ; buffer size.
         
    mov di, si                 ; di = &si. (si is source pointer.)
    add di, cx                 ; di = &di[cx -1]
    dec di                     ; decrement di.
         
    mov bx, [bp+12]       ; flags = options arg.
    
    ;---------------------
    ; - Signed handling.
    ;---------------------
    test bx, 0b0001            ; if(flags & 0x01), (test is 論理積)
.10Q: je .10E                  ; { je is break (bx == 0)
    cmp ax, 0                  ; if (val < 0)
.12Q: jge .12E                 ; { (0より小さい場合)
    or bx, 0b0010              ; bx = 2; 符号表示をさせるようにする
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
    mov bx, [bp+10]            ; bx = 基数 (2 or 8 or 16)
.30L:                          ; do
                               ; {
    mov dx, 0                  ; dx = 0

    div bx                     ; DX = DX:AX % 基数 // 余
                               ; 算術レジスタに格納される.                             
                               ; AX = DX:AX / 基数 // 商
    mov si, dx                 ; si = dx
    mov dl, byte [.ascii + si] ; DL = ASCII[DX] Dx is 余. 余をindexとしてつかう.
  
    mov [di], dl               ; *dst = DL. 文字列の代入
    dec di                     ; dst--;
         
    cmp ax, 0                  ; (ax == 0) or (ax == 0)
    loopnz .30L                ; } while (AX);
.30E:

    ;---------------------  
    ; - Remove space.  
    ;---------------------
    cmp cx, 0                  ; if(cx==0) cxのバッファサイズが０でなければ、空白を埋める.
.40Q: je .40E                  ; {
    mov al, ' '                 ; AL = ''; ''で埋める
    cmp [bp+12], word 0b0100   ; if(flags & 0x04)
.42Q: jne .42E                 ; {
    mov al, '0'                ; AL=0
.42E:                          ; }
    std                        ; DF = 1 (-方向)
                               ; ストリームの方向を逆にする
                               ; カウンタレジスタ分文字列の空白を削除する
    rep stosb                  ; while(--CX) *DI-- = '';
.40E:                          ; }
      
    ;---------------------  
    ; - Return Register.  
    ;---------------------
    pop di
    pop si
    pop dx
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