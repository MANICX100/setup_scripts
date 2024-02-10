printf "\e[?2004l"

set TERM linux
set fish_greeting
set now date -u +%Y-%m-%dT%H-%M-%S%Z
set -x RIPGREP_CONFIG_PATH $HOME/.ripgreprc
set -x EDITOR nvem
set -x JAVA_HOME /jdk
set -x PATH $JAVA_HOME/bin:$PATH

function fish_command_not_found
  /usr/lib/command-not-found -- $argv[1]
end

function __fish_default_command_not_found_handler
  fish_command_not_found $argv
end

alias upkernel='inst linux-image-liquorix-amd64 linux-generic -y'

alias dy="dig +noall +answer +additional $argv @dns.toys"
alias flatpakdown='flatpak remote-info --log flathub'
alias jellyfin='flatpak run org.jellyfin.JellyfinServer'
alias saveimgclip='xclip -selection clipboard -t image/png -o > /home/dkendall/Desktop/clipboard.png'
alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias errors='sudo journalctl -p err'
alias eza='eza -a'
alias build='zig build-exe'
alias cup='cargo install-update -a'
alias mpv='mpv --hwdec=auto --speed=4'
alias setresolution='xrandr --output HDMI-A-2 --mode'
alias Set-Resolution='setresolution'

alias mount='sudo mount -o rw,uid=1000,gid=1000,user,exec,umask=003'
alias sysd='sudo $EDITOR /etc/systemd/system.conf'
alias vars='set|less'
alias gpuinfo='glxinfo -B'
alias cpuinfo='sudo dmidecode --type processor'
alias gcm='whereis'
alias lite='lite-xl'
alias lite-xl='/usr/local/bin/lite-xl/lite-xl'
alias uptime='uptime --since && uptime --pretty'

alias usb='lsblk|rg sda'
alias printers='lpstat -p'
alias bluetooth='bluetoothctl devices'

alias unmountios='fusermount -u /media/dkendall/iOS'
alias mountios='ifuse /media/dkendall/iOS'
alias unmount='sudo umount'

alias fixwifi='sudo dhclient -v enp7s0'
alias edit-apt='$EDITOR /etc/apt/sources.list'
alias bufferw='sudo sync & watch -n 1 rg -e Dirty: /proc/meminfo'

alias python='$HOME/pypy/bin/pypy'
alias pip='python -m pip'
alias pip3='pip'

alias icewmkeys='$EDITOR $HOME/.icewm/keys'
alias icewmstart='$EDITOR $HOME/.icewm/startup'
alias tvn='tvnamer --recursive'
alias tvrename='tvn "$HOME/Jellyfin Server Media/TV"'
alias debversion='apt-cache policy'
alias micandsystem='pactl load-module module-loopback latency_msec=1'
alias micandsystemoff='pactl unload-module module-loopback'
alias recordall='micandsystem'
alias recordalloff='micandsystemoff'
alias uninstall='remove'
alias de='ls -l /usr/share/xsessions/'
alias loginmgr='bat /etc/X11/default-display-manager'
alias nom='$HOME/go/bin/nom'
alias kdesudo='lxqt-sudo'
alias gksu='kdesudo'
alias pkexec='kdesudo'
alias su='sudo'

# macOS
alias afconvert='ffmpeg'
alias afinfo='mediainfo'
alias afplay='mpv'
alias airport='networkstatus'
alias alloc='free'
alias apropos='tldr'
alias automator='echo Automator not configured'
alias asr='echo Restore not necessary'
alias atsutil='fc-cache -vf'
alias bless='echo All bootable OK'
alias pmset='systemctl'
alias softwareupdate='up'
alias caffeinate='caffeine'
alias textutil='vips'
alias mdfind='fd'
alias locate='fd'
alias networkquality='speedtest-cli'
alias screencapture='scrot'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias say='espeak'
alias sips='vipsthumbnail'
alias networksetup='nmcli'
alias qlmanage='feh'
#alias brew='$HOME/homebrew/bin/brew'

alias mkfs.ntfs='mkfs.ntfs --fast'
alias mkfs.ext4='mkfs.ext4 -E lazy_itable_init'
alias Invoke-Item='xdg-open'
alias Start-Process='xdg-open'
alias open='xdg-open'
alias move='mv'
alias rename='mv'
alias copy='cpr'
alias remove-item='rm'
alias remove-item-r='rm -r'
alias get-content='bat'
alias gci='bat'
alias gc='bat'
alias invoke-restmethod='irm'
alias irm='curl'
alias invoke-expression='iex'
alias iex='eval'
alias drivers='sudo lspci -v'
alias logs='sudo journalctl|less|rg -i'
alias convertdeb='sudo alien --to-rpm'
alias convertrpm='sudo alien'
alias gitc='git clone --depth 1'
alias edit-dns='sudo $EDITOR /etc/resolv.conf'
alias edit-hosts='sudo $EDITOR /etc/hosts'
alias fd='fzf --query'
alias webcam='sudo modprobe v4l2loopback'
alias cloudsync='onedrive --synchronize --force'

alias ffmpeg='$HOME/ffmpeg/ffmpeg'
alias ffprobe='mediainfo'
alias qt-faststart='$HOME/ffmpeg/qt-faststart'

alias linuxservices='systemctl list-unit-files --type=service --state=enabled'
alias macosservices='sudo launchctl list'
alias checkfiles='rsync --checksum --dry-run -rvn /media/dkendall/exFAT/ $HOME/'
alias dl='axel -a -n 16'
alias dls='aria2c --enable-rpc=true --rpc-allow-origin-all=true --rpc-listen-all=true --console-log-level=error -x 16'
alias rpmall='sudo rpm -Uvh *'
alias chkdsk='fsck'
alias Get-Volume='sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL | rg -v loop'
alias default='kcmshell5 filetypes'
alias rmpipall='pip freeze --user | xargs pip uninstall -y'
alias rmpnpm='rm -rf -v $PNPM_HOME'
alias fishpath='echo $fish_user_paths | tr " " "\n" | nl'
alias nextdnsinstall='sh -c "$(curl -sL https://nextdns.io/install)"'
alias e.='open .'
alias uefi='systemctl reboot --firmware-setup'
alias tldr='/usr/local/bin/tldr'
alias img2txt='image2txt'
alias networkstatus='nmcli dev status'
alias inst='sudo nala install'
alias remove='sudo nala remove'
alias purge='sudo nala purge'
alias netstat='ss -t -r state established'
alias ipconfig='ip route'
alias ifconfig='ip route'
alias cleanup='clean'
alias audit='sudo lynis --forensics && pip-audit'
alias rcview='bat --paging=never --style=plain $HOME/.config/fish/config.fish'
alias batc='bat --paging=never --style=plain'
alias lsh='ls -lah -U'
alias lsf='ls -d "$PWD"/*'
alias cls='clear'
alias rc='$EDITOR $HOME/.config/fish/config.fish'
alias visudo='sudo $EDITOR /etc/sudoers.d/dkendall'
alias edit-grub='sudo $EDITOR /etc/default/grub'
alias pfetch='bat --paging=never --style=plain $HOME/.cache/neofetch'
alias instrpm='sudo rpm -ivh --force'
alias gdebi='sudo gdebi'
alias instdeb='gdebi'
alias delrecent='rm $HOME/.local/share/recently-usd.xbel && sudo touch $HOME/.local/share/recently-usd.xbel'
alias rm='rm -rf -v'
alias unshareusb='/bin/eveusbc unshare all'
alias shareusb='/bin/eveusbc share 12345 1-9.1'
alias screenrec='ffmpeg -video_size 1920x1200 -framerate 60 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default output-"$($now)".mkv'
alias ffmpeglist='ffmpeg -list_devices true -f dshow -i dummy'
alias flatten="find ./ -mindepth 2 -type f -exec mv -i '{}' . \;"
alias emptydel='find ./ -empty -type d -delete'
alias delempty='emptydel'
alias gohome='cd "$HOME"'
alias changejava='sudo alternatives --config java'
alias addapp='xdg-open /usr/local/bin'
alias logoff='sudo pkill -u dkendall'
alias logout='logoff'
alias yt-dlp='/usr/local/bin/yt-dlp'

function certinfo
  gnutls-cli --print-cert $argv[1] < /dev/null | certtool --certificate-info
end

function ffup
parallel ::: "xfe $HOME" "axel -n 16 -o $HOME/user.js https://raw.githubusercontent.com/MANICX100/setup_scripts/main/user-overrides.js $HOME/user.js" "xfe $HOME/.var/app/org.mozilla.firefox/.mozilla/firefox/0v4n3hk1.default-release/"
end

function boostvolume
  pactl list | rg -oP 'Sink #\\K(\[0-9\]+)' | while read -l i
    pactl -- set-sink-volume $i +100%
  end
end

function resetvolume
  pactl list | rg -oP 'Sink #\\K(\[0-9\]+)' | while read -l i
    pactl -- set-sink-volume $i 100%
  end  
end

function rmr
  find . -type f -name $argv -delete
end

function makeproject
    mkdir -p $argv[1]
    cd $argv[1]

    mkdir lib res src

    touch .gitignore
    touch .gitmodules
    touch LICENSE 
    touch README.md
    touch build.zig

    echo "Created project: $argv[1]"
end

function cpr
  set source_file $argv[1]
  set target_dir $argv[2]
  
  rsync -avAXESlHh --no-whole-file --size-only $source_file $target_dir
end

function cmdpath --argument pid
  ps -p $pid -o cmd= | pbcopy
end

function clean
flatpak uninstall --unused
sudo nala autoremove -y
sudo nala clean
appman -c
end

function rmcache
rm -rf $HOME/.cache
sudo rm -rfv /var/tmp/flatpak-cache-*
echo 3 | sudo tee /proc/sys/vm/drop_caches
end

function timeweb
curl -L -w "time_namelookup: %{time_namelookup}\ntime_connect: %{time_connect}\ntime_appconnect: %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect: %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}\n" $argv
end

function systemctl
    command sudo systemctl $argv; and watch -n 1 systemctl status $argv
end

function essentialpkgs
	dpkg-query -Wf '${Package;-40}${Priority}\n' | rg "required"
end

function displayserv
	printf 'Session is: %s\n' "${DISPLAY:+X11}${WAYLAND_DISPLAY:+WAYLAND}"
end

function icewmup
rm $HOME/.icewm/keys
axel -n 16 -o $HOME/.icewm/keys "https://raw.githubusercontent.com/MANICX100/setup_scripts/main/icewm-keys"
icesh restart
gohome
end

function setresolutionall
    for output in (xrandr | rg " connected" | frawk '{ print $1 }')
        xrandr --output $output --mode $argv[1]
    end
end

function all
    for file in (ls .)
        $argv $file
    end
end

function reinstall
    set packagename $argv[1]
    if test -n "$packagename"
        sudo nala remove -y $packagename
        sudo nala install -y $packagename
    else
        echo "Usage: reinstall <packagename>"
    end
end

function revsyncfolders
	rmcache
	sudo mount -o rw,uid=1000,gid=1000,user,exec,umask=003 /dev/sda1 /media/dkendall/exFAT
	rsync -avAXESlHh --delete --no-compress --no-whole-file --size-only /media/dkendall/exFAT/Linux $HOME/ 
	sudo mount -o rw,uid=1000,gid=1000,user,exec,umask=003 /dev/nvme1n1p4 /media/dkendall/windows
	rsync -avAXESlHh --delete --no-compress --no-whole-file --size-only /media/dkendall/exFAT/Windows /media/dkendall/windows/Users/dkendall/ 
	sudo umount /dev/sda1
	sudo umount /dev/nvme1n1p4
end

function syncfolders
	rmcache
	sudo mount -o rw,uid=1000,gid=1000,user,exec,umask=003 /dev/sda1 /media/dkendall/exFAT
	rsync -avAXESlHh --delete --no-compress --no-whole-file --size-only $HOME/ /media/dkendall/exFAT/Linux
	sudo mount -o rw,uid=1000,gid=1000,user,exec,umask=003 /dev/nvme1n1p4 /media/dkendall/windows
	rsync -avAXESlHh --delete --no-compress --no-whole-file --size-only /media/dkendall/windows/Users/dkendall/ /media/dkendall/exFAT/Windows
	sudo umount /dev/sda1
	sudo umount /dev/nvme1n1p4
end

function please --wraps=sudo
    if functions -q -- "$argv[1]"
        set cmdline (
            for arg in $argv
                printf "\"%s\" " $arg
            end
        )
        set -x function_src (string join "\n" (string escape --style=var (functions "$argv[1]")))
        set argv fish -c 'string unescape --style=var (string split "\n" $function_src) | source; '$cmdline
        command sudo -E $argv
    else
        command sudo $argv
    end
end

function up
    if topgrade
        git -C $HOME/powerlevel10k pull
    end
end

function display_path
    echo $PATH
end

function remove_from_path
    set -l temp_path $PATH
    set -e temp_path[(contains -i $argv[1] $temp_path)]
    set PATH $temp_path
end

function extract
    if test (count $argv) -eq 0
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    end

    for n in $argv
        if not test -f $n
            echo "'$n' - file doesn't exist"
            return 1
        end

        switch (string trim -r -c ',' -- $n)
          case "*.cbt" "*.tar.bz2" "*.tar.gz" "*.tar.xz" "*.tbz2" "*.tgz" "*.txz" "*.tar"
                       tar zxvf $n ;;
          case "*.lzma"
                      unlzma ./$n ;;
          case "*.bz2"
                      bunzip2 ./$n ;;
          case "*.cbr" "*.rar"
                      unrar x -ad ./$n ;;
          case "*.gz"
                      gunzip ./$n ;;
          case "*.cbz" "*.epub" "*.zip"
                      unzip ./$n ;;
          case "*.z"
                      uncompress ./$n ;;
          case "*.7z" "*.apk" "*.arj" "*.cab" "*.cb7" "*.chm" "*.deb" "*.iso" "*.lzh" "*.msi" "*.pkg" "*.rpm" "*.udf" "*.wim" "*.xar" "*.vhd"
                      7z x ./$n ;;
          case "*.xz"
                      unxz ./$n ;;
          case "*.exe"
                      cabextract ./$n ;;
          case "*.cpio"
                      cpio -id < ./$n ;;
          case "*.cba" "*.ace"
                      unace x ./$n ;;
          case "*.zpaq"
                      zpaq x ./$n ;;
          case "*.arc"
                      arc e ./$n ;;
          case "*.cso"
                      ciso 0 ./$n ./$n.iso
                      extract $n.iso
                      rm -f $n ;;
          case "*.zlib"
                      zlib-flate -uncompress < ./$n > ./$n.tmp
                      mv ./$n.tmp ./(string replace -r '.zlib$' '' -- $n)
                      rm -f $n ;;
          case "*.dmg"
                      hdiutil mount ./$n -mountpoint ./$n.mounted ;;
          case '*'
                      echo "extract: '$n' - unknown archive method"
                      return 1
                      ;;
        end
    end
end

function onedrivelink
    if test -n "$argv" 
        set filename $argv
        set homedir (eval echo ~)"/OneDrive/"$filename
        if test -e $homedir
            sudo ln -s $homedir /usr/local/bin/$filename
            sudo chmod +x /usr/local/bin/$filename
            echo "Symlink created and execution permission granted."
        else
            echo "The file does not exist in the OneDrive folder."
        end
    else
        echo "Please provide a filename."
    end
end


function projectdl -a repo

set -l user (string split / $repo)[1]

set -l project (string split / $repo)[2]

set -l release_info (curl -s https://api.github.com/repos/$user/$project/releases/latest)

set -l asset_info (echo $release_info | jq -r '.assets[] | "\(.name) \(.browser_download_url)"')

echo "Please choose a file to download:"

for i in (seq (count $asset_info))

echo $i": "(string split " " $asset_info[$i])[1]

end

read -l choice

set -l url (echo $asset_info[$choice] | frawk '{print $NF}')

axel -n 16 -o /usr/local/bin $url

set -l filename (string split / $url)[-1]

chmod +x /usr/local/bin/$filename

echo "Do you want to extract the downloaded file? (yes/no)"

read -l extract

if test $extract = "yes"

echo "Extracting the downloaded file..."

extract /usr/local/bin/$filename

echo "Extraction completed."

end

end

function playtv
for file in $HOME/Videos/Personal/*
        xdg-open "$file"
    end
end

function openall
    for file in *
        if test -f $file
            xdg-open $file
        end
    end
end

function rename-item
    mv $argv[1] $argv[2]
end

function fp
    if test (count $argv) -eq 0
        echo "Usage: fp <application-name>"
        return
    end

    set app_name $argv[1]

    # Find the application ID
    set app_id (flatpak list --app --columns=name,application | frawk -v app="$app_name" '{ if ($1 == app) { print $2 } }')

    if test -z "$app_id"
        echo "No application found with the name: $app_name"
        return
    end

    flatpak run $app_id
end

function replaceline
    set -l lineNumber $argv[1]
    set -l replacement $argv[2]
    set -l filePath $argv[3]
    set -l tempFile $filePath"_temp"

    frawk -v n="$lineNumber" -v s="$replacement" 'NR == n {print s; next} {print}' $filePath > $tempFile

    # replace original file with the temp file
    mv $tempFile $filePath
end

function gitsetup
git config --global user.name "Danny Kendall"
git config --global user.email "d.manicx100@gmail.com"
git config --global rebase.updateRefs true
git config --global credential.helper store
git config --global --add push.default current
git config --global --add push.autoSetupRemote true
end

function instsearch

  if test (count $argv) -eq 0
    echo "Please provide a package name."
    return 1
  end

  set -l pkg_name $argv[1]

  echo "Searching for package '$pkg_name'"

  # Search in dpkg
  if type dpkg >/dev/null 2>&1
    echo "=== DEB ==="
    dpkg -l | rg -i $pkg_name
  end

  # Search in flatpak
  if type flatpak >/dev/null 2>&1
    echo "=== FLATPAK ==="
    flatpak list | rg -i $pkg_name
  end

  # Search in snap
  if type snap >/dev/null 2>&1
    echo "=== SNAP ==="
    snap list | rg -i $pkg_name
  end

  # Search in am
  if type am >/dev/null 2>&1
    echo "=== APPIMAGES ==="
    am -f | rg -i $pkg_name
  end

  # Search in dnf
  if type dnf >/dev/null 2>&1
    echo "=== RPM ==="
    dnf list installed | rg -i $pkg_name
  end

  # Search in zypper
  if type zypper >/dev/null 2>&1
    echo "=== RPM ==="
    zypper se -i | rg -i $pkg_name
  end

  # Search in paru
  if type paru >/dev/null 2>&1
    echo "=== AUR ==="
    paru -Q | rg -i $pkg_name
  end

  # Search in brew
  if type brew >/dev/null 2>&1
    echo "=== BREW ==="
    brew list | rg -i $pkg_name
  end

  # Search in mas
  if type mas >/dev/null 2>&1
    echo "=== APPSTORE ==="
    mas list | rg -i $pkg_name
  end

end

function pkgsearch

  if test (count $argv) -eq 0
    echo "Please provide a package name."
    return 1
  end

  set -l pkg_name $argv[1]

  echo "Searching for package '$pkg_name'"

  if type -q dpkg
    # Search in apt
    echo "=== DEB ==="
    apt-cache search $pkg_name | rg -i $pkg_name
  end

  if type -q dnf
    # Search in dnf
    echo "=== RPM ==="
    dnf search $pkg_name
  end

  if type -q zypper
    # Search in zypper
    echo "=== RPM ==="
    zypper se $pkg_name
  end

  if type -q paru
    # Search in paru
    echo "=== AUR ==="
    paru -Ss $pkg_name
  end

  if type -q brew
    # Search in brew
    echo "=== BREW ==="
    brew search $pkg_name
  end

  # Search in flatpak
  if type -q flatpak
    echo "=== FLATPAK ==="
    flatpak remote-ls flathub | rg -i $pkg_name
  end

  # Search in snap
  if type -q snap
    echo "=== SNAP ==="
    snap find $pkg_name
  end

  # Search in am
  if type -q am
    echo "=== APPIMAGES ==="
    am -q $pkg_name
  end

  if type -q mas
    # Search in mas
    echo "=== APPSTORE ==="
    mas search $pkg_name
  end

end

function disable-all-network-interfaces
    if type -q ip
        for iface in (ip link show | rg '^[0-9]' | frawk -F: '{print $2}' | string trim)
            echo "Disabling $iface"
            sudo ip link set $iface down
        end
    else
        for service in (networksetup -listallnetworkservices | string trim)
            echo "Disabling $service"
            sudo networksetup -setnetworkserviceenabled $service off
        end
    end
end

function enable-all-network-interfaces
    if type -q ip
        for iface in (ip link show | rg '^[0-9]' | frawk -F: '{print $2}' | string trim)
            echo "Enabling $iface"
            sudo ip link set $iface up
        end
    else
        for service in (networksetup -listallnetworkservices | string trim)
            echo "Enabling $service"
            sudo networksetup -setnetworkserviceenabled $service on
        end
    end
end

function networkcycle
disable-all-network-interfaces
enable-all-network-interfaces
end

function Resync-Time
  if not command -v ntpdate >/dev/null
    echo "ntpdate is not installed. Please install it and try again."
    return 1
  end
  
  echo "Resyncing system time..."
  sudo ntpdate pool.ntp.org
end

function download_yt_video
    set resolution $argv[1]
    set video_url $argv[2]
    set command "yt-dlp -f \"bestvideo[height<=$resolution]+bestaudio/best[height<=$resolution]\" \"$video_url\""
    eval $command
end

function z
    set -l target_dir (find $PWD -type d -name "*$argv[1]*" -print | fzf)
    if test -n "$target_dir"
        cd $target_dir
    end
end

function fdo
    set query (string join " " $argv)
    set selected_file (fzf --query "$query")
    xdg-open "$selected_file"
end

function git_unsynced
    bash -c 'for dir in $(find . -name .git -type d -prune); do
                  if ! git -C "${dir%/*}" diff --quiet; then
                      echo "$dir has uncommitted changes"
                      git -C "${dir%/*}" status --short
                  fi
              done'
end

function burnin_srt
    set filename (basename "$argv[1]")  # get the full file name
    set base (echo $filename | sd '\.[^.]+$' '')  # get the file name without the extension
    set subtitle (echo $argv[1] | sd '\.[^.]+$' '.srt')
    ffmpeg -i "$argv[1]" -vf subtitles="$subtitle" -preset ultrafast -threads 0 "$base-srt.mkv"
end

function speedupvid
    set filename (basename "$argv[1]")  # get the full file name
    set extension (echo $filename | sd '.*\.' '')  # get the extension
    set base (echo $filename | sd '\.[^.]+$' '')  # get the file name without the extension
    ffmpeg -i "$argv[1]" -filter_complex "[0:v]setpts=1/$argv[2]*PTS[v];[0:a]atempo=$argv[2][a]" -map "[v]" -map "[a]" -preset ultrafast -threads 0 "$base-speed.mkv"
end

function burnin_srt_all
  for file in *.mp4 *.avi *.mkv
    if test -f "$file"
      burnin_srt "$file"
	rm "$file"
    end
  end
end

function speedupvid_all
  for file in *.mp4 *.avi *.mkv
    if test -f "$file"
      speedupvid "$file" 1.2
	rm "$file"
	rm *.srt
    end
  end
end

function create_empty_srt_files
    for f in *.mp4 *.mkv *.avi
        if test -f "$f"
            set base (string replace -r -- '\.[^.]*$' '' "$f")
            set srt_file "$base.srt"
            if not test -f "$srt_file"
                touch "$srt_file"
            end
        end
    end
end

function unhide_files
    bash -c 'for file in .*; do mv "$file" "${file#.}"; done'
end

function hide_files
    bash -c 'for file in *; do [[ -f $file ]] && mv "$file" ".$file"; done'
end

function tgupdate
rm $HOME/.config/topgrade.toml
axel -n 16 -o $HOME/.config/topgrade.toml "https://github.com/MANICX100/setup_scripts/raw/main/topgrade_lin.toml"
topgrade
end

function serv
	sudo redbean -C /usr/local/bin/ca.crt -K /usr/local/bin/ca.key -p 80 -p 443 -D $argv
end

function rmopt
	rm -rf -v /opt/$argv
	rm -rf -v /usr/local/bin/$argv
	rm -rf -v /usr/local/share/applications/$argv.desktop
end

function openperm
	sudo chmod -R a+rwx $argv
end

function takeown
	sudo chown dkendall $argv
end

function rmspecial
	find . -type f -exec bash -c 'mv "$1" "${1//[^[:alnum:].-]/}"' _ {} \;
	unhide_files
end

function dictate
	cd nerd-dictation
	./nerd-dictation begin --vosk-model-dir=./model &
end

function enddictate
	./nerd-dictation end
	gohome
end

function yt-dlp-trim
	yt-dlp -f "[protocol!*=dash]" --external-downloader ffmpeg --external-downloader-args "ffmpeg_i:-ss $argv[2] -to $argv[3]" $argv[1]
end

function ffsrtspeed
	ffmpeg -i $argv[1] \
       -i $argv[3] \
       -filter_complex \
          "[0:v]setpts=1/$argv[2]*PTS[v];\
           [0:a]rubberband=tempo=$argv[2][a]" \
       -map "[v]" \
       -map "[a]" \
       -map 1 \
       -preset ultrafast \
       $($now)-output.mkv
end 

function image2txt
	read -l -P 'Please provide the file path for the image
	' confirm
	tesseract -l eng $confirm $($now)-output-from-ocr
	cat $($now)-output-from-ocr.txt|xclip -selection c
end

function yt-dlp-audio
	yt-dlp -f 'ba' -x --audio-format mp3 $argv
end

function Get-PubIP
	wget --no-cache -q -O - ipinfo.io/ip
end

function bak
	zip -r $HOME/$($now)-bak.zip /etc/default/ /etc/profile.d/ /usr/local/bin /opt/
end

function stripclip
	xclip -selection c -o | xargs | rg -o '.*' | xclip -selection c
end

function rcupdate
rm $HOME/.config/fish/config.fish
axel -n 16 -o $HOME/.config/fish/config.fish https://github.com/MANICX100/setup_scripts/raw/main/fish_aliases.fish
. $HOME/.config/fish/config.fish
end

set -g osinfo (rg -ioP '^ID=\K.+' /etc/os-release)

neofetch > $HOME/.cache/neofetch

neofetch > $HOME/.cache/neofetch
sd 6500 6900 $HOME/.cache/neofetch
sd 6400 6800  $HOME/.cache/neofetch
sd 3.201 6.0 $HOME/.cache/neofetch

function flushdns
sudo resolvectl flush-caches
echo "Successfully flushed the DNS Resolver Cache"
end

function orderfiles                                                           
    set list ./**.*                      
    for val in $list
    set ext (path extension -- $val | string replace . "")
    mkdir -p "$ext" 
    cp $val "./$ext" 
    end                                        
end 

function subs
 cd $("dirname" "$argv") ;
 "$HOME/OneDrive/OpenSubtitlesDownload.py" --cli --auto --username MANICX100 --password 5z6!!Evd "$1";
 cd "$HOME";
end

function yt
    cd "$HOME/Videos/yt/"
    yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]' 'https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg' --external-downloader axel --external-downloader-args "-n 16";
    cd "$HOME";
end

function deltv
    rm -rf "$HOME/Videos/Personal"; cd "$HOME/Videos/"; mkdir Personal; cd "$HOME";
end

function delyt
    rm -rf "$HOME/Videos/yt"; cd "$HOME/Videos/"; mkdir yt ; cd "$HOME";
end

function lazyg
  git add .
  git commit -a -m "$argv"
  git push
end

function newgit
  git add .
  git commit -a --allow-empty-message -m " "
  git push
end

function gitprep
	git stash
	git pull
	git stash pop
end

function gitIgnoreRm
	git rm -r --cached .
	git add .
	git commit -m "Update .gitignore"
end

if test -s "$HOME/.bun/_bun"
    source "$HOME/.bun/_bun"
end

set -x BUN_INSTALL "$HOME/.bun"
set -x PATH "$BUN_INSTALL/bin" $PATH

