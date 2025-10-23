#windows config
gsudo powercfg.exe /hibernate off
gsudo reg add HKLM\SYSTEM\ControlSet001\Control\Bluetooth\Audio\AVRCP\CT /v DisableAbsoluteVolume /t REG_DWORD /d 1 /f
gsudo fsutil behavior set disablelastaccess 1
gsudo Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 1
