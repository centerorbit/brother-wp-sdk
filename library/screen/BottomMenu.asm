
; Used to clear out message bar
BlankMessageBar:
    call ClearMessageBar
    ld      hl, 0e00h
    ld      de, 00b6h
    ld      c,e
    ld      b,d
    call FlushMenu
ret


GetBottomMenuPtr: ; loads ptr to hl
    push    af
    push    bc
    ld      a,05h
    ld      b,00h
    rst     30h
    pop     bc
    pop     af
ret

FlushMenu:
    push    af
    push    de
    push    hl
    ex      de,hl
    call    GetBottomMenuPtr
    ld      a,13h
    rst     10h
    pop     hl
    pop     de
    pop     af
ret

ClearMessageBar:
    push    bc
    push    de
    push    hl
    call    GetBottomMenuPtr
    ex      de,hl
    call    GetBottomMenuPtr
    inc     de ; de is no +1 of hl
    ld      (hl),00h ; write 00 to hl
    ld      bc,0111h ; set max to 111
    ldir    ; Now loop, wiping everything
    pop     hl
    pop     de
    pop     bc
ret