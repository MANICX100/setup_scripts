set fish_greeting

cd "$HOME"

alias mpv='mpv --ontop --force-window'
alias audit='sudo lynis --forensics && pip-audit'
alias rcview='sudo bat --paging=never --style=plain "~/.config/fish/config.fish'
alias cls='clear'
alias screenshot='gnome-screenshot -a'
alias rc='nano ~/.config/fish/config.fish'
alias settings='gnome-control-center'
alias visudo='sudo nano /etc/sudoers.d/dkendall'
alias update-grub='sudo grub2-mkconfig -o /etc/grub2.cfg && sudo grub2-mkconfig -o /etc/grub2-efi.cfg'
alias edit-grub='sudo nano /etc/default/grub'

neofetch > ~/.cache/neofetch
alias pfetch='bat --paging=never --style=plain ~/.cache/neofetch'
sed -i 's/6500/6900/g' ~/.cache/neofetch
sed -i 's/6400/6800/g' ~/.cache/neofetch
sed -i 's/3.400/5.500/g' ~/.cache/neofetch

alias inst='sudo dnf install'
alias up='topgrade'
alias remove='sudo dnf autoremove'

alias playtvmpv='mpv /home/dkendall/Videos/TV/Personal'
alias emptybin='sudo rm -rf ~/.local/share/Trash/*'

alias delrecent='sudo rm ~/.local/share/recently-used.xbel && sudo touch ~/.local/share/recently-used.xbel'

alias del='sudo rm -rf -v -I'

alias syncfolders='rsync -progress -avh --ignore-existing /home/dkendall/ /run/media/dkendall/exFAT/ --delete --exclude=".*" '

alias unshareusb='/bin/eveusbc unshare all'
alias shareusb='/bin/eveusbc share 12345 1-9.1'

alias screenrec='ffmpeg -video_size 1920x1200 -framerate 60 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default output.mp4'

alias openall='xdg-open *'

alias flatten="find ./ -mindepth 2 -type f -exec mv -i '{}' . \;"

alias emptydel='find ./ -empty -type d -delete'
alias delempty='find ./ -empty -type d -delete'

alias gohome='cd "$HOME"'

alias changejava='sudo alternatives --config java'

set PATH "/home/dkendall/quickgui:/home/dkendall/quickemu:/home/dkendall/.local/bin:/home/dkendall/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin"

alias addapp='sudo xdg-open /usr/local/bin'
alias shut='sudo systemctl suspend'
alias clean='sudo dnf clean all && flatpak uninstall --unused'

alias python='python3.11'
alias logoff='sudo service sddm restart'
alias yt-dlp='/usr/local/bin/yt-dlp'


function orderfiles                                                           
    set list ./**.*                      
    for val in $list                       
            set ext  (date -r $val +%Y)   
            mkdir -p "$ext"               
            cp $val "./$ext" 
    end                                        
end 

function subs
    "$HOME/OneDrive/OpenSubtitlesDownload.py" --cli --auto --username MANICX100 --password 5z6!!Evd "$1";
end

function execdircmd
    cd $("dirname" "$1") ; $2 "$1"; cd "$HOME" ;
end

function macos
	cd "/home/dkendall/quickgui" ; ./quickgui; cd "$HOME" ;
end

function yt
    cd "/home/dkendall/Videos/yt/"
	yt-dlp -f 'bv*[height=360]+ba' --download-archive videos.txt  https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg
end

function deltv
    rm -rf "/home/dkendall/Videos/TV/Personal"; cd "/home/dkendall/Videos/TV/"; mkdir Personal; cd "$HOME";
end

function delyt
    rm -rf "/home/dkendall/Videos/yt"; cd "/home/dkendall/Videos/"; mkdir yt ; cd "$HOME";
end