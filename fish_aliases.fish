set fish_greeting

cd "$HOME"

function image2txt
	read -l -P '' confirm
	tesseract -l eng $confirm output_from_ocr
	cat output_from_ocr.txt
end

function Get-PubIP
	wget --no-cache -q -O - ipinfo.io/ip
end

alias e.='open .'
alias uefi='systemctl reboot --firmware-setup'
alias ffprefclean='/home/dkendall/.mozilla/firefox/oewuk6x8.default-release/prefsCleaner.sh'
alias ffprefup='/home/dkendall/.mozilla/firefox/oewuk6x8.default-release/updater.sh'
alias ipconfig='ip route'
alias ifconfig='ip route'

function stripclip
	echo xclip |awk -v OFS=' ' '{$1=$1}1'|xclip
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
alias rcupdate='wget --no-cache -O ~/.config/fish/config.fish https://github.com/MANICX100/setup_scripts/raw/main/fish_aliases.fish'

set -g osinfo (rg -ioP '^ID=\K.+' /etc/os-release)

neofetch > ~/.cache/neofetch
alias pfetch='bat --paging=never --style=plain ~/.cache/neofetch'
sed -i 's/6500/6900/g' ~/.cache/neofetch
sed -i 's/6400/6800/g' ~/.cache/neofetch
sed -i 's/3.400/5.500/g' ~/.cache/neofetch

alias up='topgrade;pkcon update'
alias instrpm='sudo rpm -ivh --force'
alias instdeb='sudo dpkg --force-all -i'
alias inst='pkcon install'

function remove
	switch $osinfo
	    case fedora
			sudo dnf remove $argv
	    case arch
			paru -Rns $argv
	    case debian
			sudo nala autoremove $argv
	    case '*'
			brew uninstall $argv
	end
end

function clean
	switch $osinfo
	    case fedora
			sudo dnf clean all
			flatpak uninstall --unused
	    case arch
			paru -Yc
			flatpak uninstall --unused
	    case debian
			sudo nala autoremove -o APT::Autoremove::RecommendsImportant=0 -o APT::Autoremove::SuggestsImportant=0
			flatpak uninstall --unused
	    case '*'
			brew cleanup --prune=1 -s
	end
end

function uefi
	switch $osinfo
	    case fedora
			systemctl reboot --firmware-setup
	    case arch
			systemctl reboot --firmware-setup
	    case debian
			systemctl reboot --firmware-setup
	    case '*'
			sudo nvram "recovery-boot-mode=unused"
			sudo reboot
	end
end

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

alias python='python3.11'
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
	cd "/home/dkendall/quickgui" ; ./quickgui; cd "$HOME" ;
end

function yt
    cd "/home/dkendall/Videos/yt/"
    yt-dlp -f 'bv*[height=360]+ba' --download-archive videos.txt  'https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg'
    cd "$HOME";
end

function deltv
    rm -rf "/home/dkendall/Videos/TV/Personal"; cd "/home/dkendall/Videos/TV/"; mkdir Personal; cd "$HOME";
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

function gitPromoteAndMerge
	echo "This will attempt to merge an existing branch with master. Any existing in master and not in the branch will be attempted to be preserved"
	git checkout -b "$argv"
	git status
	git commit -a --allow-empty-message -m " "
	git checkout master
	git merge --no-ff "$argv"
	git push origin master
  end
  
function gitDeleteBranch
	git branch -d "$argv"
	git push origin --delete "$argv"
end

function gitRenameBranch
	echo "Please run the following commands in sequence"
	echo 'git branch -m "$old" "$new" '
	echo 'git branch --unset-upstream "$new" '
	echo 'git push origin "$new" '
	echo 'git push origin -u "$new" '
end

function gitIgnoreRm
	git ls-files -i -c --exclude-from=.gitignore | %{git rm --cached $_}
end

starship init fish | source
