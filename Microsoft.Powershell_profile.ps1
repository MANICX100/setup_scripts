$env:EDITOR = "nvem"

Set-Alias -Name bak -Value backup
Set-Alias -Name rm -Value delete
Set-Alias -Name pfetch -Value macchina
Set-Alias -Name neofetch -Value macchina
Set-Alias -Name fixwifi -Value networkcycle
Set-Alias -Name xclip -Value pbcopy
Set-Alias -Name uninstall -Value remove
Set-Alias -Name sync -Value RemoveDrive.exe
Set-Alias -Name bluetooth -Value btdiscovery
Set-Alias -Name printers -Value Get-Printer
Set-Alias -Name setresolution -Value Set-Resolution
Set-Alias -Name grep -Value rg
Set-Alias -Name sed -Value sd
Set-Alias -Name awk -Value frawk
Set-Alias -Name uptime -Value Get-Uptime
Set-Alias -Name whereis -Value gcm
Set-Alias -Name cpuinfo -Value dxdiag
Set-Alias -Name gpuinfo -Value dxdiag
Set-Alias -Name vars -Value variable
Set-Alias -Name timeweb -Value Get-WebsitePerformance
Set-Alias -Name top -Value btop
Set-Alias -Name python -Value pypy
Set-Alias -Name pl -Value perl
Set-Alias -Name pedeps -Value listpedeps

function nvem {
nvim -u vem/vemrc $args
}

function dotfileshide
{
cmd.exe /c "ATTRIB +H /s /d C:\.*"
}

function Get-WebsitePerformance
{
  curl -L -w "time_namelookup: %{time_namelookup}\ntime_connect: %{time_connect}\ntime_appconnect: %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect: %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}\n" $args
}

function Reload-Profile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
    ) | % {
        if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
        }
    }    
}

function SoundInfo {
  Powershell.exe -c "Get-WmiObject win32_VideoController"
}

function usb {
Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' }
}

function Set-Resolution {
  param(
    [string]$resolution
  )
  
  $x = $resolution.Split('x')[0]
  $y = $resolution.Split('x')[1]
  
  & 'QRes.exe' /x:$x /y:$y
}

function all {
    param(
        [Parameter(Mandatory=$true)]
        [scriptblock]$cmd
    )
    $files = Get-ChildItem -File
    foreach ($file in $files) {
        . $cmd $file
    }
}

function replaceline {
    param (
        [Parameter(Position=0)]
        [string]$filePath,
        
        [Parameter(Position=1)]
        [int]$lineNumber,
        
        [Parameter(Position=2)]
        [string]$newLine
    )

    # Read all lines from the file
    $content = Get-Content $filePath

    # Replace the line at the given line number
    $content[$lineNumber - 1] = $newLine

    # Write the updated content back to the file
    Set-Content -Path $filePath -Value $content
}

function reinstall {
	scoop uninstall $args
 	scoop install $args
 }

function afconvert {
    ffmpeg $args
}

function afinfo {
    mediainfo $args
}

function afplay {
    smplayer $args
}

function airport {
    networkstatus $args
}

function alloc {
    free $args
}

function apropos {
    tldr $args
}

function automator {
    Write-Output "Automator not configured"
}

function asr {
    Write-Output "Restore not necessary"
}

function atsutil {
    fc-cache -vf $args
}

function bless {
    Write-Output "All bootable OK"
}


# PowerShell function to mimic systemctl. Depending on the service you want to manage, you might want to use `Start-Service`, `Stop-Service`, `Restart-Service` or `Set-Service`
function pmset([string]$serviceName, [string]$action){
    switch ($action) {
        'start' {Start-Service -Name $serviceName}
        'stop' {Stop-Service -Name $serviceName}
        'restart' {Restart-Service -Name $serviceName}
        default {Set-Service -Name $serviceName -Status $action}
    }
}

function softwareupdate([string]$softwareName){
up
}

# No direct equivalent for caffeinate, but you can stop the system from going to sleep by running the following
function caffeinate(){
    powercfg /change -standby-timeout-ac 0
}

# There's no direct Windows equivalent for libvips
function textutil(){
    Write-Output "No Windows equivalent for libvips"
}

# PowerShell function to mimic 'locate'
function mdfind([string]$fileName){
    Get-ChildItem -Path C:\ -Filter $fileName -File -Recurse -ErrorAction SilentlyContinue
}

# PowerShell function to mimic 'speedtest-cli', need to install speedtest-cli in windows
function networkQuality(){
    speedtest-cli
}

# There's no direct Windows equivalent for 'scrot'
function screencapture(){
    Write-Output "No Windows equivalent for scrot"
}

# PowerShell function to mimic 'xclip -selection clipboard', you'll need to have `clip.exe` available.
function pbcopy([string]$inputString){
    echo $inputString | clip
}

# PowerShell function to mimic 'xclip -selection clipboard -o', you'll need to use `Get-Clipboard` cmdlet.
function pbpaste(){
    Get-Clipboard
}

# PowerShell function to mimic 'espeak', Windows have `SAPI.SpVoice` for text-to-speech.
function say([string]$textToSpeak){
    Add-Type -TypeDefinition 'using System.Speech.Synthesis; public class Speech {public static void Speak(string text){ new SpeechSynthesizer().Speak(text); }}'
    [Speech]::Speak($textToSpeak)
}

# There's no direct Windows equivalent for vipsthumbnail
function sips(){
    Write-Output "No Windows equivalent for vipsthumbnail"
}

# PowerShell function to mimic 'nmcli', but it's not a direct equivalent.
function networksetup(){
    Get-NetAdapter
}


function display_path {
    $path = [Environment]::GetEnvironmentVariable("Path", "User")
    $path.Split(';')
}

function add_to_path($newPath) {
    $path = [Environment]::GetEnvironmentVariable("Path", "User")
    
    if ($path -notlike "*$newPath*") {
        $path += ";$newPath"
        [Environment]::SetEnvironmentVariable("Path", $path, "User")
    } else {
        Write-Host "The path $newPath is already in the User PATH variable."
    }
}

function remove_from_path($removePath) {
    $path = [Environment]::GetEnvironmentVariable("Path", "User")
    $paths = $path.Split(';')
    
    if ($paths -contains $removePath) {
        $paths = $paths | Where-Object { $_ -ne $removePath }
        $newPath = $paths -join ';'
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    } else {
        Write-Host "The path $removePath is not found in the User PATH variable."
    }
}


function extract {
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$Path
    )
    
    foreach($file in $Path) {
        if(!(Test-Path $file)) {
            Write-Output "'$file' - file doesn't exist"
            continue
        }
        
        switch -Wildcard ($file) {
            "*.zip" { 
                Expand-Archive -Path $file -DestinationPath $(Split-Path $file -Parent)
                break
            }
            "*.tar.gz" { 
                7z x $file -so | 7z x -aoa -si -ttar
                break
            }
            "*.tar.bz2" { 
                7z x $file -so | 7z x -aoa -si -ttar
                break
            }
            "*.tar.xz" { 
                7z x $file -so | 7z x -aoa -si -ttar
                break
            }
            "*.rar" { 
                7z e $file
                break
            }
            "*.7z" { 
                7z e $file
                break
            }
            "*.gz" {
                7z e $file
                break
            }
            "*.bz2" { 
                7z e $file
                break
            }
            "*.xz" { 
                7z e $file
                break
            }
            "*.lzma" { 
                7z e $file
                break
            }
            "*.exe" { 
                7z e $file
                break
            }
            "*.iso" { 
                7z e $file
                break
            }
            # Add more formats if needed
            default {
                Write-Output "extract: '$file' - unknown archive method"
            }
        }
    }
}

function projectdl {
    param (
        [Parameter(Mandatory = $true)]
        [string]$username,
        
        [Parameter(Mandatory = $true)]
        [string]$repo
    )

    $apiUrl = "https://api.github.com/repos/$username/$repo/releases/latest"
    $response = Invoke-RestMethod -Uri $apiUrl

    $downloadUrl = ($response.assets | Where-Object { $_.browser_download_url -like "*windows*" }).browser_download_url

    if ($downloadUrl) {
        $downloadUrl | ForEach-Object {
            $filename = $_ -split '/' | Select-Object -Last 1
            $aria2cArgs = "-x16", "-d", "$HOME\apps", $_

            Start-Process -FilePath "aria2c" -ArgumentList $aria2cArgs -Wait

            $userAnswer = Read-Host "Would you like to extract downloaded file $filename (yes/no)?"
            if ($userAnswer -eq 'yes') {
                $extractPath = Join-Path -Path "$HOME\apps" -ChildPath $filename

                # Call your 'extract' command line tool
                 extract $extractPath
                Write-Host "File $filename extracted to $HOME\apps"
            }
        }
    }
    else {
        Write-Host "No Windows files found for the specified repository."
    }
}


function Open($filePath) {
    if(Test-Path $filePath) {
        Invoke-Item $filePath
    } else {
        Write-Host "The file or directory '$filePath' does not exist"
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
 & $env:EDITOR "C:\Windows\System32\drivers\etc\hosts"
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
 Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False
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

function n      { notepad3 }

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
        & $env:EDITOR $profile
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

function source {
        . Reload-Profile
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
 net stop wuauserv
}

function uefi {
shutdown /r /fw /t 0
}

function inst {
  scoop install $args
  }
  
function remove {
  scoop uninstall $args
}

function rcupdate {
aria2c --max-connection-per-server=16 --allow-overwrite=true -d (Split-Path $profile) -o Microsoft.Powershell_profile.ps1 "https://github.com/MANICX100/setup_scripts/raw/main/Microsoft.Powershell_profile.ps1"
source
}

function tgupdate {
aria2c --max-connection-per-server=16 --allow-overwrite=true -d $env:APPDATA -o topgrade.toml "https://github.com/MANICX100/setup_scripts/raw/main/topgrade_win.toml"
 topgrade
}

function repairwindows {
chkdsk c: /F /R
DISM.exe /Online /Cleanup-image /Restorehealth
}

function e. {explorer .}

function resetcorners {
 Remove-Item "C:\Windows\System32\uDWM_win11drc.bak" 
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

function up {
topgrade
cleanup
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
    Write-Host "Starting to disable all network interfaces"
    $adapters = Get-NetAdapter
    Write-Host "Found $($adapters.Count) network interfaces"
    $adapters | Disable-NetAdapter -Confirm:$false
    Write-Host "All network interfaces have been disabled"
}

function enable-all-network-interfaces {
    Write-Host "Starting to enable all network interfaces"
    $adapters = Get-NetAdapter
    Write-Host "Found $($adapters.Count) network interfaces"
    $adapters | Enable-NetAdapter -Confirm:$false
    Write-Host "All network interfaces have been enabled"
}

function test-internet-connection {
    try {
        Test-Connection -ComputerName 8.8.8.8 -Count 1 -ErrorAction Stop | Out-Null
        $true
    }
    catch {
        $false
    }
}

function networkcycle{
    while (-not (test-internet-connection)) {
        Write-Host "Internet connection not found. Starting network cycle..."
        disable-all-network-interfaces
        Start-Sleep -s 5 # give it a moment before re-enabling
        enable-all-network-interfaces
    }
    Write-Host "Internet connection established. Network cycle stopped."
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
 powercfg /sleepstudy
}

function rev{
$array_reversed = $args -split ""
[array]::Reverse($array_reversed)
$array_reversed -join ''
}

function envvar{
 rundll32.exe sysdm.cpl,EditEnvironmentVariables
}

function mobileapps{
start-process shell:AppsFolder
}

Function backup { Checkpoint-Computer -Description "AutomatedBackupViaPwsh"}

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
scoop cleanup *
scoop cache rm *
}

function rmcache {
Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue
}

Invoke-Expression (&scoop-search --hook)

<#
Set-Alias -Name pkexec -Value gsudo

Set-Alias -Name su -Value gsudo

Set-Alias -Name lxqt-sudo -Value gsudo

Set-Alias -Name kdesudo -Value gsudo

Set-Alias -Name gksu -Value gsudo
#>
