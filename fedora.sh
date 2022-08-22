echo "Fedora setup"
read

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

sudo dnf install mksh
sudo usermod -s /bin/mksh dkendall

systemctl --user enable onedrive
systemctl --user start onedrive

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo dnf install snapd
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install snapd
sudo snap set system refresh.retain=2
sudo snap install plexmediaserver
sudo snap install thunderbird --candidate
sudo snap install savewizard --devmode

echo "Remember to load up software centre and install the following:"
echo "Flatseal"
echo "SCITE"
echo "Video Trimmer"
echo "Sublime Merge"
echo "VS Code"
read

echo "Download yt-dlp AND topgrade and install to"
sudo xdg-open "/usr/local/bin"
read

echo "Plug in USB HDD and press enter to rsync"
read

rsync -progress -avh --ignore-existing /home/dkendall/ /run/media/dkendall/exFAT/ --delete --exclude=".*"

sudo dnf install python3.11
pip install pip-audit

echo "USB Network Gate"
echo "Tabby Terminal"
echo "Java update"
read
sudo alternatives --config java

echo ".appimage"
echo "Chiaki"
echo "WebCatalog"
read

onedrive --synchronize

