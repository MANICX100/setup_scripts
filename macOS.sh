
echo "macOS setup"
sudo -k echo "Yes"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install topgrade zsh bash fish fisher cleanmymac the-unarchiver ncompress gzip bzip2 mas ripgrep amethyst icanhazshortcut background-music onecast rectangle iina soulver bat fd steam git gh paragon-ntfs paragon-extfs gdu gnu-time parallels

fisher install shoriminimoe/fish-extract

brew link --overwrite gdu

#hashtab
mas install 517065482

#neooffice
mas install 639210716

#onedrive
mas install 823766827

chsh -s /usr/local/bin/fish
sudo chsh -s /usr/local/bin/fish

echo "USB Network Gate"
echo "Synergy"
echo "PS Remote Play"

echo "Linux setup"
sudo -k echo "Yes"

curl https://alx.sh | sh
