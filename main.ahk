SendMode("Input")
SetWorkingDir(A_ScriptDir)
DetectHiddenWindows(true)
SetTitleMatchMode(2)
#WinActivateForce
Persistent

;Hotkeys
;# win
;! alt
;^ ctrl

Home::Reload()

ToggleWinMinimize(TheWindowTitle)
{
SetTitleMatchMode(2)
DetectHiddenWindows(false)
if WinActive(TheWindowTitle)
{
WinHide(TheWindowTitle)
}
Else
{
WinShow(TheWindowTitle)
}
Return
}

^!W::ToggleWinMinimize("Edge")

^!N::Run("`"Notepad3.exe`"")

^!S::Shutdown(5)

^!R::Shutdown(6)

#F5::Run("narrator.exe")
#F4::A_Clipboard := WinGetClass("A")

#e::
{
USERPROFILE := EnvGet("USERPROFILE")
Run(USERPROFILE "\Documents")
return
}

^!x::Run "C:\Users\dmani\scoop\apps\xkill\current\XKill.exe"

+PrintScreen::
{
Run "C:\Users\dmani\scoop\apps\fscapture\current\FSCapture.exe"
}

^!+t::
{
    WinSetAlwaysOnTop -1, "A"
}

^!b::Run "http://"
^!t::Run "C:\Users\dmani\scoop\apps\contour\current\contour.exe"
^!i::Run "ms-settings"

^+!d::Run "C:\Users\dmani\scoop\apps\landrop\current\LANDrop.exe"

