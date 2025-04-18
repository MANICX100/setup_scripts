function Repair-Windows {
    <#
    .SYNOPSIS
        Runs standard Windows image repair and system file check commands (DISM and SFC) with elevated privileges using gsudo.
    .DESCRIPTION
        This function utilizes the 'gsudo' utility to launch an elevated command prompt (cmd.exe).
        Within that elevated prompt, it executes two commands sequentially:
        1. DISM.exe /Online /Cleanup-image /Restorehealth
        2. sfc /scannow

        These commands are commonly used to repair Windows system image corruption and fix protected system files.

        Ensure 'gsudo' is installed and accessible in your system's PATH for this function to work.
        You can get gsudo from https://github.com/gerardog/gsudo

        You will likely see a UAC prompt when gsudo requests elevation.
    .EXAMPLE
        Repair-Windows

        Runs the DISM and SFC commands in an elevated cmd.exe window via gsudo.
    .NOTES
        Author: Gemini
        Requires: gsudo (https://github.com/gerardog/gsudo) installed and in PATH.
        Platform: Windows PowerShell / PowerShell 7+
    #>
    [CmdletBinding()]
    [OutputType([void])] # This function doesn't return specific objects, output is from the commands run via gsudo.
    param()

    begin {
        # Check if gsudo command is available
        if (-not (Get-Command gsudo -ErrorAction SilentlyContinue)) {
            Write-Error "The 'gsudo' command was not found. Please ensure gsudo is installed and available in your system's PATH."
            Write-Host "You can download gsudo from: https://github.com/gerardog/gsudo"
            # Stop the function if gsudo is missing
            return
        }
        Write-Host "Preparing to run DISM Restorehealth and SFC ScanNow using gsudo..."
        Write-Host "This will request administrative privileges via a UAC prompt."
    }

    process {
        # Define the commands to run within cmd.exe
        # Using && ensures sfc /scannow only runs if DISM completes successfully (exit code 0)
        $commandsToRun = "DISM.exe /Online /Cleanup-image /Restorehealth && sfc /scannow"

        # Construct the argument list for gsudo
        # We tell gsudo to run cmd.exe, using /C to execute the command string and then exit.
        $gsudoArgs = @(
            "cmd.exe",
            "/C",
            "`"$commandsToRun`"" # Encapsulate the commands in quotes for cmd.exe
        )

        Write-Host "Executing commands via gsudo. Please approve the UAC prompt if it appears."
        Write-Verbose "Running: gsudo $($gsudoArgs -join ' ')"

        try {
            # Execute gsudo with the specified arguments
            # Using Start-Process allows capturing output/errors if needed, but direct execution is simpler here.
            # We expect gsudo to handle showing the output from cmd.exe in the current console or a new one based on gsudo's config.
            gsudo @gsudoArgs

            # Note: Error checking based on $LASTEXITCODE after gsudo might be unreliable
            # as it depends on gsudo's behavior and whether it passes through cmd.exe's exit code correctly.
            # It's best to observe the output directly from the commands.

        } catch {
            Write-Error "An error occurred while trying to execute gsudo: $_"
        }
    }

    end {
        Write-Host "The Repair-Windows function has finished attempting the DISM and SFC operations."
        Write-Host "Please review the output from the elevated window/console for the results of the scans."
    }
}

function Setup-ScriptLink {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [string]$SourcePath
    )

    Process {
        # --- Validate Source ---
        $resolvedSource = Resolve-Path -Path $SourcePath -ErrorAction SilentlyContinue
        if (-not $resolvedSource) {
            Write-Error "Source path '$SourcePath' not found or is invalid."
            return
        }
        if (-not (Test-Path -Path $resolvedSource.Path -PathType Leaf)) {
            Write-Error "Source path '$($resolvedSource.Path)' is not a file."
            return
        }
        $sourceFileAbsPath = $resolvedSource.Path
        $sourceFilename = Split-Path -Path $sourceFileAbsPath -Leaf

        # --- Define and Ensure Target Directory ---
        $targetDir = Join-Path -Path $HOME -ChildPath 'setup_scripts'
        $targetPath = Join-Path -Path $targetDir -ChildPath $sourceFilename

        if (-not (Test-Path -Path $targetDir -PathType Container)) {
            if ($PSCmdlet.ShouldProcess($targetDir, "Create Directory")) {
                try {
                    New-Item -Path $targetDir -ItemType Directory -Force -ErrorAction Stop | Out-Null
                    Write-Verbose "Created directory: $targetDir"
                } catch {
                    Write-Error "Failed to create directory '$targetDir': $($_.Exception.Message)"
                    return
                }
            } else {
                Write-Warning "Directory creation skipped by user request."
                return
            }
        }

        # --- Check for Existing Target ---
        if (Test-Path -Path $targetPath) {
            Write-Error "Target path '$targetPath' already exists. Aborting to prevent overwrite."
            return
        }

        # --- Check Admin for Symlink (Informational) ---
        $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
        if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
            Write-Warning "Administrator privileges may be required to create symbolic links unless Developer Mode is enabled."
        }

        # --- Perform Operations ---
        try {
            # Move File
            if ($PSCmdlet.ShouldProcess($targetPath, "Move File from '$sourceFileAbsPath'")) {
                Move-Item -Path $sourceFileAbsPath -Destination $targetPath -Force -ErrorAction Stop -Verbose
            } else {
                 Write-Warning "Move operation skipped by user request."
                 return
            }

            # Create Symlink
            if ($PSCmdlet.ShouldProcess($sourceFileAbsPath, "Create Symlink pointing to '$targetPath'")) {
                 # Note: -Force is used here to overwrite the *link path* if it somehow still exists after move, not the target.
                 New-Item -ItemType SymbolicLink -Path $sourceFileAbsPath -Value $targetPath -Force -ErrorAction Stop -Verbose
            } else {
                 Write-Warning "Symlink creation skipped by user request. Attempting to rollback move..."
                 # Simple rollback attempt
                 Move-Item -Path $targetPath -Destination $sourceFileAbsPath -Force -ErrorAction SilentlyContinue -Verbose
                 return
            }

            # Run lazyg sync
            Write-Host "Changing location to '$targetDir' and running 'lazyg ""sync""'..."
            Push-Location -Path $targetDir -ErrorAction Stop

            if ($PSCmdlet.ShouldProcess($targetDir, "Run 'lazyg ""sync""'")) {
                # Execute the command. Adapt if 'lazyg' needs specific invocation.
                lazyg "sync"
                $lazygExitCode = $LASTEXITCODE
                if ($lazygExitCode -ne 0) {
                    Write-Warning "'lazyg ""sync""' command finished with non-zero exit code: $lazygExitCode"
                } else {
                     Write-Verbose "'lazyg ""sync""' completed successfully."
                }
            } else {
                 Write-Warning "'lazyg ""sync""' execution skipped by user request."
            }

        } catch {
            Write-Error "An error occurred: $($_.Exception.Message)"
            # Simple rollback attempt if move succeeded but symlink failed or other error
            if ((Test-Path -Path $targetPath -PathType Leaf) -and (-not (Test-Path -Path $sourceFileAbsPath))) {
                 Write-Warning "Attempting to rollback file move..."
                 Move-Item -Path $targetPath -Destination $sourceFileAbsPath -Force -ErrorAction SilentlyContinue -Verbose
            }
        } finally {
            # Ensure we always pop location if push succeeded
            if ($pwd.Path -eq (Resolve-Path $targetDir).Path) {
                 Pop-Location -ErrorAction SilentlyContinue
                 Write-Verbose "Returned to original location."
            }
        }

        # Final check to indicate overall success/failure based on existence of link and target file
        if ((Test-Path -Path $targetPath -PathType Leaf) -and (Test-Path -Path $sourceFileAbsPath -PathType SymbolicLink)) {
             Write-Host "Successfully processed '$sourceFilename'." -ForegroundColor Green
        } else {
             Write-Warning "Processing '$sourceFilename' may not have completed successfully. Please check paths."
        }
    }
}

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
Set-Alias rcupdate "Update-Profile"

# Functions
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
