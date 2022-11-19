speedupvid() {
ffmpeg -i $1 -filter_complex "[0:v]setpts=1/$2*PTS[v];[0:a]rubberband=tempo=$2[a]" -map "[v]" -map "[a]" output.mkv
}

image2txt() {
read -l -P 'Please provide the file path for the image
	' confirm
	tesseract -l eng $confirm output_from_ocr
	cat output_from_ocr.txt|xclip -selection c
}

run-against-all() {
for i in *; do $1 "$i"; done
}

yt-dlp-audio() {
yt-dlp -f 'ba' -x --audio-format mp3 $1
}

yt() {
cd "/home/dkendall/Videos/yt/"
yt-dlp -f 'bv*[height=360]+ba' --download-archive videos.txt  https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg
}

alias img2txt='image2txt'
alias mpv='mpv --ontop --force-window'
alias audit='sudo lynis --forensics && pip-audit'
alias rcview='sudo bat --paging=never --style=plain "/etc/profile.d/aliases.sh"'
alias cls='clear'
alias screenshot='gnome-screenshot -a'
alias rc='sudo nano /etc/profile.d/aliases.sh'
alias settings='gnome-control-center'
alias visudo='sudo nano /etc/sudoers.d/dkendall'
alias update-grub='sudo grub2-mkconfig -o /etc/grub2.cfg && sudo grub2-mkconfig -o /etc/grub2-efi.cfg'
alias edit-grub='sudo nano /etc/default/grub'
alias Get-PubIP='wget -q -O - ipinfo.io/ip'
alias e.='open .'

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
sed -i 's/6500/6900/g' ~/.cache/neofetch
sed -i 's/6400/6800/g' ~/.cache/neofetch
sed -i 's/3.400/5.500/g' ~/.cache/neofetch

alias inst='sudo dnf install'
alias up='topgrade'
alias remove='sudo dnf autoremove'

alias playtvmpv='mpv /home/dkendall/Videos/TV/Personal'
alias emptybin='sudo rm -rf ~/.local/share/Trash/'

deltv () {
rm -rf "/home/dkendall/Videos/TV/Personal"; cd "/home/dkendall/Videos/TV/"; mkdir Personal; cd "$HOME";
}

delyt() {
rm -rf "/home/dkendall/Videos/yt"; cd "/home/dkendall/Videos/"; mkdir yt ; cd "$HOME";
}

alias delrecent='sudo rm ~/.local/share/recently-used.xbel && sudo touch ~/.local/share/recently-used.xbel'

alias del='sudo rm -rf -v -I'

alias syncfolders='rsync -progress -avh --ignore-existing /home/dkendall/ /run/media/dkendall/exFAT/ --delete --exclude=".*" '

subs() {   "$HOME/OneDrive/OpenSubtitlesDownload.py" --cli --auto --username MANICX100 --password 5z6!!Evd "$1";    }

alias unshareusb='/bin/eveusbc unshare all'
alias shareusb='/bin/eveusbc share 12345 1-9.1'

execdircmd () {   cd $("dirname" "$1") ; $2 "$1"; cd "$HOME" ;  }

macos() { cd "/home/dkendall/quickgui" ; ./quickgui; cd "$HOME" ; }

alias screenrec='ffmpeg -video_size 1920x1200 -framerate 60 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default output.mp4'
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

PATH="/home/dkendall/quickgui:/home/dkendall/quickemu:/home/dkendall/.local/bin:/home/dkendall/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin"

alias addapp='sudo xdg-open /usr/local/bin'
alias shut='sudo systemctl suspend'
alias clean='sudo dnf clean all && flatpak uninstall --unused'

alias python='python3.12'
alias logoff='sudo service sddm restart'
alias yt-dlp='/usr/local/bin/yt-dlp'

eval "$(starship init bash)"
#eval "$(starship init zsh)"
