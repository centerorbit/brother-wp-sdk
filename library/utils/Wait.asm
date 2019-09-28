; This file contains methods for time/pauses
if ?Wait.asm == 0
Wait.asm:

; TODO: This method could use some model directives to adjust the loop
;    based on various model clock speeds.
; TODO: Should also not hard-code bc, and let callers "pass in" bc to make
;    the delay configurable.
; 
; Thanks to: http://www.paleotechnologist.net/?p=2589
; This will cause a ~10 sec or so delay (depending on clock speed)
Delay:
    push bc
    push de
    ; ld bc, 100h            ;Loads BC with hex 100
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
    pop de
    pop bc
ret                     ;Return from call to this subroutine


ShortDelay_Length: DEFW 90
ShortDelay:
    ;fine-tuning a delay for 9600 baud serial
    push af
    push bc
    ld a,255
    ld bc, (ShortDelay_Length) ; 20 was too short
    Outer2:
        nop
        nop
        nop
        dec bc                  ;Decrements BC
        ld a, b                 ;Copies B into A
        or c                    ;Bitwise OR of C with A (now, A = B | C)
    jp nz, Outer2            ;Jumps back to Outer: label if A is not zero
    pop bc
    pop af  
    ret                     ;Return from call to this subroutine


; Will lock up the typewriter
; I used this before I found the Delay code
InfiniLoop:
    ld  b, 00h
    ld  a,b
    cp  00h
jr  z,InfiniLoop

endif