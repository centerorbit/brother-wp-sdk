; WARNING! THE METHODS IN THIS FILE ARE UNTESTED


; Asks ROM for RAM place to tell filename to load
;
; INPUT: none
; OUTPUT: 
;    * h1: Memory address to write filename to
OpenFilename:
    ld      b,03h
    ld      a,05h
    rst     30h
ret

; Called after completion of writing filname
;   to OpenFilename's assigned address.
; Uncertain if this is the true use of this call, but
;   nothing is checked after the call.
; INPUT: none, maybe de, as the address to end of file? 
; OUTPUT: none
CloseFilename:
    ld      a,08h
    rst     28h ; Done writing?
ret

; Checks if the file specified in OpenFilename exists
; This may also get the file size (and return in a)
; If it doesn't, the `c` flag will be set.
; INPUT: hl, Points to the memory address originally provided by OpenFilename
; OUTPUT: `c` flag
;Example:
;   pop  hl ; if OpenFilename is on stack
;   call FileExists ; Checks if file exists
;   jr   c,ResetAndExit ; The file doesn't, we exit
FileExists:
    ld      a,1eh ;
    rst     28h ; File Exist???
ret


; INPUT:
;   * c, the size to load
;   * hl, the address to start writing (e.g. 9008h)
;   * de, the address of the ORG of APL (e.g. 5000h)
; OUTPUT:
;   * a, will be set to 12h if load was successful
LoadApp:
    ld      b,06h
    ld      a,0bh    ; a is set to 11
    rst     28h      ; Load
ret