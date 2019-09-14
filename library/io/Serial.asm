
;SOME CONSTANTS FROM NASCOM BASIC.
;==============================================================

CTRLC:    EQU    03H             ; Control "C"
CTRLG:    EQU    07H             ; Control "G"
BKSP:    EQU    08H             ; Back space
LF:      EQU    0AH             ; Line feed
CS:      EQU    0CH             ; Clear screen
CR:      EQU    0DH             ; Carriage return
CTRLO:    EQU    0FH             ; Control "O"
CTRLQ:    EQU	11H             ; Control "Q"
CTRLR:    EQU    12H             ; Control "R"
CTRLS:    EQU    13H             ; Control "S"
CTRLU:    EQU    15H             ; Control "U"
ESC:     EQU    1BH             ; Escape
DEL:     EQU    7FH             ; Delete

;CONSTANTS from http://www.hd64180-cpm.de/resources/180MACRO.LIB
;ASCI REGISTERS
CNTLA0:	EQU	00H
CNTLA1:	EQU	01H
CNTLB0:	EQU	02H
CNTLB1:	EQU	03H
STAT0:	EQU	04H
STAT1:	EQU	05H
TDR0:	EQU	06H
TDR1:	EQU	07H
RDR0:	EQU	08H
RDR1:	EQU	09H

.macro in0a
    db 0EDh, 038h, %%1
.endm

.macro out0a
    db 0EDh, 039h, %%1
.endm



ConfigureSerial:
; Note, the prescaler is 111 (external clock) on reset.  
;This changes it to the fastest internal baud rate. 
; Clock rate is 12.27Mhz (Clock speed) / divisor for 001 = 12270000/320.
; It's 38343, close to 38400.
; My crystal is 12.27
; Trying a different divisor to get slower signal.
;
    ld a,0
    ld b,a
    ld c,a
    ld a,01100100b
    out0a CNTLA0    ;   out (CNTLA0),a
;    ld a,00000001b  ; 19200bps ; Didn't work for input.
    ld a,00000010b  ; 9600bps
;    ld a,00001110b  ; 150bps
    out0a CNTLB0    ;   out (CNTLB0),a
    
    ld a,01100100b
    out0a CNTLA1    ;    out (CNTLA1),a
    ld a,00000010b  ; 9600bps
;    ld a,00001010b  ; 2400bps
    out0a CNTLB1    ;    out (CNTLB1),a
ret

; THIS IS THE BYTE OUTPUT FUNCTION FOR
; THE NASCOM BASIC (and presumably monitor, wherever that is!)
MONOUT: 
        CALL OutSer0           ; output a char
        CALL OutSer1           ; output a char
        call ShortDelay
        ret

   ; My assembler won't take the new mnemonics.
OutSer0:
    out0a (TDR0)
    ret
OutSer1:
    out0a (TDR1)
    ret