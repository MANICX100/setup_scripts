Remove-Item -recurse what-todo -Force
scoop install pnpm
pnpm setup
pnpm env use latest --global

echo ""
echo "If this failed please reboot and run again"
echo ""

mkdir -p Documents/WindowsPowershell
mkdir -p Documents/Powershell

irm "https://onedrive.live.com/download?cid=77AE4ECB7EF00365&resid=77AE4ECB7EF00365%2125801&authkey=AMz08_VLHfC5zAo" -outFile what-todo.zip
Expand-Archive what-todo.zip

cd what-todo
pnpm i

irm "https://github.com/MANICX100/setup_scripts/raw/main/what-todo-rc.ps1" -outFile $profile
