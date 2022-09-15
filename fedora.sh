echo "Fedora setup"

sudo -k echo "Yes"

sudo dnf install mupdf unrar libheif mpv stacer feh ncompress onedrive
sudo dnf install unclutter
sudo dnf install i3lock
sudo dnf install bat
sudo dnf install lynis

sudo dnf install synergy
sudo dnf install openssl

sudo dnf install sddm

systemctl disable gdm
systemctl enable sddm

sudo dnf install fish
sudo dnf install util-linux-user
chsh -s /usr/bin/fish

systemctl --user enable onedrive
systemctl --user start onedrive

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#sudo dnf install snapd
#sudo ln -s /var/lib/snapd/snap /snap
#sudo snap install snapd
#sudo snap set system refresh.retain=2
#sudo snap install plexmediaserver
#sudo snap install thunderbird --candidate
#sudo snap install savewizard --devmode

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

sudo dnf install python3.11
pip install pip-audit

echo "USB Network Gate"
echo "Java update"

sudo -k echo "Yes"

sudo alternatives --config java

echo ".appimage"
echo "Chiaki"
echo "WebCatalog"
echo "Thunderbird/Plex/Save Wizard"

sudo -k echo "Yes"

onedrive --synchronize

