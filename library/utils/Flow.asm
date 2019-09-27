if ?Flow.asm == 0
Flow.asm:


HandoffToLoadedApp:
    ld      a,0eh
    rst     28h
    ld      a,06h
    rst     28h
    jp      9008h
ret

; Used to exit an application.
ResetAndExit:
    ld      a,0eh
    rst     28h
    ld      a,06h
    rst     28h
    ld      a,01h
    rst     30h
ret

endif
