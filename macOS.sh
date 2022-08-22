echo "macOS setup"
read

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install topgrade

brew install zsh
brew install bash

brew install cleanmymac
brew install the-unarchiver

brew install mas
brew install ripgrep
brew install --cask amethyst
brew install icanhazshortcut
brew install background-music

brew install tabby

brew install onecast
brew install rectangle
brew install iina
brew install soulver

brew install bat
brew install fd
brew install vscodium
brew install steam

brew install git
brew install sublime-merge

brew install paragon-ntfs
brew install paragon-extfs

#hashtab
mas install 517065482

#neooffice
mas install 639210716

#onedrive
mas install 823766827

brew install mksh

chsh -s /usr/local/bin/mksh
sudo chsh -s /usr/local/bin/mksh

echo "USB Network Gate"
echo "Synergy"
echo "PS Remote Play"

read -n 1 -s -r -p "Press any key to continue"


echo "Windows setup"
brew install parallels

echo "Linux setup"
read -n 1 -s -r -p "Press any key to continue"

curl https://alx.sh | sh
