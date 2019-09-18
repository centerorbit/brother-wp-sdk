include 'header.asm'


; Main entry point
call ClearScreen
call ShowMessage
ld bc, 100h
call Delay
call ResetAndExit
ret

; Includes must come after the main entry point of the app.
include './library/screen/BottomMenu.asm'
include './library/screen/Screen.asm'
include './library/utils/Flow.asm'
include './library/utils/String.asm'
include './library/utils/Wait.asm'
include './library/io/Keyboard.asm'


