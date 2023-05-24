export now=$(date -u +%Y-%m-%dT%H-%M-%S%Z)

function z() {
    local target_dir
    target_dir=$(find "$PWD" -type d -name "*$1*" -print | fzf)
    if [[ -n "$target_dir" ]]; then
        cd "$target_dir"
    fi
}

alias convertdeb='sudo alien --to-rpm'
alias convertrpm='sudo alien'

alias apptime='timeout --signal INT 1s time $1'
alias rmpipall='pip freeze --user | xargs pip uninstall -y'
alias rmpnpm='rm -rf -v $PNPM_HOME'

alias linuxservices='systemctl list-unit-files --type=service --state=enabled'
alias macosservices='sudo launchctl list'

alias chkdsk='fsck'
alias Get-Volume='sudo lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL'

alias please='sudo '

serv(){
sudo redbean -C /usr/local/bin/ca.crt -K /usr/local/bin/ca.key -p 80 -p 443 -D $1
}

rmopt() {
rm -rf -v /opt/$1
rm -rf -v /usr/local/bin/$1
rm -rf -v /usr/local/share/applications/$1.desktop
}

alias dictate='cd nerd-dictation;./nerd-dictation begin --vosk-model-dir=./model &'
alias enddictate='./nerd-dictation end'

alias nextdnsinstall='sh -c "$(curl -sL https://nextdns.io/install)"'

alias rcupdate='wget --no-cache -O ~/.bashrc https://github.com/MANICX100/setup_scripts/raw/main/.bashrc'

openperm(){
sudo chmod -R a+rwx $1
}

takeown(){
sudo chown dkendall $1
}

unhideAll(){
for file in .*; do
   mv -n "$file" "${file#.}"
done
}

hideAll(){
for file in *; do
     mv -n "$file" ".$file";
done
}

rmspecial() {
find . -type f -exec bash -c 'mv "$1" "${1//[^[:alnum:].-]/}"' _ {} \;
}

yt-dlp-trim() {
yt-dlp -f "[protocol!*=dash]" --external-downloader ffmpeg --external-downloader-args "ffmpeg_i:-ss $2 -to $3" $1
}

ffsrtspeed() {
ffmpeg -i $1 \
       -i $3 \
       -filter_complex \
          "[0:v]setpts=1/$2*PTS[v];\
           [0:a]rubberband=tempo=$2[a]" \
       -map "[v]" \
       -map "[a]" \
       -map 1 \
       -preset ultrafast \
       $($now)-output.mkv
}

burnin-srt() {
 filename=$(basename "$argv[1]")
  extension="${filename##*.}"
  base="${filename%.*}"
  ffmpeg -i "$1" -vf subtitles="$2" -preset ultrafast "$base-srt.$extension"
  }

speedupvid() {
filename=$(basename "$1")
  extension="${filename##*.}"
  base="${filename%.*}"
  ffmpeg -i "$1" -filter_complex "[0:v]setpts=1/$2*PTS[v];[0:a]rubberband=tempo=$2[a]" -map "[v]" -map "[a]" -preset ultrafast "$base-speed.$extension"
}

ffup() {
/home/dkendall/.mozilla/firefox/oewuk6x8.default-release/updater.sh
/home/dkendall/.pulse-browser/ahfzm1ye.default-alpha-1/updater.sh
/home/dkendall/.waterfox/gp3hc69r.default-release/updater.sh
}

alias netstat='ss -t -r state established'

image2txt() {
read -l -P 'Please provide the file path for the image
	' confirm
	tesseract -l eng $confirm $($now)-output-from-ocr
	cat $($now)-output-from-ocr.txt|xclip -selection c
}

run-against-all() {
for i in *; do $1 "$i"; done
}

yt-dlp-audio() {
yt-dlp -f 'ba' -x --audio-format mp3 $1
}

yt() {
cd "/home/dkendall/Videos/yt/"
yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]' 'https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg'
gohome
}

alias img2txt='image2txt'
alias mpv='mpv --ontop --force-window'
alias audit='sudo lynis --forensics && pip-audit'

alias rcview='sudo bat --paging=never --style=plain "/etc/profile.d/aliases.sh"'
alias cls='clear'
alias screenshot='gnome-screenshot -a'
alias rc='nano ~/.bashrc'

alias settings='gnome-control-center'
alias visudo='sudo nano /etc/sudoers.d/dkendall'
alias update-grub='sudo grub2-mkconfig -o /etc/grub2.cfg && sudo grub2-mkconfig -o /etc/grub2-efi.cfg'
alias edit-grub='sudo nano /etc/default/grub'
alias Get-PubIP='wget -q -O - ipinfo.io/ip'
alias e.='open .'

alias screenrec='ffmpeg -video_size 1920x1200 -framerate 60 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default output-$($now).mkv'
alias ffmpeglist='ffmpeg -list_devices true -f dshow -i dummy'

stripclip(){
	xclip -selection c -o |xargs|awk '{$1=$1};1'|xclip -selection c
    }

x(){
    if [ -f "$1" ] ; then
            case $1 in
                    *.tar.bz2)   tar xvjf "$1"    ;;
                    *.tar.gz)    tar xvzf "$1"    ;;
                    *.bz2)       bzip2 "$1"     ;;
                    *.tar.xz)    tar xf "$1"      ;;
                    *.rar)       unrar x "$1"     ;;
                    *.gz)        gunzip "$1"      ;;
                    *.tar)       tar xvf "$1"     ;;
                    *.tbz2)      tar xvjf "$1"    ;;
                    *.tgz)       tar xvzf "$1"    ;;
                    *.zip)       unzip "$1"       ;;
                    *.Z)         uncompress "$1"  ;;
                    *.7z)        7z x "$1"        ;;
                    *)           echo "Unable to extract '$1'" ;;
            esac
    else
            echo "'$1' is not a valid file"
    fi
}

neofetch > ~/.cache/neofetch
alias pfetch='bat --paging=never --style=plain ~/.cache/neofetch'
sed -i 's/65/69/g' ~/.cache/neofetch
sed -i 's/64/68/g' ~/.cache/neofetch
sed -i 's/5.2/5.5/g' ~/.cache/neofetch

alias inst='sudo dnf install'
alias up='topgrade'
alias remove='sudo dnf autoremove'

alias playtv='smplayer /home/dkendall/Videos/TV/Personal'
alias emptybin='sudo rm -rf ~/.local/share/Trash/'

deltv () {
rm -rf "/home/dkendall/Videos/TV/Personal"; cd "/home/dkendall/Videos/TV/"; mkdir Personal; cd "$HOME";
}

delyt() {
rm -rf "/home/dkendall/Videos/yt"; cd "/home/dkendall/Videos/"; mkdir yt ; cd "$HOME";
}

alias delrecent='sudo rm ~/.local/share/recently-used.xbel && sudo touch ~/.local/share/recently-used.xbel'

alias del='sudo rm -rf -v -I'

alias syncfolders='rsync -avh --ignore-existing --exclude ".*" --delete --progress /home/dkendall/ /run/media/dkendall/exFAT/'

subs() {   "$HOME/OneDrive/OpenSubtitlesDownload.py" --cli --auto --username MANICX100 --password 5z6!!Evd "$1";    }

alias unshareusb='/bin/eveusbc unshare all'
alias shareusb='/bin/eveusbc share 12345 1-9.1'

execdircmd () {   cd $("dirname" "$1") ; $2 "$1"; cd "$HOME" ;  }

macos() { cd "$HOME/macOS-Simple-KVM/" ; ./basic.sh; cd "$HOME" ;}

alias openall='xdg-open *'
alias flatten="find ./ -mindepth 2 -type f -exec mv -i '{}' . \;"
alias emptydel='find ./ -empty -type d -delete'
alias delempty='find ./ -empty -type d -delete'
alias gohome='cd "$HOME"'

orderfiles() {
for filename in *; do
  if [[ -f "$filename" ]]; then
      base=${filename%.*}
      ext=${filename#$base.}
    mkdir -p "${ext}"
    mv "$filename" "${ext}"
  fi
done
}

alias changejava='sudo alternatives --config java'

alias addapp='sudo xdg-open /usr/local/bin'
alias shut='sudo systemctl suspend'
alias clean='sudo dnf clean all && flatpak uninstall --unused'

alias logoff='sudo service sddm restart'
alias yt-dlp='/usr/local/bin/yt-dlp'
