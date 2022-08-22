Write-Host "Please temporily disable UAC to avoid password prompts"
Read-Host

#scoop
Invoke-RestMethod get.scoop.sh | Invoke-Expression
scoop install git
scoop bucket add extras

scoop install gsudo

scoop install sumatrapdf
scoop install vlc
scoop install topgrade
scoop install thunderbird

scoop install fd
scoop install ripgrep
scoop install gawk
scoop install sed
scoop install bat
scoop install wget

scoop install tabby

scoop install notepad3

scoop install nano

scoop install vscode

#chocolatey
gsudo Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#windows config
gsudo powercfg.exe /hibernate off
gsudo reg add HKLM\SYSTEM\ControlSet001\Control\Bluetooth\Audio\AVRCP\CT /v DisableAbsoluteVolume /t REG_DWORD /d 1 /f
gsudo fsutil behavior set disablelastaccess 1
gsudo Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 1

#winget
winget install -e --id Microsoft.DotNet.Runtime.6
winget install -e --id Microsoft.PowerToys
winget install -e --id BitSum.ProcessLasso

#next steps
Write-Host "Remember to download graphics drivers"
Write-Host "Press Enter to continue"
#get user input if amd or nvidia
$graphicsType = Read-Host "AMD or NVIDIA?"
if ($graphicsType -eq "AMD") {
    Write-Host "Downloading AMD drivers"
    Write-Host "Press Enter to continue"
    Start-Process "https://www.amd.com/en/support"
}
else {
    Write-Host "Downloading NVIDIA drivers"
    Write-Host "Press Enter to continue"
    #download nvidia drivers
    scoop install nvcleanstall
    #install nvidia drivers
    gsudo nvcleanstall
}

Write-Host "Remember to change restore point frequency"
Read-Host

Write-Host "Remember to configure WSA"
Read-Host
