include 'header.asm'

; Main entry point
call ClearScreen
call ShowMessage
call Delay
call ResetAndExit
ret

; Includes must come after the main entry point of the app.
include './library/screen/BottomMenu.asm'
include './library/screen/Screen.asm'
include './library/utils/Flow.asm'
include './library/utils/Wait.asm'

ShowMessage:
    push    bc
    push    de
    push    hl
    call    ClearMessageBar
    call    GetBottomMenuPtr
    ld      bc,Message
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
    jr      z,FlushAndExit
    call    GetBottomMenuPtr
    ld      a,(bc)
; This loop inverts the text to be a yellow bar with black writing
; Start Invert
    ld      b,5bh ; 91
Again:
    ld      (hl),a
    inc     hl
    inc     hl
    djnz    Again    ;loops 91 times (cause of b)
; End Invert
    ld      de,00b6h
FlushAndExit:
    ld      c,e
    ld      b,d
    pop     hl
    call    FlushMenu ; or redraw?
    pop     hl
    pop     de
    pop     bc
ret     

Message:
    db $0e, $00, $90, $00 ; Message bar, yes. Offset of some sort
    db "Hello"
    db $00 ; spaces are nulls for message bar
    db "World!"
    db $ff ; String terminator