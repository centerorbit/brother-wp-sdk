org 5000h

; write the header
db $81, $c1, $01, $01, $00, $00, $42, $52

call ClearScreen
call ShowMessage
call Delay
;call BlankMessageBar

call ResetAndExit
ret

ResetAndExit:
    ld      a,0eh
    rst     28h
    ld      a,06h
    rst     28h
    ld      a,01h
    rst     30h
ret

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

BlankMessageBar:
    call ClearMessageBar
    ld      hl, 0e00h
    ld      de, 00b6h
    ld      c,e
    ld      b,d
    call FlushMenu
ret

ClearScreen:
    ld      b,01h
    ld      a,10h
    rst     10h
ret

; Thanks to: http://www.paleotechnologist.net/?p=2589
; This will cause a ~10 sec or so delay (depending on clock speed)
Delay:
    ld bc, 100h            ;Loads BC with hex 100
    Outer:
        ld de, 1000h            ;Loads DE with hex 1000
            Inner:
                dec de                  ;Decrements DE
                ld a, d                 ;Copies D into A
                or e                    ;Bitwise OR of E with A (now, A = D | E)
            jp nz, Inner            ;Jumps back to Inner: label if A is not zero
        dec bc                  ;Decrements BC
        ld a, b                 ;Copies B into A
        or c                    ;Bitwise OR of C with A (now, A = B | C)
    jp nz, Outer            ;Jumps back to Outer: label if A is not zero
ret                     ;Return from call to this subroutine

; Not currently used, but will lock up the typewriter
; Used this before I found the Delay
InfiniLoop:
    ld  b, 00h
    ld  a,b
    cp  00h
jr  z,InfiniLoop

Message:
    db $0e, $00, $90, $00 ; Message bar, yes. Offset of some sort
    db "Hello"
    db $00 ; spaces are nulls for message bar
    db "World!"
    db $ff ; String terminator