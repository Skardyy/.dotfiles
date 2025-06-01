#NoEnv
#SingleInstance Force
SendMode Input

; Win+C to kill window under cursor
#c::
    MouseGetPos, , , WindowUnderMouse
    WinClose, ahk_id %WindowUnderMouse%
return
