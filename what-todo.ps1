Remove-Item -recurse what-todo -Force
irm "https://onedrive.live.com/download?cid=77AE4ECB7EF00365&resid=77AE4ECB7EF00365%2125801&authkey=AMz08_VLHfC5zAo" -outFile what-todo.zip
Extract-Archive what-todo.zip

wget --no-cache -O $profile "https://github.com/MANICX100/setup_scripts/raw/main/what-todo-rc.ps1"
