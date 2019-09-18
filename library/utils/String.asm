
; To pass in the beginning pointer of a message,
;  use the following:
; ld bc,Message
; String terminates with `db $ff`,
;  and spaces are `db $00` 
ShowMessage:
    push    de
    push    hl
    call    ClearMessageBar
    call    GetBottomMenuPtr
; Formatting and offset loading?
    ld      a,(bc) ; Loading &0e into a
    ld      d,a ; d = &0e
    inc     bc ; now points to: 00
    ld      a,(bc); Loads &00 into a
    ld      e,a ; Moves &00 to e
    inc     bc ; Point to &90
    push    de ; Puts 0e00 onto stack
    push    bc ; addr of string start onto stack
; To here
    ld      de,0000h ; de reset to 0
WriteString:
    inc     hl ; Our bottom message pointer
    inc     bc ; moves to: &00
    ld      a,(bc) ; a is now &00
    cp      0ffh ; looking for ff (our terminator)
    jr      z,EndOfString ; If we do hit the terminator;
    ld      (hl),a ; hl
    inc     hl ; inc hl once, because we inc again at begining of loop
    inc     de ; inc de twice
    inc     de
    jr      WriteString
EndOfString:
    pop     bc
    ld      a,(bc)
    cp      00h
    jr      z,FlushAndReturn
    call    GetBottomMenuPtr
    ld      a,(bc)
; This loop inverts the text to be a yellow bar with black writing
    ld      b,5bh ; 91
InvertText:
    ld      (hl),a
    inc     hl
    inc     hl
    djnz    InvertText ;loops 91 times (cause of b)
; End Invert
    ld      de,00b6h
FlushAndReturn:
    ld      c,e
    ld      b,d
    pop     hl
    call    FlushMenu ; or redraw?
    pop     hl
    pop     de
ret