### PowerShell Profile Refactor

# Initial GitHub.com connectivity check with 1 second timeout
$canConnectToGitHub = Test-Connection github.com -Count 1 -Quiet -TimeoutSeconds 1

# Import Modules and External Profiles
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# Admin Check and Prompt Customization
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
function prompt {
    "[" + (Get-Location) + $(if ($isAdmin) {" # "} else {" $ "}) + "]"
}
$adminSuffix = if ($isAdmin) { " [ADMIN]" } else { "" }
$Host.UI.RawUI.WindowTitle = "PowerShell {0}$adminSuffix" -f $PSVersionTable.PSVersion.ToString()

# Utility Functions
function Test-CommandExists($command) {
    $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
}

# Editor Configuration
$EDITOR = @('nvim', 'pvim', 'vim', 'vi', 'code', 'notepad++', 'sublime_text', 'notepad') | Where-Object { Test-CommandExists $_ } | Select-Object -First 1
Set-Alias -Name vim -Value $EDITOR

function Edit-Profile { & $EDITOR $PROFILE.CurrentUserAllHosts }

# Aliases
Set-Alias afconvert "ffmpeg"
Set-Alias afinfo "mediainfo"
Set-Alias afplay "mpv"
Set-Alias airport "networkstatus"
Set-Alias alloc "free"
Set-Alias apropos "tldr"
Set-Alias ffprobe "mediainfo"
Set-Alias trash "Remove-ItemSafely"
Set-Alias bak "backup"
Set-Alias rm "delete"
Set-Alias pfetch "macchina"
Set-Alias neofetch "macchina"
Set-Alias fixwifi "networkcycle"
Set-Alias xclip "pbcopy"
Set-Alias uninstall "remove"
Set-Alias sync "RemoveDrive.exe"
Set-Alias bluetooth "btdiscovery"
Set-Alias printers "Get-Printer"
Set-Alias setresolution "Set-Resolution"
Set-Alias grep "rg"
Set-Alias sed "sd"
Set-Alias awk "frawk"
Set-Alias uptime "Get-Uptime"
Set-Alias whereis "gcm"
Set-Alias cpuinfo "dxdiag"
Set-Alias gpuinfo "dxdiag"
Set-Alias vars "variable"
Set-Alias timeweb "Get-WebsitePerformance"
Set-Alias top "btop"
Set-Alias python "pypy"
Set-Alias pl "perl"
Set-Alias pedeps "listpedeps"
Set-Alias rsync "rclone"
Set-Alias certinfo "Get-CertificateInfo"

# Functions
function Update-Profile {
    if (-not $global:canConnectToGitHub) { return }
    
    $url = "https://raw.githubusercontent.com/ChrisTitusTech/powershell-profile/main/Microsoft.PowerShell_profile.ps1"
    $oldHash = Get-FileHash $PROFILE
    Invoke-RestMethod $url -OutFile "$env:TEMP/Microsoft.PowerShell_profile.ps1"
    $newHash = Get-FileHash "$env:TEMP/Microsoft.PowerShell_profile.ps1"
    
    if ($newHash.Hash -ne $oldHash.Hash) {
        Copy-Item -Path "$env:TEMP/Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
        Write-Host "Profile has been updated. Please restart your shell." -ForegroundColor Magenta
    }
    
    Remove-Item "$env:TEMP/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
}

function Update-PowerShell {
    if (-not $global:canConnectToGitHub) { return }
    
    $currentVersion = $PSVersionTable.PSVersion.ToString()
    $latestVersion = (Invoke-RestMethod "https://api.github.com/repos/PowerShell/PowerShell/releases/latest").tag_name.Trim('v')
    
    if ($currentVersion -lt $latestVersion) {
        Write-Host "Updating PowerShell..." -ForegroundColor Yellow
        winget upgrade "Microsoft.PowerShell" --accept-source-agreements --accept-package-agreements
        Write-Host "PowerShell has been updated. Please restart your shell." -ForegroundColor Magenta
    } else {
        Write-Host "Your PowerShell is up to date." -ForegroundColor Green
    }
}

function touch($file) { "" | Out-File $file -Encoding ASCII }
function ff($name) { Get-ChildItem -Recurse -Filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object { "$($_.Directory)\$_" } }
function mkcd($dir) { mkdir $dir -Force; Set-Location $dir }
function reload-profile { & $PROFILE }
function unzip($file) {
    Expand-Archive -Path (Get-ChildItem -Path $pwd -Filter $file | ForEach-Object { $_.FullName }) -DestinationPath $pwd
}
function hb($filePath) {
    $uri = "http://bin.christitus.com/documents"
    $response = Invoke-RestMethod -Uri $uri -Method Post -Body (Get-Content $filePath -Raw)
    "http://bin.christitus.com/$($response.key)"
}
function grep($regex, $dir) { 
    if ($dir) { Get-ChildItem $dir | Select-String $regex }
    else { $input | Select-String $regex }
}
function sed($file, $find, $replace) { (Get-Content $file).Replace($find, $replace) | Set-Content $file }
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition }
function export($name, $value) { Set-Item -Force -Path "env:$name" -Value $value }
function pkill($name) { Get-Process $name -ErrorAction SilentlyContinue | Stop-Process }
function pgrep($name) { Get-Process $name }
function head($Path, $n=10) { Get-Content $Path -Head $n }
function tail($Path, $n=10) { Get-Content $Path -Tail $n }
function nf($name) { New-Item -ItemType "file" -Path . -Name $name }

# Project Management
function Make-Project($Name) {
    mkdir "$Name/lib", "$Name/res", "$Name/src"
    New-Item "$Name/.gitignore", "$Name/.gitmodules", "$Name/LICENSE", "$Name/README.md", "$Name/build.zig"
    Write-Host "Created project: $Name"
}

# Git Aliases
function gs { git status }
function ga { git add . }
function gc($m) { git commit -m "$m" }
function gp { git push }
function gcom { git add .; git commit -m $args }
function lazyg { git add .; git commit -m $args; git push }
function newgit { git add .; git commit -a --allow-empty-message -m " "; git push }
function gitprep { git stash; git pull; git stash pop }
function gitIgnoreRm { git rm -r --cached .; git add .; git commit -m "Update .gitignore" }

# Package Management
function pkgsearch($searchTerm) {
    Write-Host "----- WINGET SEARCH -----"
    winget search $searchTerm

    Write-Host "`n----- SCOOP SEARCH -----"
    scoop search $searchTerm

    Write-Host "`n----- CHOCO SEARCH -----"
    choco search $searchTerm
}

function wg($Args) {
    foreach ($package in $Args) {
        Write-Host "Installing $package"
        winget install $package --accept-package-agreements --disable-interactivity
    }
}

function ch { gsudo choco $args }
function cup { cargo install-update -a }
function up { gsudo topgrade; if ($LASTEXITCODE -ne 0) { cup; cleanup } else { cleanup } }
function inst { scoop install $args }
function remove { scoop uninstall $args }

# Other Functions
function Open-ShellGUID($ShellGUID) { Start-Process "explorer.exe" -ArgumentList "shell:::$ShellGUID" }
function Open-Perm { icacls $args[0] /grant "Users:(OI)(CI)F" /T }
function screensaver { "control desk.cpl,,@screensaver" | cmd }
function usb { Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' } }
function unblockprofile { 
    Get-Childitem -Path $env:USERPROFILE\scoop\apps -Recurse | Unblock-File -Confirm:$false -Verbose
    Get-Childitem -Path $env:APPDATA\Python\Python311 -Recurse | Unblock-File -Confirm:$false -Verbose
}
function Edit-Hosts { & $env:EDITOR "C:\Windows\System32\drivers\etc\hosts" }
function envvar { rundll32.exe sysdm.cpl,EditEnvironmentVariables }
function n { notepad3 }
function cat { bat --paging=never --style=plain $1 }
function backup { Checkpoint-Computer -Description "AutomatedBackupViaPwsh" }
function cleanup { scoop cleanup *; scoop cache rm * }
function rmcache { Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue }
function Set-Resolution($resolution) {
    $x, $y = $resolution -split 'x'
    & 'QRes.exe' /x:$x /y:$y
}
function ffmpeglist { ffmpeg -list_devices true -f dshow -i dummy }
function screenrec { ffmpeg -f dshow -i audio=$args[0] -y -f gdigrab -framerate 30 -draw_mouse 1 -i desktop -c:v libx264 -f mp4 output-$(Get-Date -UFormat "%Y-%m-%d_%H-%m-%S").mp4 }
function rcupdate { 
    aria2c --max-connection-per-server=16 --allow-overwrite=true -d (Split-Path $PROFILE) -o Microsoft.Powershell_profile.ps1 "https://github.com/MANICX100/setup_scripts/raw/main/Microsoft.Powershell_profile.ps1"
    source
}

# Final Setup
oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cobalt2.omp.json | Invoke-Expression
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (zoxide init powershell | Out-String)
} else {
    Write-Host "zoxide command not found. Attempting to install via winget..."
    winget install -e --id ajeetdsouza.zoxide
    Write-Host "zoxide installed successfully. Initializing..."
    Invoke-Expression (zoxide init powershell | Out-String)
}

Invoke-Expression (&scoop-search --hook)
