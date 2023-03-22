set fish_greeting
set now date -u +%Y-%m-%dT%H-%M-%S%Z

alias python='python3.11'

alias gitc="git clone --depth 1"
alias gc="gitc"

alias fd="fzf --query"
alias fdo="fzf --query $argsv | xargs -o open"

alias lr='zypper lr'
alias ffmpeg='/usr/local/bin/ffmpeg/ffmpeg'

alias linuxservices='systemctl list-unit-files --type=service --state=enabled'
alias macosservices='sudo launchctl list'

alias checkfiles='rsync --checksum --dry-run -rvn /run/media/dkendall/exFAT/ /home/dkendall/'

alias jellyfin='dotnet /home/dkendall/jellyfin/jellyfin.dll'

alias dl='aria2c -x 16'
alias dls='aria2c --enable-rpc=true -x 16'

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
	set base (echo $filename | sed 's/\.[^.]*$//')  # get the file name without the extension
	set subtitle (echo $argv[1] | sed 's/\.[^.]*$/.srt/')
	ffmpeg -i "$argv[1]" -vf subtitles="$subtitle" -preset ultrafast -threads 0 "$base-srt.mkv"
end

function speedupvid
	set filename (basename "$argv[1]")  # get the full file name
	set extension (echo $filename | sed 's/^.*\.//')  # get the extension
	set base (echo $filename | sed 's/\.[^.]*$//')  # get the file name without the extension
	ffmpeg -i "$argv[1]" -filter_complex "[0:v]setpts=1/$argv[2]*PTS[v];[0:a]rubberband=tempo=$argv[2][a]" -map "[v]" -map "[a]" -preset ultrafast -threads 0 "$base-speed.mkv"
end

function convert_videos
    for f in *.mkv *.avi
        if test -f "$f"
            bash -c 'ffmpeg -i "$0" -c:v mpeg4 -c:a aac -b:a 192k "${0%.mkv}.mp4"' "$f"
        end
    end
end

function burnin_srt_all
  for file in *.mp4 *.avi *.mkv
    if test -f "$file"
      burnin_srt "$file"
    end
  end
end

function speedupvid_all
  for file in *.mp4 *.avi *.mkv
    if test -f "$file"
      speedupvid "$file" 1.2
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

function rename_videos
    bash -c 'for file in *.mp4 *.avi; do mv "$file" "${file%.*}.mkv"; done'
end

function trash_movies
    for file in *.mkv *.avi *.mp4
        if test (echo $file | rg -v -- -speed) != ""
            trash $file
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
	aria2c --max-connection-per-server=16 -d ~/.config/ -o topgrade.toml -c --allow-overwrite=true "https://github.com/MANICX100/setup_scripts/raw/main/topgrade.toml"
end

function serv
	sudo redbean -C /usr/local/bin/ca.crt -K /usr/local/bin/ca.key -p 80 -p 443 -D $argv
end

alias rpmall='sudo rpm -Uvh *'

alias chkdsk='fsck'
alias Get-Volume='sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL'

alias apptime='timeout --signal INT 1s time $argv'

alias rmpipall='pip freeze --user | xargs pip uninstall -y'
alias rmpnpm='rm -rf -v $PNPM_HOME'

alias fishpath='echo $fish_user_paths | tr " " "\n" | nl'
alias nextdnsinstall='sh -c "$(curl -sL https://nextdns.io/install)"'

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

alias e.='open .'
alias uefi='systemctl reboot --firmware-setup'

alias tldr='/usr/local/bin/tldr'

function bak
	zip -r ~/$($now)-bak.zip /etc/default/ /etc/profile.d/ /usr/local/bin /opt/
end

alias img2txt='image2txt'

function ffup
	/home/dkendall/.mozilla/firefox/oewuk6x8.default-release/updater.sh
	/home/dkendall/.pulse-browser/ahfzm1ye.default-alpha-1/updater.sh
	/home/dkendall/.waterfox/gp3hc69r.default-release/updater.sh
end

alias netstat='ss -t -r state established'

alias ipconfig='ip route'
alias ifconfig='ip route'

alias cleanup='clean'

function stripclip
	xclip -selection c -o |xargs|awk '{$1=$1};1'|xclip -selection c
end

alias mpv='mpv --ontop --force-window'
alias audit='sudo lynis --forensics && pip-audit'
alias rcview='bat --paging=never --style=plain ~/.config/fish/config.fish'
alias bat='bat --paging=never --style=plain'
alias ls='ls -lah -U'

alias cls='clear'
alias screenshot='gnome-screenshot -a'
alias rc='nano ~/.config/fish/config.fish'
alias settings='gnome-control-center'
alias visudo='sudo nano /etc/sudoers.d/dkendall'
alias update-grub='sudo grub2-mkconfig -o /etc/grub2.cfg && sudo grub2-mkconfig -o /etc/grub2-efi.cfg'
alias edit-grub='sudo nano /etc/default/grub'

function rcupdate
	aria2c -x 16 -d ~/.config/fish -o config.fish --allow-overwrite=true https://github.com/MANICX100/setup_scripts/raw/main/fish_aliases.fish
end

set -g osinfo (rg -ioP '^ID=\K.+' /etc/os-release)

neofetch > ~/.cache/neofetch
alias pfetch='bat --paging=never --style=plain ~/.cache/neofetch'
sed -i 's/65/69/g' ~/.cache/neofetch
sed -i 's/64/68/g' ~/.cache/neofetch
sed -i 's/5.6/6.0/g' ~/.cache/neofetch

alias inst='sudo zypper install'
alias remove='sudo zypper remove'

alias up='topgrade'
alias instrpm='sudo rpm -ivh --force'
alias instdeb='sudo dpkg --force-all -i'

function uefi
	switch $osinfo
	    case fedora
			systemctl reboot --firmware-setup
	    case rebornos
			systemctl reboot --firmware-setup
	    case debian
			systemctl reboot --firmware-setup
	    case '*'
			sudo nvram "recovery-boot-mode=unused"
			sudo reboot
	end
end

alias playtv='smplayer /home/dkendall/Videos/TV/Personal'
alias emptybin='sudo rm -rf ~/.local/share/Trash/'

alias delrecent='sudo rm ~/.local/share/recently-used.xbel && sudo touch ~/.local/share/recently-used.xbel'

alias rm='rm -rf -v'

alias syncfolders='rsync -avh --ignore-existing --exclude ".*" --delete --progress --compress --no-whole-file /home/dkendall/ /run/media/dkendall/exFAT/'

alias unshareusb='/bin/eveusbc unshare all'
alias shareusb='/bin/eveusbc share 12345 1-9.1'

alias screenrec='ffmpeg -video_size 1920x1200 -framerate 60 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default output-$($now).mkv'
alias ffmpeglist='ffmpeg -list_devices true -f dshow -i dummy'

alias openall='xdg-open *'

alias flatten="find ./ -mindepth 2 -type f -exec mv -i '{}' . \;"

alias emptydel='find ./ -empty -type d -delete'
alias delempty='find ./ -empty -type d -delete'

alias gohome='cd "$HOME"'

alias changejava='sudo alternatives --config java'

alias addapp='xdg-open /usr/local/bin'

alias shut='sudo systemctl suspend'

alias logoff='sudo service sddm restart'
alias yt-dlp='/usr/local/bin/yt-dlp'

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

function macos
	cd "$HOME/macOS-Simple-KVM/" ; ./basic.sh; cd "$HOME" ;
end

function yt
    cd "/home/dkendall/Videos/yt/"
    yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]' 'https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg';
    cd "$HOME";
end

function deltv
    rm -rf "/home/dkendall/Videos/Personal"; cd "/home/dkendall/Videos/"; mkdir Personal; cd "$HOME";
end

function delyt
    rm -rf "/home/dkendall/Videos/yt"; cd "/home/dkendall/Videos/"; mkdir yt ; cd "$HOME";
end

function x
    cd $("dirname" "$argv") ;
    extract $argv;
    cd "$HOME";
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
