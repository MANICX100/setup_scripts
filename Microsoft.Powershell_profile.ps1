#edit via notepad3 $profile

function e. {explorer .}

function foldersize {
Get-ChildItem -Force | Add-Member -Force -Passthru -Type ScriptProperty -Name Length -Value {Get-ChildItem $this -Recurse -Force | Measure-Object -Sum Length | Select-Object -Expand Sum } | Sort-Object Length -Descending | Format-Table @{label="TotalSize (MB)";expression={[Math]::Truncate($_.Length / 1MB)};width=14}, @{label="Mode";expression={$_.Mode};width=8}, Name
}

function startup {
start-process shell:startup
}

function sendto {
start-process shell:sendto
}

function netw{ncpa.cpl}
function cat{bat $1}

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
gsudo netsh interface set interface "WiFi" disable
gsudo netsh interface set interface "WiFi" enable
}

function fixwifi{
gsudo netsh interface set interface "NextDNS" disable
gsudo netsh interface set interface "NextDNS" enable
}

function delofficecache{
taskkill /f /im word.exe
taskkill /f /im excel.exe
taskkill /f /im powerpoint.exe
taskkill /f /im outlook.exe
taskkill /f /im onenote.exe
taskkill /f /im teams.exe
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
gsudo taskkill /f /im Q-Pulse.exe
}

function killvm{
gsudo taskkill /f /im vmware-vmx.exe
gsudo taskkill /f /im vmware.exe
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

Function bitbucketrepo {Set-Location "$env:OneDriveCommercial\Documents\dev\bitbucket"}

function lazygit {
  param(
	[Parameter(ValueFromRemainingArguments = $true)]
	[String[]] $message
  )
  git add .
  git commit -a -m "$message"
  git push
}

Set-Alias -Name bak -Value backup
Set-Alias -Name bitgit -Value bitbucketrepo
Set-Alias -Name Powershell -Value pwsh