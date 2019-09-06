
; This method will blank the entire screen.
ClearScreen:
    ld      b,01h
    ld      a,10h
    rst     10h
ret