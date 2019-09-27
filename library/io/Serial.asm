include './library/utils/Wait.asm'

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

; in0a: macro arg1
;     db 0EDh, 038h, arg1
; endm

out0a: macro arg1
    db 0EDh, 039h, arg1
endm

; Note, the prescaler is 111 (external clock) on reset.  
;This changes it to the fastest internal baud rate. 
; Clock rate is 12.27Mhz (Clock speed) / divisor for 001 = 12270000/320.
; It's 38343, close to 38400.
; My crystal is 12.27
; Trying a different divisor to get slower signal.
;
ConfigureSerialChannel0:
    
    ; See page 125 of z8018x User Manual
    ; Bit 7: Multi-Processor Communication mode
    ; Bit 6: Receiver Enabled
    ; Bit 5: Transmit Enabled
    ; Bit 4: Request to Send
    ; Bit 3: Error Flag Reset
    ; Bit 2-0: Data format
    ; 110 = 8-bit + parity + 1 stop
    ; Non-multi, Receive On, Transmit On, No Req to Send, Reset Error Flag, 8-bit+parity+1stop
    ld a,01100110b
;     ;db 0EDh, 039h, CNTLA0    ;   
;     out (CNTLA0),a
    out0a CNTLA0    ;   out (CNTLA0),a

;     ; Last 3 bits are Speed Select
; ;    ld a,00000000b  ; 38400bps
; ;    ld a,00000001b  ; 19200bps
; ;    ld a,00000010b  ; 9600bps
; ;    ld a,00000011b  ; 4800bps
; ;    ld a,00000100b  ; 2400bps
; ;    ld a,00000101b  ; 1200bps
; ;    ld a,00000110b  ; 600bps

    ld a,00000010b  ; 9600bps
;     ;db 0EDh, 039h, CNTLB0    ;   
;     out (CNTLB0),a
    out0a CNTLB0
ret

; ConfigureSerialChannel1:
;     ld a,01100100b
;     out0a, CNTLA1    ;    out (CNTLA1),a

;     ld a,00000010b  ; 9600bps
;     out0a, CNTLB1    ;    out (CNTLB1),a
; ret

; THIS IS THE BYTE OUTPUT FUNCTION FOR
; THE NASCOM BASIC (and presumably monitor, wherever that is!)
MONOUT: 
        CALL OutSer0           ; output a char
        ; CALL OutSer1           ; output a char
        ; out (TDR0),a
        ;db 0EDh, 039h, TDR0        ; output a char
        ; call  OutSer1           ; output a char
ret

   ; My assembler won't take the new mnemonics.
OutSer0:
    out0a TDR0
    call ShortDelay
ret

OutSer1:
    out0a TDR1
ret

