function fdo {
fzf --query $args | ForEach-Object { Start-Process $_ }
}

function fd {
fzf --query $args
}

function dl {
aria2c -x 16 $args
}

function dls {
aria2c -x 16 --enable-rpc=true $args
}

function rtdl {
aria2c -x 16 "https://robotask.com/downloads/RobotaskSetup64.exe"
}

function gitc {
git clone --depth 1 $args
}

function git_unsynced {
Get-ChildItem -Directory -Recurse | ForEach-Object { 
    $status = git -C $_.FullName status --porcelain
    if ($status) {
        Write-Output "$($_.FullName) has uncommitted changes"
        Write-Output $status
    }
}
}

function printers {
Set-Clipboard "explorer shell:::{A8A91A66-3A7D-4424-8D24-04E180695C7A}"
}

function fwoff {
gsudo Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False
}

function playtv {
smplayer $env:USERPROFILE/Videos/TV/Personal
}

function visualperf {
sysdm.cpl
}

function screensaver {
"control desk.cpl,,@screensaver" | cmd
}

function stripclip {
 $text = Get-Clipboard
 # Remove leading and trailing spaces from each line of the text
 $text = $text | ForEach-Object { $_.Trim() }
 # Save the modified text back to the clipboard
 Set-Clipboard -Value $text
}

function audioToggle {
sc stop Audiosrv
sc start Audiosrv
}

function tbIcons {
Set-Clipboard "explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}"
}

function validationPackager {
cd "$env:USERPROFILE\Ideagen plc\Configuration Team - Documents\Validation Mapping"
./validationPackager.ps1
}

function Open-Perm
{
icacls $args[0] /grant "Users:(OI)(CI)F" /T
}

function Hide-Files
{
  # Get all files in the current directory and its subdirectories
  $files = Get-ChildItem -Recurse

  # Loop through each file and set its hidden attribute
  foreach ($file in $files)
  {
    $file.Attributes = $file.Attributes -bor [IO.FileAttributes]::Hidden
  }
}

function Unhide-Files
{
  # Get all hidden files in the current directory and its subdirectories
  $files = Get-ChildItem -Recurse -Force -Attribute H


  # Loop through each file and remove its hidden attribute
  foreach ($file in $files)
  {
    $file.Attributes = $file.Attributes -band -bnot [IO.FileAttributes]::Hidden
  }
}

function restartautoserv {
    Get-Service -ErrorAction SilentlyContinue | Where-Object {$_.StartType -eq "Automatic" -and $_.Status -eq "Stopped"} | ForEach-Object {Start-Service $_.Name -ErrorAction SilentlyContinue}
}

function rmspecial {
param(
        [string]$directory = '.'
    )

    # Check if the specified directory exists and is a valid directory
    if (!(Test-Path -LiteralPath $directory -PathType Container)) {
        throw "The specified directory does not exist or is not a valid directory."
    }

    # Get a list of all files in the specified directory and all its subdirectories
    $files = Get-ChildItem -LiteralPath $directory -Recurse -File

    # Loop through each file in the list
    foreach ($file in $files) {
        # Replace all non-alphanumeric characters in the file name
        # with an empty string, except for the period and hyphen characters
        $newName = $file.Name -replace '[^a-zA-Z0-9.-]', ''

        # Rename the file with the new, sanitized name
        try {
            Rename-Item -LiteralPath $file.FullName -NewName $newName -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to rename file '$($file.Name)': $_"
        }
    }
}

function dkqpulse {
az vm start --ids "/subscriptions/6ee31983-6836-4bab-86bc-11f1c526291e/resourceGroups/RD-PLAY-NE-01/providers/Microsoft.Compute/virtualMachines/DKQPulseServer"
az vm start --ids "/subscriptions/6ee31983-6836-4bab-86bc-11f1c526291e/resourceGroups/RD-PLAY-NE-01/providers/Microsoft.Compute/virtualMachines/DK-Headless"
az vm start --ids "/subscriptions/6ee31983-6836-4bab-86bc-11f1c526291e/resourceGroups/RD-PLAY-NE-01/providers/Microsoft.Compute/virtualMachines/DKVS"
}

function dkqpulsestop {
az vm deallocate --ids "/subscriptions/6ee31983-6836-4bab-86bc-11f1c526291e/resourceGroups/RD-PLAY-NE-01/providers/Microsoft.Compute/virtualMachines/DKQPulseServer"
az vm deallocate --ids "/subscriptions/6ee31983-6836-4bab-86bc-11f1c526291e/resourceGroups/RD-PLAY-NE-01/providers/Microsoft.Compute/virtualMachines/DK-Headless"
az vm deallocate --ids "/subscriptions/6ee31983-6836-4bab-86bc-11f1c526291e/resourceGroups/RD-PLAY-NE-01/providers/Microsoft.Compute/virtualMachines/DKVS"
}

function piprmall {
rm $env:LOCALAPPDATA\pip
pip freeze | %{pip uninstall -y $_.split('==')[0]}
}

function yt-dlp-trim {
yt-dlp -f "[protocol!*=dash]" --external-downloader ffmpeg --external-downloader-args "ffmpeg_i:-ss $args[1] -to $args[2]" $args[0]
}

function burnin-srt {
$inputFile = $args[0]
$srtFile = $args[1]
$outputFile = "$($inputFile.BaseName)-srt$($inputFile.Extension)"
ffmpeg -i $inputFile -vf subtitles=$srtFile -preset ultrafast $outputFile
}

function speedupvid {
$inputFile = $args[0]
$speed = $args[1]
$outputFile = "$($inputFile.BaseName)-speed$($inputFile.Extension)"
ffmpeg -i $inputFile -filter_complex "[0:v]setpts=1/$speed*PTS[v];[0:a]rubberband=tempo=$speed[a]" -map "[v]" -map "[a]" -preset ultrafast $outputFile
}

function delete {
Remove-Item -recurse $args -Force
}

function rtbak {
Compress-Archive "$env:LOCALAPPDATA\RoboTask" "$env:OnedriveCommercial\Desktop\$(Get-Date -UFormat "%Y-%m-%d_%H-%m-%S")-RTbackup.zip"
}

function qpulse-bak {
Compress-Archive "$env:LOCALAPPDATA\Apps" "$env:OnedriveCommercial\Desktop\$(Get-Date -UFormat "%Y-%m-%d_%H-%m-%S")-qpulse-backup.zip"
}

function yt-dlp-audio {
yt-dlp -f 'ba' -x --audio-format mp3 $args
}

# Compute file hashes - useful for checking successful downloads 
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

function cred {rundll32.exe keymgr.dll, KRShowKeyMgr}

# Quick shortcut to start notepad
function n      { notepad3 $args }

# Drive shortcuts
function HKLM:  { Set-Location HKLM: }
function HKCU:  { Set-Location HKCU: }
function Env:   { Set-Location Env: }

# Make it easy to edit this profile once it's installed
function rc
{
    if ($host.Name -match "ise")
    {
        $psISE.CurrentPowerShellTab.Files.Add($profile.CurrentUserAllHosts)
    }
    else
    {
        notepad3 $profile
    }
}

function rtrun {
    Get-Process RoboTaskRuntime -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
    Get-Process excel -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue
    start-process "C:\Program Files\RoboTask\RoboTaskRuntime.exe" "`"$args`"" -ErrorAction SilentlyContinue
}

Function Test-CommandExists
{
 Param ($command)
 $oldPreference = $ErrorActionPreference
 $ErrorActionPreference = 'SilentlyContinue'
 try {if(Get-Command $command){RETURN $true}}
 Catch {Write-Host "$command does not exist"; RETURN $false}
 Finally {$ErrorActionPreference=$oldPreference}
} 

function lazyg
{
	git add .
	git commit -m "$args"
	git push
}

Function Get-PubIP {
 (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

function uptime {
        Get-WmiObject win32_operatingsystem | Select-Object csname, @{LABEL='LastBootUpTime';
        EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

function source {
        & $profile
}

function find-file($name) {
        Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
                $place_path = $_.directory
        }
}
function unzip ($file) {
        Write-Output("Extracting", $file, "to", $pwd)
	$fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object{$_.FullName}
        Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function grep($regex, $dir) {
        if ( $dir ) {
                Get-ChildItem $dir | select-string $regex
                return
        }
        $input | select-string $regex
}
function touch($file) {
        "" | Out-File $file -Encoding ASCII
}
function df {
        get-volume
}
function sed($file, $find, $replace){
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}
function which($name) {
        Get-Command $name | Select-Object -ExpandProperty Definition
}
function export($name, $value) {
        set-item -force -path "env:$name" -value $value;
}
function pkill($name) {
        Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
        Get-Process $name
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function unblockFolder {
    Write-Output "Unblocking Folder"
    Get-ChildItem -Path $args -Recurse | Unblock-File -Confirm:$false -Verbose
  }

function unblockprofile {
Get-Childitem -Path $env:USERPROFILE\scoop\apps -Recurse | Unblock-File -Confirm:$false -Verbose
Get-Childitem -Path $env:APPDATA\Python\Python311 -Recurse | Unblock-File -Confirm:$false -Verbose
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

function inst {
  scoop install $args
  }
  
function remove {
  scoop uninstall $args
}

function rcupdate {
aria2c --max-connection-per-server=16 --allow-overwrite=true -d (Split-Path $profile) -o Microsoft.Powershell_profile.ps1 "https://github.com/MANICX100/setup_scripts/raw/main/Microsoft.Powershell_profile.ps1"
}

function tgupdate {
aria2c --max-connection-per-server=16 --allow-overwrite=true -d $env:APPDATA -o topgrade.toml "https://github.com/MANICX100/setup_scripts/raw/main/topgrade.toml"
}

function repairwindows {
chkdsk c: /F /R
DISM.exe /Online /Cleanup-image /Restorehealth
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

function comlist {
Get-WMIObject Win32_SerialPort | Select-Object Name,DeviceID,Description
}

function up{
gsudo topgrade
}

function winup {
start $env:onedriveconsumer/wua-all.vbs
#Install-WindowsUpdate -MicrosoftUpdate -AcceptAll | Out-File "$env:USERPROFILE/$(Get-Date -f yyyy-MM-dd)-MSUpdates.log" -Force
}

function emptybin{
Write-Output Y|pwsh.exe -NoProfile -Command Clear-RecycleBin
}

function seq ($s,$e,$step){
$s..$e | Where-Object { $_ % $step -eq 0 }
}

function networkcycle{
Get-NetAdapter | Disable-NetAdapter -Confirm:$false
Get-NetAdapter | Enable-NetAdapter -Confirm:$false
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
ffmpeg -f dshow -i audio=$args[0] -y -f gdigrab -framerate 30 -draw_mouse 1 -i desktop -c:v libx264 -f mp4 output-$(Get-Date -UFormat "%Y-%m-%d_%H-%m-%S").mp4
}

function ffmpeglist {
ffmpeg -list_devices true -f dshow -i dummy
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

function last{
gsudo powercfg /sleepstudy
}

function rev{
$array_reversed = $args -split ""
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

function gitIgnoreRm {
git rm -r --cached .
git add .
git commit -m "Update .gitignore"
}

function yt {
Set-Location "$env:USERPROFILE/videos/yt"
yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]' 'https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg'
gohome
}

function delyt {
Set-Location "$env:USERPROFILE/videos/"
Remove-Item yt -Force
mkdir yt
}

function cleanup {
scoop cache rm *
}

Invoke-Expression (&scoop-search --hook)

Set-Alias -Name bak -Value backup
Set-Alias -Name rm -Value delete
Set-Alias -Name pfetch -Value macchina
Set-Alias -Name neofetch -Value macchina
