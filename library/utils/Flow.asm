
; Used to exit an application.
ResetAndExit:
    ld      a,0eh
    rst     28h
    ld      a,06h
    rst     28h
    ld      a,01h
    rst     30h
ret