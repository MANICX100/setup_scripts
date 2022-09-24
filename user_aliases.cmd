;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here

e.=explorer .

pwd=cd
clear=cls
unalias=alias /d $1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"

startup=start shell:startup
sendto=start shell:sendto
netw=ncpa.cpl
cat=bat $1

delpins= del /f /s /q /a "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\f01b4d95cf55d32a.automaticDestinations-ms"

speedupvid=ffmpeg -i $1 -filter_complex "[0:v]setpts=PTS/2[v];[0:a]rubberband=tempo=2[a]" -map "[v]" -map "[a]" 2.mkv

comlist=pwsh -Command "Get-WMIObject Win32_SerialPort | Select-Object Name,DeviceID,Description"

up=schtasks /run /TN Topgrade

emptybin=echo Y|pwsh.exe -NoProfile -Command Clear-RecycleBin
seq=FOR /L %G IN ($1,1,$2) DO @echo %G

delofficecache=gsudo taskkill /f /im word.exe & gsudo taskkill /f /im excel.exe & gsudo taskkill /f /im powerpoint.exe & gsudo taskkill /f /im outlook.exe & gsudo taskkill /f /im onenote.exe & gsudo taskkill /f /im teams.exe & del /s /q "%localappdata%\Microsoft\Office\16.0" & del /s /q "%appdata%\Microsoft\Teams"

rc=notepad3 "%OneDriveConsumer%\user_aliases.cmd"
datetime=pwsh "%OneDriveConsumer%\time.ps1"

x=7z x %~1 -o*
untar=tar -xzvf

openall=FOR %F IN (*.*) DO START "" "%F"

screenrec=ffmpeg -f dshow -i audio="Microphone (5- SteelSeries Arctis 1 Wireless)" -f -y -f gdigrab -framerate 30 -draw_mouse 1 -i desktop -c:v libx264 output.mkv

killqpulse=gsudo taskkill /f /im Q-Pulse.exe
killvm=gsudo taskkill /f /im vmware-vmx.exe & gsudo taskkill /f /im vmware.exe

gohome=cd %userprofile%

emptydel=for /f "delims=" %d in ('dir /s /b /ad ^| sort /r') do rd "%d"

flatten="%OneDriveConsumer%\flatten.cmd"
orderfiles=pwsh.exe "%OneDriveConsumer%\move-into-folders.ps1"

robotask=schtasks /run /TN RoboTask
restartsynergy=schtasks /run /TN stop_synergy && schtasks /run /TN start_synergy

last=gsudo powercfg /sleepstudy

column=echo $1 | /format:table
rev=echo $1| gawk "BEGIN{FS=\"\"}{for(i=NF;i>0;i--)printf $i}"

Powershell=pwsh.exe
winver="%OneDriveConsumer%\Apps\winver.lnk"
envvar=gsudo rundll32.exe sysdm.cpl,EditEnvironmentVariables
mobileapps=start shell:AppsFolder
