#NoEnv
#SingleInstance Force
SendMode Input

; Store window IDs and visibility state for our managed terminals
TerminalM_HWND := 0
TerminalN_HWND := 0
TerminalM_Hidden := false
TerminalN_Hidden := false
term := A_Desktop . "\wezterm\target\release\wezterm-gui.exe"
; editor := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Neovide.lnk"
editor := term

; Win+M hotkey
#m::
    ToggleTerminal("M")
return

; Win+N hotkey  
#n::
    ToggleTerminal("N")
return

; Just launch
#Enter::
run %term%
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

GetHWNDFromPID(PID) {
  Loop {
    WinWait, ahk_pid %PID%
    WinGet, CurrentHWND, ID, ahk_pid %PID%
    WinGetTitle, Title, ahk_id %CurrentHWND%

    if (Title != "") {
        return CurrentHWND
    }
  }
}

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
        WinMinimize, ahk_id %OtherHWND%
        if (Key = "M") {
            TerminalN_Hidden := true
        } else if (Key = "N") {
            TerminalM_Hidden := true
        }
    }
    
    ; Check if our terminal exists (either visible or hidden)
    if (!CurrentHWND) {
        ; Terminal doesn't exist - create new one
        if (key = "N") {
          Run, %term%,,, NewPID  ; Get the PID of the newly launched wezterm
        } else {
          Run, %editor%,,, NewPID  ; Get the PID of the newly editor
        }

        NewHWND := GetHWNDFromPID(NewPID)
        WinActivate, ahk_id %NewHWND%
        
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
        WinMinimize, ahk_id %CurrentHWND%
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
