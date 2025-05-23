SendMode("Input")
SetWorkingDir(A_ScriptDir)
DetectHiddenWindows(true)
SetTitleMatchMode(2)
#WinActivateForce
Persistent

; --- Global Variable ---
; Declare and initialize the global variable to track the state.
global komorebi_is_running := false ; Assume Komorebi is stopped initially

; --- Hotkey Definition ---
; Win + Ctrl + K :: Toggle Komorebi Start/Stop
#^k::
{
    ; IMPORTANT: Variable declarations MUST come first in the block!
    global komorebi_is_running

    ; Now the rest of the code follows the declaration:
    if (komorebi_is_running) ; Check the global variable's value
    {
        Run("komorebic stop",, "Hide")
        ToolTip("Komorebi Stopping...")
        komorebi_is_running := false ; Update the global variable
    }
    else ; If we think it's stopped, start it
    {
        Run("komorebic start",, "Hide")
        ToolTip("Komorebi Starting...")
        komorebi_is_running := true ; Update the global variable
    }
    ; Remove the tooltip after 1.5 seconds
    SetTimer(() => ToolTip(), -1500)
}

;Hotkeys
;# win
;! alt
;^ ctrl

#HotIf WinActive("ahk_class CabinetWClass")
`::
{
explorerHwnd := WinActive("ahk_class CabinetWClass")
    if (explorerHwnd)
    {
        dir := ""
        for window in ComObject("Shell.Application").Windows
        {
            if (window.HWND == explorerHwnd)
            {
                dir := window.Document.Folder.Self.Path
                break
            }
        }
        
        if (dir != "")
        {
            ; Run PowerShell Core in the current directory
            Run "pwsh.exe -NoExit -Command `"Set-Location '" dir "'`"", dir
        }
    }
    else
    {
        ; If not in Explorer, run PowerShell Core in the default location
        Run "pwsh.exe"
    }
}
#HotIf

; AutoHotkey v2 Script
; Hotkey: Win + Ctrl + T
; Action: Toggles the "Always on Top" state for the active window

#^t::
{
    ; Use the WinSetAlwaysOnTop function (v2 syntax)
    ; -1 toggles the state
    ; "A" targets the active window
    WinSetAlwaysOnTop(-1, "A")
}

AppsKey::Run "https://poe.com"

Home::Reload()

Pause::Send("{Media_Play_Pause}")

; Alt + Pause  →  open *this* script in Notepad
!Pause::
{
    Run('notepad.exe "' A_ScriptFullPath '"')
}

^!W::ToggleChrome()

ToggleChrome() {
    local w, v := 0
    DetectHiddenWindows false
    for w in WinGetList("ahk_class Chrome_WidgetWin_1") {
        v := 1
    }
    DetectHiddenWindows true
    for w in WinGetList("ahk_class Chrome_WidgetWin_1") {
        if v
            WinHide(w)
        else
            WinShow(w)
    }
}

^!S::Shutdown(5)
^!R::Shutdown(6)
^!n::Run("notepad.exe")

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

^!+t::
{
    WinSetAlwaysOnTop -1, "A"
}

; Map Ctrl+Alt+T to launch Windows Terminal (wt.exe)
^!t::
{
    Run("wt.exe")
    return
}
; Map Ctrl+Shift+Esc to launch Task Manager with the "-d" parameter
^+Esc::
 {
    Run("taskmgr.exe -d")
    return
 }
 
^!b::Run "http://"

^!i::Run "ms-settings:windowsupdate"

#PgUp::Send "{Volume_Up}"
#PgDn::Send "{Volume_Down}"
