function webserver {
    param(
        [string]$Port = "8080",
        [string]$Path = (Get-Location).Path
    )
    
    $listener = New-Object Net.HttpListener
    $listener.Prefixes.Add("http://localhost:$Port/")
    $listener.Start()
    Write-Host "File server running on http://localhost:$Port"
    Write-Host "Serving files from: $Path"    
    try {
        while ($true) {
            $context = $listener.GetContext()
            
            # Get files in the specified directory
            $files = Get-ChildItem -Path $Path -File | ForEach-Object {
                "<a href='/download/$($_.Name)'>$($_.Name)</a> ($([math]::Round($_.Length/1KB,2)) KB)<br>"
            }
            
            $html = "<h1>Files in $Path</h1>$($files -join '')"
            
            if ($context.Request.Url.AbsolutePath.StartsWith('/download/')) {
                # Handle file download
                $fileName = $context.Request.Url.AbsolutePath.Substring(10)
                $filePath = Join-Path $Path $fileName
                
                if (Test-Path $filePath) {
                    $bytes = [IO.File]::ReadAllBytes($filePath)
                    $context.Response.ContentLength64 = $bytes.Length
                    $context.Response.Headers.Add('Content-Disposition', "attachment; filename=$fileName")
                    $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
                } else {
                    $context.Response.StatusCode = 404
                }
            } else {
                # Handle file listing
                $bytes = [Text.Encoding]::UTF8.GetBytes($html)
                $context.Response.ContentLength64 = $bytes.Length
                $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
            }
            
            $context.Response.Close()
        }
    }
    finally {
        $listener.Stop()
        Write-Host "Server stopped"
    }
}

function sudo {
    gsudo --loadprofile @args
}

function bgrun {
rust-parallel $args[0] ::: $args[1..$args.Length]
}

function synctime {gsudo w32tm /resync}

function saveclipimg {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,ValueFromPipeline=$false)]
        [string]$Path = 'output.jpg'
    )

    # Load WinForms + Drawing if not already loaded
    Add-Type -AssemblyName System.Windows.Forms,System.Drawing -ErrorAction SilentlyContinue

    # Grab image from clipboard
    $img = [Windows.Forms.Clipboard]::GetImage()

    if ($img) {
        # Save as JPEG
        $img.Save($Path, [System.Drawing.Imaging.ImageFormat]::Jpeg)
        Write-Output "✅ Saved clipboard image to $Path"
    }
    else {
        Write-Warning "⚠️ Clipboard does not contain an image."
        return 1
    }
}

function Get-NetHosts {
    <#
    .SYNOPSIS
    Retrieves active TCP connections and resolves remote hostnames using the 'dig' command.
    Outputs a list of unique, resolved remote hostnames that contain a dot (.).

    .DESCRIPTION
    This function lists active TCP network connections using Get-NetTCPConnection.
    For each connection with a valid remote IP address, it attempts a reverse DNS lookup
    using the external 'dig' command (requires BIND tools installed and in PATH).
    It filters out local, private, loopback, and unresolved addresses.
    The final output is a list of unique hostnames (containing at least one '.') associated
    with the remote ends of these connections.

    .REQUIREMENTS
    - Windows PowerShell 5.1 or later.
    - BIND tools for Windows installed, with 'dig.exe' accessible via the system's PATH environment variable.

    .EXAMPLE
    Get-NetHosts

    Outputs a list of resolved remote hostnames, one per line.

    .EXAMPLE
    Get-NetHosts | Sort-Object -Unique

    Outputs a sorted list of unique resolved remote hostnames.

    .NOTES
    Author: Gemini Assistant based on user script
    Date:   2025-04-16
    #>

    # Check if dig command is available
    if (-not (Get-Command dig -ErrorAction SilentlyContinue)) {
        Write-Error "The 'dig' command was not found. Please install BIND tools for Windows and ensure dig.exe is in your PATH."
        return
    }

    # --- Internal Helper Function ---
    # Performs reverse DNS lookup using dig
    function Resolve-HostnameWithDigInternal ($ipAddress) {
        # Avoid resolving non-routable, loopback, or unspecified addresses
        if ($ipAddress -match '^127\.' -or `
            $ipAddress -eq '::1' -or `
            $ipAddress -match '^169\.254\.' -or `
            $ipAddress -match '^fe80:' -or ` # Link-local IPv6
            $ipAddress -match '^0\.0\.0\.0' -or `
            $ipAddress -eq '::') {
            return $null # Ignore these addresses
        }
        # Add checks for private ranges if desired (uncomment if needed)
        # if ($ipAddress -match '^192\.168\.' -or $ipAddress -match '^10\.' -or $ipAddress -match '^172\.(1[6-9]|2[0-9]|3[0-1])\.' -or $ipAddress -match '^fd[0-9a-f]{2}:') { # Added Private IPv6 ULA
        #     return $null # Ignore private IPs
        # }

        try {
            # Execute dig with short timeout and limited retries for efficiency
            $digResult = dig -x $ipAddress +short +time=1 +tries=1 2>$null # Redirect stderr to prevent dig errors cluttering output
            $lastExitCode = $LASTEXITCODE # Capture exit code immediately

            if ($lastExitCode -ne 0 -or -not $digResult) {
                # Dig command failed, timed out, or found no PTR record
                return $null
            } else {
                # dig +short often returns FQDN ending in '.', trim it and any whitespace.
                # Take only the first result if multiple lines are returned.
                $hostnames = ($digResult | ForEach-Object { $_.TrimEnd('.').Trim() })
                # Ensure we actually got something back after trimming before returning
                if ($hostnames -and $hostnames[0]) {
                   return $hostnames[0]
                } else {
                   return $null # Return null if trimming resulted in empty string
                }
            }
        } catch {
            # Catch PowerShell errors during the process (e.g., dig execution failed)
            # Write-Warning "Error resolving '$ipAddress': $($_.Exception.Message)" # Suppress PS warnings for cleaner output
            return $null
        }
    }
    # --- End Internal Helper Function ---


    # --- Main Processing Logic ---
    # Use a HashSet for efficient unique storage
    $uniqueHosts = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    # Process only TCP Connections
    Get-NetTCPConnection | ForEach-Object {
        $remoteAddress = $_.RemoteAddress

        # Resolve hostname only if it's a potentially public, specified address
        $remoteHost = Resolve-HostnameWithDigInternal $remoteAddress

        # Only add to set if a hostname was resolved AND it contains a dot (valid FQDN pattern)
        if ($remoteHost -and $remoteHost -like '*.*') {
            # Add returns $true if the item was added, $false if it already existed
            [void]$uniqueHosts.Add($remoteHost)
        }
    }

    # Output the unique hostnames
    # Convert HashSet to array and sort it for consistent output order
    $sortedHosts = $uniqueHosts | Sort-Object
    foreach ($hostEntry in $sortedHosts) {
         Write-Host $hostEntry
    }
    # --- End Main Processing Logic ---

}

# Example Usage:
# Get-NetHosts

function UninstallAll-Modules {
    [CmdletBinding()]
    param()

    process {
        # Check if gsudo is available
        if (-not (Get-Command -Name gsudo -ErrorAction SilentlyContinue)) {
            Write-Error "gsudo not found. Please install it with 'winget install gerardog.gsudo' or visit https://github.com/gerardog/gsudo"
            return
        }

        $documentsPath = [Environment]::GetFolderPath('MyDocuments')
        $modulesPath = Join-Path -Path $documentsPath -ChildPath 'PowerShell\Modules'
        
        if (Test-Path -Path $modulesPath) {
            Write-Warning "This will permanently delete all PowerShell modules at: $modulesPath"
            $confirmation = Read-Host "Are you sure you want to proceed? (y/n)"
            
            if ($confirmation -eq 'y') {
                Write-Output "Removing all PowerShell modules at: $modulesPath"
                
                # Properly escape the path for use in the command
                $escapedPath = $modulesPath -replace "'", "''"
                
                # Use a script block instead of a string command for better handling of paths with spaces
                $scriptBlock = [ScriptBlock]::Create("Remove-Item -Path '$escapedPath' -Recurse -Force -ErrorAction Stop")
                
                try {
                    gsudo powershell.exe -NoProfile -Command "& {$scriptBlock}"
                    Write-Output "Successfully removed all modules from $modulesPath"
                }
                catch {
                    Write-Error "Failed to remove modules: $_"
                }
            }
            else {
                Write-Output "Operation cancelled by user."
            }
        }
        else {
            Write-Output "PowerShell Modules folder not found at: $modulesPath"
        }
    }
}

function heavytasklist {
Get-Process | Select-Object Name, ID, CPU, @{Name="MemoryMB";Expression={$_.WorkingSet / 1MB}}, Description | Sort-Object -Property CPU, MemoryMB -Descending | Select-Object -First 20 | Format-Table -AutoSize
}

function Delete-GitHistory {
    param(
        [string]$CommitMessage = "Clean git history"
    )
    
    Write-Host "Creating new orphan branch..." -ForegroundColor Cyan
    git checkout --orphan latest_branch
    
    Write-Host "Adding all files to the new branch..." -ForegroundColor Cyan
    git add -A
    
    Write-Host "Committing changes..." -ForegroundColor Cyan
    git commit -am $CommitMessage
    
    Write-Host "Deleting main branch..." -ForegroundColor Cyan
    git branch -D main
    
    Write-Host "Renaming current branch to main..." -ForegroundColor Cyan
    git branch -m main
    
    Write-Host "Force pushing to remote repository..." -ForegroundColor Cyan
    git push -f origin main
    
    Write-Host "Running garbage collection..." -ForegroundColor Cyan
    git gc --aggressive --prune=all
    
    Write-Host "Git history has been reset!" -ForegroundColor Green
}

function Recent {
    param (
        [int]$Count = 20  # Default to 20 if no argument is given
    )

    Get-ChildItem -Path . -File -Recurse | 
        Sort-Object LastWriteTime -Descending | 
        Select-Object -First $Count | 
        ForEach-Object { $_.FullName }
}

function biosversion {
 Get-WmiObject win32_bios
}

function scoopadmin {
iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
}

function Get-Dictionary {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Word
    )

    $url = "dict://dict.org/d:$Word"
    
    try {
        $result = Invoke-WebRequest -Uri $url -UseBasicParsing
        $result.Content
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

function Update-DockerImages {
    $images = docker images --format "{{.Repository}}" | Sort-Object -Unique | Where-Object { $_ -ne "<none>" }
    foreach ($image in $images) {
        docker pull $image
    }
}

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
$EDITOR = @('nvem','nvim', 'pvim', 'vim', 'vi', 'code', 'notepad++', 'sublime_text', 'notepad') | Where-Object { Test-CommandExists $_ } | Select-Object -First 1
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
Set-Alias rcupdate "Update-Profile"

# Functions

function rc {Notepad $PROFILE}
function Update-Profile {
    if (-not $global:canConnectToGitHub) { return }
    
    $url = "https://github.com/MANICX100/setup_scripts/raw/main/Microsoft.Powershell_profile.ps1"
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

function ff($name) { Get-ChildItem -Recurse -Filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object { "$($_.Directory)\$_" } }
function mkcd($dir) { mkdir $dir -Force; Set-Location $dir }
function reload-profile { & $PROFILE }

function hb($filePath) {
    $uri = "http://bin.christitus.com/documents"
    $response = Invoke-RestMethod -Uri $uri -Method Post -Body (Get-Content $filePath -Raw)
    "http://bin.christitus.com/$($response.key)"
}
function sed($file, $find, $replace) { (Get-Content $file).Replace($find, $replace) | Set-Content $file }
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition }
function export($name, $value) { Set-Item -Force -Path "env:$name" -Value $value }
function pkill($name) { Get-Process $name -ErrorAction SilentlyContinue | Stop-Process }
function pgrep($name) { Get-Process $name }
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

#function ch { gsudo choco $args }
#function cup { cargo install-update -a }
function up { gsudo topgrade;}
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

Invoke-Expression (&scoop-search --hook)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

function prompt {
    class Color {
        [int] $R
        [int] $G
        [int] $B

        static [Color] $Default = $null

        Color([int] $r, [int] $g, [int] $b) {
            $this.R = $r
            $this.G = $g
            $this.B = $b
        }

        static [string] Foreground([Color] $color) {
            if ($color) {
                return "$([char]0x1B)[38;2;$($color.R);$($color.G);$($color.B)m"
            }
            else {
                return "$([char]0x1B)[39m"
            }
        }

        static [string] Background([Color] $color) {
            if ($color) {
                return "$([char]0x1B)[48;2;$($color.R);$($color.G);$($color.B)m"
            }
            else {
                return "$([char]0x1B)[49m"
            }
        }
    }

    class PromptBuilder {
        hidden [string] $Text
        hidden [Color] $Foreground
        hidden [Color] $Background
        hidden [string] $Separator
        hidden [string] $ReversedSeparator

        PromptBuilder() {
            $this.Text = ""
            $this.Foreground = $null
            $this.Background = $null
            $this.Separator = $null
            $this.ReversedSeparator = $null
        }

        hidden PromptBuilder(
            [string] $text,
            [Color] $foreground,
            [Color] $background,
            [string] $separator,
            [string] $reversedSeparator
        ) {
            $this.Text = $text
            $this.Foreground = $foreground
            $this.Background = $background
            $this.Separator = $separator
            $this.ReversedSeparator = $reversedSeparator
        }

        [PromptBuilder] WithForeground([Color] $color) {
            return [PromptBuilder]::new(
                $this.Text,
                $color,
                $this.Background,
                $this.Separator,
                $this.ReversedSeparator
            )
        }

        [PromptBuilder] WithSection([string] $text) {
            return $this.WithSection($text, $this.Background)
        }

        [PromptBuilder] WithSection([string] $text, [Color] $background) {
            return [PromptBuilder]::new(
                "$($this.Text)$([Color]::Foreground($background))$([Color]::Background($this.Background))$($this.ReversedSeparator)$([Color]::Foreground($this.Background))$([Color]::Background($background))$($this.Separator)$([Color]::Foreground($this.Foreground))$text",
                $this.Foreground,
                $background,
                $null,
                $null
            )
        }

        [PromptBuilder] WithSeparator([char] $separator) {
            return [PromptBuilder]::new(
                $this.Text,
                $this.Foreground,
                $this.Background,
                "$separator",
                $null
            )
        }

        [PromptBuilder] WithoutSeparator() {
            return [PromptBuilder]::new(
                $this.Text,
                $this.Foreground,
                $this.Background,
                $null,
                $null
            )
        }

        [PromptBuilder] WithReversedSeparator([char] $separator) {
            return [PromptBuilder]::new(
                $this.Text,
                $this.Foreground,
                $this.Background,
                $null,
                "$separator"
            )
        }

        [string] ToString() {
            $final = $this.WithForeground([Color]::Default).WithSection("", [Color]::Default)
            return $final.Text
        }
    }

    $path = $(Get-Location).Path
    $sections = $path.Split([char]'\')
    $level = 0

    $git_root = -1
    if ($(git rev-parse --is-inside-work-tree) -eq "true")
    {
        $git_root = $(git rev-parse --show-toplevel).Split([char]'/').Length - 1
        $git_branch = $(git rev-parse --abbrev-ref HEAD)
    }
    
    $builder = [PromptBuilder]::new()    
    $builder = $builder.WithReversedSeparator(0xE0CA)

    if ($sections[0].EndsWith(":"))
    {
        $builder = $builder.WithSection(" $($sections[0].TrimEnd([char]':'))", [Color]::new(227, 146, 52))
        $builder = $builder.WithSeparator(0xE0B4)

        $level += 1
    }

    if ($path.StartsWith("C:\Users\dan"))
    {
        $builder = $builder.WithSection("Daniel Kendall", [Color]::new(52, 128, 235))
        $builder = $builder.WithSeparator(0xE0B8)

        $level += 2
    }

    if ($path.StartsWith("C:\Users\dan\Programy"))
    {
        $builder = $builder.WithSection(" 💻 ", [Color]::new(54, 109, 186))
        $builder = $builder.WithSeparator(0xE0B8)

        $level += 1
    }
    
    for(; $level -lt $sections.Length; $level++)
    {
        if ($level -eq $git_root) {
            $builder = $builder.WithSection(" $($sections[$level]) ", [Color]::new(70, 138, 74))
            $builder = $builder.WithSeparator(0xE0A0)
            $builder = $builder.WithSection(" $git_branch ", [Color]::new(72, 163, 77))
        }
        elseif ($sections[$level] -eq "Debug" -or $sections[$level] -eq "Release")
        {
            $builder = $builder.WithReversedSeparator(0xE0C2)
            $builder = $builder.WithSection(" $($sections[$level]) ", [Color]::new(186, 54, 54))
        }
        elseif ($level % 2 -eq 0) {
            $builder = $builder.WithSection(" $($sections[$level]) ", [Color]::new(99, 99, 99))
        }
        else {
            $builder = $builder.WithSection(" $($sections[$level]) ", [Color]::new(80, 80, 80))
        }

        $builder = $builder.WithSeparator(0xE0B8)
    }

    $builder = $builder.WithoutSeparator()
    $builder = $builder.WithSeparator(0xE0B0)
    $builder = $builder.WithSection(" ", [Color]::Default)

    return $builder.ToString()
}
