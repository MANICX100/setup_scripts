echo "Fedora setup"

sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install mupdf unrar libheif mpv stacer feh ncompress onedrive unclutter i3lock bat lynis openssl sddm gnome-screenshot fish util-linux-user python3.11 ffmpeg gh gnome-tweak-tool
sudo dnf install qemu bash coreutils edk2-tools grep jq lsb procps python3 genisoimage usbutils util-linux sed spice-gtk-tools swtpm wget xdg-user-dirs xrandr unzip

curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
chmod +x gdu_linux_amd64
sudo mv gdu_linux_amd64 /usr/bin/gdu

systemctl disable gdm
systemctl enable sddm

echo "Remember"
echo "chsh -s /usr/bin/fish"
sudo -k echo "Yes"

systemctl --user enable onedrive
systemctl --user start onedrive
onedrive --synchronize

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#sudo dnf install snapd
#sudo ln -s /var/lib/snapd/snap /snap
#sudo snap install snapd
#sudo snap set system refresh.retain=2
#sudo snap install plexmediaserver
#sudo snap install thunderbird --candidate
#sudo snap install savewizard --devmode

echo "If a fresh install Flatpaks"
echo "Flatseal"
echo "Video Trimmer"

sudo -k echo "Yes"

echo "Download yt-dlp AND topgrade and install to"
sudo xdg-open "/usr/local/bin"

sudo -k echo "Yes"

echo "Plug in USB HDD and press enter to rsync"

sudo -k echo "Yes"

rsync -progress -avh --ignore-existing /home/dkendall/ /run/media/dkendall/exFAT/ --delete --exclude=".*"

echo "USB Network Gate"
echo "Java update"

sudo -k echo "Yes"

sudo alternatives --config java

echo ".appimage"
echo "Chiaki"
echo "WebCatalog"
echo "Thunderbird/Plex/Save Wizard"
echo "On wakeup behaviour"

curl -sS https://starship.rs/install.sh | sh

echo "Done"

