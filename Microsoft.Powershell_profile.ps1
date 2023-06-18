function fdc {
    param (
        [string]$query = ''
    )

    # Run fzf and capture the selected file path
    $selectedFile = & fzf --query="$query"

    if ($selectedFile) {
        # Extract the directory path from the selected file
        $sourcePath = Split-Path -Path $selectedFile -Parent

        # Now we will run fzf again to choose the destination directory
        $destinationDirectory = & fzf --query=""

        if ($destinationDirectory) {
            # Ensure the chosen destination is indeed a directory
            if (Test-Path $destinationDirectory -PathType Container) {
                # Construct the full destination path
                $destinationPath = Join-Path -Path $destinationDirectory -ChildPath (Split-Path -Path $selectedFile -Leaf)
                
                # Copy the file or directory to the new location
                Copy-Item -Path $selectedFile -Destination $destinationPath
            } else {
                Write-Host "Invalid directory selected. Operation cancelled."
            }
        }
    }
}

function lsf {
Get-ChildItem -Recurse | Resolve-Path | ForEach-Object { $_.Path.Replace('Microsoft.PowerShell.Core\FileSystem::', '') }
}

function pkgsearch {
    param(
        [Parameter(Mandatory=$true)]
        [string]$searchTerm
    )

    Write-Host "Searching packages for `"$searchTerm`"...`n"

    Write-Host "----- WINGET SEARCH -----"
    try {
        winget search $searchTerm
    }
    catch {
        Write-Host "Error running winget search. Please make sure winget is installed and in your PATH."
    }

    Write-Host "`n----- SCOOP SEARCH -----"
    try {
        scoop search $searchTerm
    }
    catch {
        Write-Host "Error running scoop search. Please make sure scoop is installed and in your PATH."
    }

    Write-Host "`n----- CHOCO SEARCH -----"
    try {
        choco search $searchTerm
    }
    catch {
        Write-Host "Error running choco search. Please make sure choco is installed and in your PATH."
    }
}

function instsearch($packageName) {
    # search in installed programs from the Windows registry
    Write-Host "Searching in Windows installed programs..."
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
        Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | 
        Format-Table -AutoSize |
        Out-String |
        rg -i $packageName

    # search in installed programs from the Scoop package manager
    Write-Host "Searching in Scoop installed programs..."
    scoop list |
        rg -i $packageName

    # search in installed programs from the Chocolatey package manager
    Write-Host "Searching in Chocolatey installed programs..."
    choco list --local-only |
        rg -i $packageName
}

# Function to edit the hosts file
function Edit-Hosts {
gsudo notepad "C:\Windows\System32\drivers\etc\hosts"
}

# Function to display network device status
function NetworkStatus {
    [CmdletBinding()]
    param (
        [switch]$IncludeDisabled
    )
    
    $networkInterfaces = Get-NetAdapter | Where-Object {
        $IncludeDisabled -or $_.Status -eq 'Up'
    }
    
    $networkInterfaces | Format-Table -AutoSize
}

# Function to flush DNS caches
function FlushDNS {
    [CmdletBinding()]
    param (
        [string]$ComputerName = 'localhost'
    )
    
    $command = if ($ComputerName -eq 'localhost') {
        'ipconfig /flushdns'
    } else {
        "Invoke-Command -ComputerName $ComputerName -ScriptBlock { ipconfig /flushdns }"
    }
    
    Invoke-Expression -Command $command
}

function ahkupdate {
    # Kill all running AutoHotkey processes
    Stop-Process -Name AutoHotkey* -Force

    # Set the download directory
    $OneDriveAHKFolder = [System.Environment]::ExpandEnvironmentVariables("%OneDriveConsumer%/AHK")
    
    # Set the URL for the AutoHotkey script
    $url = "https://github.com/MANICX100/setup_scripts/raw/main/main.ahk"
    
    # Download the AutoHotkey script using aria2c
    aria2c --max-connection-per-server=16 --allow-overwrite=true -d $OneDriveAHKFolder -o main.ahk $url

    # Run the downloaded AutoHotkey script
    Start-Process -FilePath "$OneDriveAHKFolder/main.ahk"
}

function wg {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Args
    )

    foreach ($package in $Args) {
        Write-Host "Installing $package"
        winget install $package --accept-package-agreements --disable-interactivity
    }
}

function Open-ShellGUID {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ShellGUID
    )
    Start-Process "explorer.exe" -ArgumentList "shell:::$ShellGUID"
}

function network {
Open-ShellGUID -ShellGUID "{7007ACC7-3202-11D1-AAD2-00805FC1270E}"
}

function mouse {
& 'rundll32.exe' shell32.dll,Control_RunDLL main.cpl
}

function Resync-Time {
    Write-Output "Resyncing time..."
    # Stops the Windows Time service
    net stop w32time
    # Starts the Windows Time service
    net start w32time
    # Clears the local time peer list
    w32tm /config /syncfromflags:manual /manualpeerlist:""
    # Configures the system to synchronize time from the list of peers
    w32tm /config /syncfromflags:manual /manualpeerlist:"time.windows.com"
    # Forces the system to resynchronize the time
    w32tm /resync
    Write-Output "Time resynced successfully"
}

function basicuser {
runas /trustlevel:0x20000 $args
}

function z {
    param (
        [string]$query = ''
    )

    # Run fzf and capture the selected file path
    $selectedFile = & fzf --query="$query"

    if ($selectedFile) {
        # Extract the directory path from the selected file
        $directoryPath = Split-Path -Path $selectedFile -Parent

        # Change directory to the selected file's directory
        Set-Location -Path $directoryPath
    }
}

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
Open-ShellGUID -ShellGUID "{A8A91A66-3A7D-4424-8D24-04E180695C7A}"
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
Open-ShellGUID -ShellGUID "{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}"
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
. $profile
}

function tgupdate {
aria2c --max-connection-per-server=16 --allow-overwrite=true -d $env:APPDATA -o topgrade.toml "https://github.com/MANICX100/setup_scripts/raw/main/topgrade_win.toml"
gsudo topgrade
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

function disable-all-network-interfaces {
Get-NetAdapter | Disable-NetAdapter -Confirm:$false
}

function enable-all-network-interfaces {
Get-NetAdapter | Enable-NetAdapter -Confirm:$false
}

function networkcycle{
disable-all-network-interfaces
enable-all-network-interfaces
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

Function backup {gsudo Checkpoint-Computer -Description "AutomatedBackupViaPwsh"}

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
yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]' 'https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg' --external-downloader aria2c --external-downloader-args "-x 16 -k 1M"
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
Import-Module gsudoModule

Set-Alias -Name bak -Value backup
Set-Alias -Name rm -Value delete
Set-Alias -Name pfetch -Value macchina
Set-Alias -Name neofetch -Value macchina
