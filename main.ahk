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

^!N::Run("C:\Users\Dan Kendall\OneDrive\Documents\txt\ends.txt")

;^!S::Shutdown(5)

^!s::
{
    DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
    return
}

^!R::Shutdown(6)

#F5::Run("narrator.exe")
#F4::A_Clipboard := WinGetClass("A")

#e::
^!e::
{
USERPROFILE := EnvGet("USERPROFILE")
Run(USERPROFILE "\Documents")
return
}

^!l::
{
    DllCall("LockWorkStation")
    return
}

^!x::Run "C:\Users\Dan Kendall\scoop\apps\xkill\current\XKill.exe"

+PrintScreen::
{
Run "C:\Users\Dan Kendall\scoop\apps\fscapture\current\FSCapture.exe"
}

^!+t::
{
    WinSetAlwaysOnTop -1, "A"
}

^!b::Run "http://"

^!t::
{
    Run 'C:\Users\Dan Kendall\scoop\apps\alacritty\current\alacritty.exe --working-directory "C:\Users\Dan Kendall"'
}

^!i::Run "ms-settings:windowsupdate"

^+!d::Run "C:\Users\Dan Kendall\scoop\apps\landrop\current\LANDrop.exe"

#PgUp::Send "{Volume_Up}"
#PgDn::Send "{Volume_Down}"
