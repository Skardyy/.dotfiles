#NoEnv
#SingleInstance Force
SendMode Input

; Store window IDs and visibility state for our managed terminals
TerminalM_HWND := 0
TerminalN_HWND := 0
TerminalM_Hidden := false
TerminalN_Hidden := false

; Win+M hotkey
#m::
    ToggleTerminal("M")
return

; Win+N hotkey  
#n::
    ToggleTerminal("N")
return

; Win+Shift+M hotkey - reset M terminal vars
#+m::
TerminalM_HWND := 0
TerminalM_Hidden := false
return

; Win+Shift+N hotkey - reset N terminal vars
#+n::
TerminalN_HWND := 0
TerminalN_Hidden := false
return

ToggleTerminal(Key) {
    global
    
    ; Get current window handle and state based on key
    if (Key = "M") {
        CurrentHWND := TerminalM_HWND
        OtherHWND := TerminalN_HWND
        CurrentHidden := TerminalM_Hidden
        OtherHidden := TerminalN_Hidden
    } else if (Key = "N") {
        CurrentHWND := TerminalN_HWND
        OtherHWND := TerminalM_HWND
        CurrentHidden := TerminalN_Hidden
        OtherHidden := TerminalM_Hidden
    }
    
    ; Hide the other terminal if it exists and is not hidden
    if (OtherHWND && !OtherHidden) {
        WinHide, ahk_id %OtherHWND%
        if (Key = "M") {
            TerminalN_Hidden := true
        } else if (Key = "N") {
            TerminalM_Hidden := true
        }
    }
    
    ; Check if our terminal exists (either visible or hidden)
    if (!CurrentHWND) {
        ; Terminal doesn't exist - create new one
        Run, wt.exe
        Sleep, 500  ; Give it time to open
        
        ; Get the newest terminal window
        WinGet, NewHWND, ID, A  ; Get active window ID
        
        ; Store the new window handle
        if (Key = "M") {
            TerminalM_HWND := NewHWND
            TerminalM_Hidden := false
        } else if (Key = "N") {
            TerminalN_HWND := NewHWND
            TerminalN_Hidden := false
        }
        
    } else if (!CurrentHidden && WinActive("ahk_id " . CurrentHWND)) {
        ; Our terminal is active and visible - hide it
        WinHide, ahk_id %CurrentHWND%
        if (Key = "M") {
            TerminalM_Hidden := true
        } else if (Key = "N") {
            TerminalN_Hidden := true
        }
    } else if (CurrentHidden) {
        ; Our terminal is hidden - show and activate it
        WinShow, ahk_id %CurrentHWND%
        WinActivate, ahk_id %CurrentHWND%
        if (Key = "M") {
            TerminalM_Hidden := false
        } else if (Key = "N") {
            TerminalN_Hidden := false
        }
    } else {
        ; Our terminal exists but is not active - just activate it
        WinActivate, ahk_id %CurrentHWND%
    }
}
