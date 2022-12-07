SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenWindows, On
SetTitleMatchMode 2
#WinActivateForce
#Persistent

Pause

;Hotkeys
;# win
;! alt
;^ ctrl


;#v::
  ;Run Ditto /Open
;Return

Home::Reload

WinMinimize
ToggleWinMinimize(TheWindowTitle)
{
SetTitleMatchMode,2
DetectHiddenWindows, Off
IfWinActive, %TheWindowTitle%
{
WinHide, %TheWindowTitle%
}
Else
{
WinShow, %TheWindowTitle%
}
Return
}
ToggleWinMinimize("Edge")
Pause

^!W::ToggleWinMinimize("Edge")

^!P::
Pause
return

OnClipboardChange:
    if(A_IsPaused) {
        return
    }
	result :=  RegExReplace(Clipboard,"\[(.*?)\]")
	if result
		Clipboard := result
	return

	
;`::
;Send {# d}
;#e::run dopus

#e::
Run %USERPROFILE%\Documents
return


^!N::Run "Notepad3.exe"


;Sleep, shutdown, hibernate

;^!S::DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 1, "Int", 1)
^!S::Shutdown, 5
;^!S::DllCall("PowrProf\SetSuspendState", "int", 1, "int", 1, "int", 1)

^!R::Shutdown, 6

;`::^v

;#i::Run, control

#F5::Run, narrator.exe
#F4::WinGetClass, Clipboard, A
;escape::!F4

;#c::run %USERPROFILE%\Documents\AHK\x11.ahk"

;Tab::
;Send {`` down}
;Send {`` up}

#IfWinActive ahk_exe Tabby.exe
^L::
Send cls{Enter}
return

#IfWinActive

#if !WinActive("Program Manager ahk_class Progman ahk_exe explorer.exe")
^!D::
{
	WinGetActiveStats, title, w, h, x, y

	WinActivate, Program Manager ahk_class Progman ahk_exe explorer.exe
	Send {f5}

	WinActivate, %title%
	return
}

#ifWinActive Program Manager ahk_class Progman ahk_exe explorer.exe
~^!D::return
#if 

WinWait, ahk_exe WDADesktopService.exe WinGet, id, id, ahk_exe WDADesktopService.exe WinSet, ExStyle, ^0x80, ahk_id %id% return
