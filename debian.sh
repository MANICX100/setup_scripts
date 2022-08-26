echo "Debian setup"

sudo -k echo "Yes"

sudo apt install nala

sudo nala install mupdf unrar libheif mpv stacer feh ncompress onedrive
sudo nala install unclutter
sudo nala install i3lock
sudo nala install bat
sudo nala install lynis

sudo nala install synergy
sudo nala install openssl

sudo nala install sddm

systemctl disable gdm
systemctl enable sddm

sudo nala install mksh
sudo usermod -s /bin/mksh dkendall

systemctl --user enable onedrive
systemctl --user start onedrive

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# sudo nala install snapd
# sudo ln -s /var/lib/snapd/snap /snap
# sudo snap install snapd
# sudo snap set system refresh.retain=2
# sudo snap install plexmediaserver
# sudo snap install thunderbird --candidate
# sudo snap install savewizard --devmode

echo "Remember to load up software centre and install the following:"
echo "Flatseal"
echo "SCITE"
echo "Video Trimmer"
echo "Sublime Merge"
echo "VS Code"

sudo -k echo "Yes"

echo "Download yt-dlp AND topgrade and install to"
sudo xdg-open "/usr/local/bin"

sudo -k echo "Yes"

echo "Plug in USB HDD and press enter to rsync"

sudo -k echo "Yes"

rsync -progress -avh --ignore-existing /home/dkendall/ /run/media/dkendall/exFAT/ --delete --exclude=".*"

sudo nala install python3.11
pip install pip-audit

echo "USB Network Gate"
echo "Tabby Terminal"
echo "Java update"

sudo -k echo "Yes"

sudo alternatives --config java

echo ".appimage"
echo "Chiaki"
echo "WebCatalog"

sudo -k echo "Yes"

onedrive --synchronize
