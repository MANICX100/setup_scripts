#scoop
Invoke-RestMethod get.scoop.sh | Invoke-Expression
scoop install git
scoop bucket add extras
scoop bucket add nirsoft
scoop bucket add java
scoop bucket add versions

scoop install gsudo
scoop install starship

scoop install sumatrapdf
scoop install vlc
scoop install topgrade
#scoop install thunderbird
scoop install irfanview

scoop install fd
scoop install ripgrep
scoop install gawk
scoop install sed
scoop install bat
scoop install wget
scoop install time

scoop install powertoys
scoop install notepad3
scoop install nano

scoop install gdu
scoop install ffmpeg
scoop install sharex
#scoop install yt-dlp

#scoop install vscode

scoop install lockhunter

scoop install windows-terminal-preview
scoop install pwsh

#next steps
Write-Host "Remember to download graphics drivers"
Write-Host "Press Enter to continue"
#get user input if amd or nvidia
$graphicsType = Read-Host "AMD or NVIDIA?"
if ($graphicsType -eq "AMD") {
    Write-Host "Downloading AMD drivers"
    Write-Host "Press Enter to continue"
    Read-Host
    Start-Process "https://www.amd.com/en/support"
}
else {
    Write-Host "Downloading NVIDIA drivers"
    Write-Host "Press Enter to continue"
    Read-Host
    #download nvidia drivers
    scoop install nvcleanstall
    #install nvidia drivers
    gsudo nvcleanstall
}

Write-Host "aliases e.g. pwsh"
Read-Host

Write-Host "Remember to change restore point frequency"
Read-Host

Write-Host "Remember to configure WSA"
Read-Host

Write-Host "run topgrade to configure winget choco optional"
Read-Host
