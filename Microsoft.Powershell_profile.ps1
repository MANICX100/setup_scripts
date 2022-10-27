function unblockFolder {
  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [String[]] $message
  )
    Write-Output "Unblocking Folder"
    Get-ChildItem -Path $message -Recurse | Unblock-File
  }

function unblockprofile {
Get-Childitem -Path $env:USERPROFILE\scoop\apps -Recurse | Unblock-File -Confirm:$false -Verbose
Get-Childitem -Path $env:APPDATA\Python\ -Recurse | Unblock-File -Confirm:$false -Verbose
}

function stopup {
gsudo net stop wuauserv
}

function lskb {
Get-ChildItem | Select-Object Name, @{Name="KiloBytes";Expression={$_.Length / 1KB}}
}

function lsmb {
Get-ChildItem | Select-Object Name, @{Name="Megabytes";Expression={$_.Length / 1MB}}
}

function lsgb {
Get-ChildItem | Select-Object Name, @{Name="Gigabytes";Expression={$_.Length / 1GB}}
}

function uefi {
shutdown /o /r /t 0 /f
}

function clean {
scoop cache rm *
scoop cleanup *
#scoop status cleanup
#choco-cleaner
}

function inst {
  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [String[]] $message
  )
  scoop install $message
  }
  
function remove {
  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [String[]] $message
  )
  scoop uninstall $message
}

function rcupdate {
wget -O $profile "https://github.com/MANICX100/setup_scripts/raw/main/Microsoft.Powershell_profile.ps1"
}

function starshipupdate {
wget -O $env:userprofile/.config/starship.toml "https://github.com/MANICX100/setup_scripts/raw/main/starship.toml"
}

function repairwindows {
schtasks /run /TN repair-windows
#chkdsk /f
#DISM.exe /Online /Cleanup-image /Restorehealth
}

function e. {explorer .}

function resetcorners {
gsudo Remove-Item "C:\Windows\System32\uDWM_win11drc.bak" 
}

function delpins {
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms" 
}

function startup {
start-process shell:startup
}

function sendto {
start-process shell:sendto
}

function netw{ncpa.cpl}
function cat{bat --paging=never --style=plain $1}

function speedupvid{
ffmpeg -i $1 -filter_complex "[0:v]setpts=PTS/2[v];[0:a]rubberband=tempo=2[a]" -map "[v]" -map "[a]" 2.mkv
}

function comlist {
Get-WMIObject Win32_SerialPort | Select-Object Name,DeviceID,Description
}

function up{
schtasks /run /TN Topgrade
}

function emptybin{
Write-Output Y|pwsh.exe -NoProfile -Command Clear-RecycleBin
}

function seq ($s,$e,$step){
$s..$e | Where-Object { $_ % $step -eq 0 }
}

function networkcycle{
schtasks /run /TN network_cycle
#netsh interface set interface "WiFi" disable
#netsh interface set interface "WiFi" enable
}

function fixwifi{
schtasks /run /TN fix_wifi
#netsh interface set interface "NextDNS" disable
#netsh interface set interface "NextDNS" enable
}

function delofficecache{
Get-Process Word | Stop-Process
Get-Process Excel | Stop-Process
Get-Process Powerpoint | Stop-Process
Get-Process Outlook | Stop-Process
Get-Process Onenote | Stop-Process
Get-Process Teams | Stop-Process
Write-Output Y|pwsh.exe -NoProfile -Command Remove-item "$env:localappdata\Microsoft\Office\16.0" -Force
Write-Output Y|pwsh.exe -NoProfile -Command Remove-item "$env:appdata\Microsoft\Teams" -Force
}

function rc {
notepad3 $profile
}

function datetime{
pwsh -File "$env:OneDriveConsumer\time.ps1"
}

function x{
7z x %~1 -o*
}

function untar{
tar -xzvf
}

function openall{
'FOR %F IN (*.*) DO START "" "%F"' | cmd
}

function screenrec{
ffmpeg -f dshow -i audio="Microphone (5- SteelSeries Arctis 1 Wireless)" -f -y -f gdigrab -framerate 30 -draw_mouse 1 -i desktop -c:v libx264 output.mkv
}

function killqpulse{
gsudo Get-Process Q-Pulse | Stop-Process
}

function killvm{
Get-Process VMWare | Stop-Process
}

function gohome{
Set-Location $env:USERPROFILE
}

function emptydel{
  $tailRecursion = {
    param(
        $Path
    )
    foreach ($childDirectory in Get-ChildItem -Force -LiteralPath $Path -Directory) {
        & $tailRecursion -Path $childDirectory.FullName
    }
    $currentChildren = Get-ChildItem -Force -LiteralPath $Path
    $isEmpty = $null -eq $currentChildren
    if ($isEmpty) {
        Write-Verbose "Removing empty folder at path '${Path}'." -Verbose
        Remove-Item -Force -LiteralPath $Path
    }
}
}

function flatten{
"%OneDriveConsumer%\flatten.cmd" | cmd
}

function orderfiles{
pwsh -File "$env:OneDriveConsumer\move-into-folders.ps1"
}

function robotask{
schtasks /run /TN RoboTask
}

function restartsynergy{
schtasks /run /TN stop_synergy
schtasks /run /TN start_synergy
}

function last{
gsudo powercfg /sleepstudy
}

function rev{
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [String[]] $str_to_reverse
  )
$array_reversed = $str_to_reverse -split ""
[array]::Reverse($array_reversed)
$array_reversed -join ''
}

function envvar{
gsudo rundll32.exe sysdm.cpl,EditEnvironmentVariables
}

function mobileapps{
start-process shell:AppsFolder
}

Function backup {gsudo Checkpoint-Computer -Description 'Automated Backup via pwsh' -RestorePointType MODIFY_SETTINGS}

function newgitmsg {
  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [String[]] $message
  )
  git add .
  git commit -a -m "$message"
  git push
}

function newgit {
  git add .
  git commit -a --allow-empty-message -m " "
  git push
}

function gitprep {
git stash
git pull
git stash pop
}

function gitPromoteAndMerge {
  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [String[]] $message
  )
    Read-Host "This will attempt to merge an existing branch with master. Any existing in master and not in the branch will be attempted to be preserved"
  git checkout -b "$message"
  git status
  git commit -a --allow-empty-message -m " "
  git checkout master
  git merge --no-ff "$message"
  git push origin master
  }
  
function gitDeleteBranch {
 param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [String[]] $message
  )
git branch -d "$message"
git push origin --delete "$message"
}

function gitRenameBranch {
Write-Host "Please run the following commands in sequence"
Write-Host 'git branch -m "$old" "$new" '
Write-Host 'git branch --unset-upstream "$new" '
Write-Host ' git push origin "$new" '
Write-Host 'git push origin -u "$new" '
}

function gitIgnoreRm {
git ls-files -i -c --exclude-from=.gitignore | ForEach-Object{git rm --cached $_}
}

function yt {
Set-Location "$env:USERPROFILE/videos/yt"
yt-dlp -f 'bv*[height=360]+ba' --download-archive videos.txt  'https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg'
gohome
}

Set-Alias -Name bak -Value backup
#Set-Alias -Name Powershell -Value pwsh

Invoke-Expression (&starship init powershell)
