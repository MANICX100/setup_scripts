typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

fpath=(/path/to/antidote/functions $fpath)
autoload -Uz antidote

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

source ${zsh_plugins}.zsh
source $HOME/.profile

printf "\e[?2004l"
export EDITOR=nvem
export TERM=linux
export NODE_COMPILE_CACHE=~/.cache/nodejs-compile-cache
export JAVA_HOME=/jdk
setopt nullglob
setopt share_history
SAVEHIST=1000
HISTFILE=$HOME/.zsh_history

catfunction() {
  rg "^$1\(\) \{" -A 1000 ~/setup_scripts/zshrc | sed '/^}$/q'
}

symlinkback() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: symlinkback <target-in-current-dir> <source-absolute-or-tilde>"
    return 2
  fi
  local target="$1"
  local source="$2"
  rm -f -- "$target" && cp -- "$source" "./$target" && ln -sf -- "$(pwd)/$target" "$source"
}

dnscheck() {
  emulate -L zsh
  if [[ -z "$1" ]]; then
    echo "Usage: dnscheck <domain-or-url>"
    return 2
  fi

  local domain="$1"
  if [[ "$domain" == http://* || "$domain" == https://* || "$domain" == *://* ]]; then
    domain="${domain#*://}"
    domain="${domain%%/*}"
    domain="${domain%%:*}"
  fi

  typeset -A resolvers
  resolvers=(
    Cloudflare 1.1.1.1
    Google     8.8.8.8
    Quad9      9.9.9.9
    OpenDNS    208.67.222.222
    AdGuard    94.140.14.14
    dns.sb-1   185.222.222.222
    dns.sb-2   45.11.45.11
    Lumen3-1   4.2.2.1
    Lumen3-2   4.2.2.2
    Lumen3-3   4.2.2.3
    Lumen3-4   4.2.2.4
    Lumen3-5   4.2.2.5
    Lumen3-6   4.2.2.6
  )

  local is_allowed
  is_allowed() {
    local text="$1"
    local line
    local -a types cols
    types=(A AAAA CNAME MX NS TXT SRV SOA PTR CAA)
    while IFS= read -r line; do
      line="${line#"${line%%[![:space:]]*}"}"
      line="${line%"${line##*[![:space:]]}"}"
      [[ -z "$line" ]] && continue
      [[ "${line:l}" == name\ type\ class* ]] && continue
      IFS=$' \t' read -r -A cols <<<"$line"
      if (( ${#cols} >= 2 )); then
        local second="${cols[2]}"
        local upper="${(U)second}"
        for t in "${types[@]}"; do
          if [[ "$upper" == "$t" ]]; then
            if [[ "$upper" == SOA ]]; then
              if [[ "$line" == *'NXDOMAIN'* || "$line" == *'SERVFAIL'* || "$line" == *'Server Failure'* ]]; then
                return 1
              fi
              continue
            fi
            return 0
          fi
        done
      fi
    done <<<"$text"
    if print -r -- "$text" | grep -qiE '^\s*Status:\s*NOERROR'; then
      return 0
    fi
    return 1
  }

  local name addr out ec
  for name addr in "${(@kv)resolvers}"; do
    out="$(doggo "$domain" A -n "$addr" 2>&1)"
    ec=$?
    if (( ec != 0 )) && [[ -z "$out" ]]; then
      echo "$name: Blocked"
      continue
    fi
    if is_allowed "$out"; then
      echo "$name: Allowed"
    else
      echo "$name: Blocked"
    fi
  done
}

lastmodified() {
  local file
  file=$(bfs . -type f -printf '%T@ %TY-%Tm-%Td %TH:%TM %p\n' 2>/dev/null | sort -nr | cut -d' ' -f2- | fzf --height 40% --reverse | gawk '{sub(/^[^ ]+ [^ ]+ /, ""); print}')
  if [[ -n "$file" ]]; then
    xdg-open "$file"
  fi
}

rmfunction() {
  if [[ -z "$1" ]]; then
    echo "Usage: rmfunction <funcname>" >&2
    return 1
  fi
  sed -i "/^$1()/,/^}/d" ~/setup_scripts/zshrc
  echo "Removed function '$1' from rc file"
}

benchopen() {
  local runs=1
  local cmds=()
  local input
  local -a hf_args=()

  if [[ $# -eq 0 ]]; then
    echo "Enter commands, Flatpak IDs, Snap names, AppImages, or .desktop files to benchmark (empty line to finish):"
    while true; do
      printf "Command [%d]: " $((${#cmds[@]} + 1))
      read -r input
      [[ -z "$input" ]] && break
      cmds+=("$input")
    done
  else
    cmds=("$@")
  fi

  if ! command -v hyperfine >/dev/null 2>&1; then
    echo "Error: hyperfine not installed or not in PATH" >&2
    return 1
  fi

  if [[ ${#cmds[@]} -eq 0 ]]; then
    echo "No commands entered. Exiting." >&2
    return 1
  fi

  echo "Benchmarking: ${cmds[*]}"

  for cmd in "${cmds[@]}"; do
    local name execstr=""
    if [[ -f "$cmd" && -x "$cmd" ]]; then
      name="$(basename "$cmd")"
      execstr="bash -c 'nohup \"$cmd\" >/dev/null 2>&1 &'"
    elif [[ "$cmd" == *.desktop && -f "$cmd" ]]; then
      local exec_line
      exec_line=$(grep -E '^Exec=' "$cmd" | head -n1 | sed 's/^Exec=//; s/%[fFuUdDnNickvm]//g')
      if [[ -n "$exec_line" ]]; then
        name="$(basename "$cmd" .desktop)"
        execstr="bash -c 'nohup ${exec_line} >/dev/null 2>&1 &'"
      fi
    elif command -v "$cmd" >/dev/null 2>&1; then
      name="$cmd"
      execstr="$cmd"
    elif flatpak info "$cmd" >/dev/null 2>&1; then
      name="$cmd"
      execstr="flatpak run $cmd"
    elif [[ "$cmd" == "flatpak run "* ]]; then
      name="$(echo "$cmd" | gawk '{print $3}')"
      execstr="$cmd"
    else
      echo "Warning: '$cmd' not found" >&2
    fi
    if [[ -n "$execstr" ]]; then
      hf_args+=("-n" "$name" "$execstr")
    fi
  done

  if [[ ${#hf_args[@]} -eq 0 ]]; then
    echo "Error: no valid commands to benchmark" >&2
    return 1
  fi

  hyperfine --runs "$runs" --warmup 0 "${hf_args[@]}" --export-json bench-results.json

  if [[ -f bench-results.json ]]; then
    echo
    echo "Times (ms):"
    gawk '
      /"command_name":/ {name=$2; gsub(/[" ,]/,"",name)}
      /"mean":/ {mean=$2; gsub(/[,]/,"",mean); printf "%s: %dms\n", name, mean*1000}
    ' bench-results.json
    rm -f bench-results.json
  fi
}

bgrun() { rust-parallel "$1" ::: "${@:2}"; }

saveclipimg() {
  if xclip -selection clipboard -t image/png -o > /dev/null 2>&1; then
    xclip -selection clipboard -t image/png -o | convert png:- output.jpg
    echo "✅ Saved clipboard image to output.jpg"
  else
    echo "⚠️  Clipboard does not contain a PNG image" >&2
    return 1
  fi
}

localsdl() {
    echo "Please copy the 'Copy as cURL (bash)' command for the YouTube playlist manifest (.m3u8) from your browser's network tab."
    echo "Paste the command below and press Enter:"

    read curl_command

    local curl_script="get_playlist.sh"
    local playlist_file="playlist.m3u8"
    local file_list="file_list.txt"
    local merged_ts="merged.ts"
    local output_mp4="video.mp4"

    echo "Saving cURL command to ${curl_script}..."
    echo "${curl_command}" > "${curl_script}"

    echo "Making ${curl_script} executable..."
    chmod +x "${curl_script}"

    echo "Fetching playlist manifest using ${curl_script}..."
    if ! ./"${curl_script}" > "${playlist_file}"; then
        echo "Error: Failed to fetch playlist manifest."
        rm -f "${curl_script}"
        return 1
    fi

    echo "Downloading videos using yt-dlp from ${playlist_file}..."
    if ! yt-dlp --no-part --continue -a "${playlist_file}"; then
        echo "Error: yt-dlp failed."
        rm -f "${curl_script}" "${playlist_file}"
        return 1
    fi

    echo "Creating list of downloaded .ts files..."
    if ! find . -maxdepth 1 -name "*.ts" -print > "${file_list}"; then
        echo "Error: Failed to find .ts files."
        rm -f "${curl_script}" "${playlist_file}"
        return 1
    fi

    echo "Formatting file list for ffmpeg..."
    if ! sed -i "s/^/file '/; s/$/'/" "${file_list}"; then
         if ! sed -i "" "s/^/file '/; s/$/'/" "${file_list}"; then
             echo "Error: Failed to format file list with sed."
             rm -f "${curl_script}" "${playlist_file}" "${file_list}"
             return 1
         fi
    fi


    echo "Merging .ts files into ${merged_ts} using ffmpeg..."
    if ! ffmpeg -f concat -safe 0 -i "${file_list}" -c copy "${merged_ts}"; then
        echo "Error: ffmpeg merging failed."
        rm -f "${curl_script}" "${playlist_file}" "${file_list}"
        return 1
    fi

    echo "Converting ${merged_ts} to ${output_mp4} using ffmpeg..."
    if ! ffmpeg -i "${merged_ts}" -c:v libx264 -movflags +faststart -c:a copy "${output_mp4}"; then
        echo "Error: ffmpeg conversion to MP4 failed."
        rm -f "${curl_script}" "${playlist_file}" "${file_list}" "${merged_ts}"
        return 1
    fi

    echo "Cleaning up temporary files..."
    rm -f "${curl_script}" "${playlist_file}" "${file_list}" "${merged_ts}"

    echo "Process completed successfully. Output file: ${output_mp4}"
}



setup_script_link() {
  # Check if an argument (filename) was provided
  if [[ $# -eq 0 ]]; then
    print -u2 "Usage: setup_script_link <filename>"
    print -u2 "Error: No file specified."
    return 1
  fi

  local source_file="$1"
  local target_dir="$HOME/setup_scripts"

  # Check if the source file exists and is a regular file
  if [[ ! -f "$source_file" ]]; then
    print -u2 "Error: File '$source_file' not found or is not a regular file."
    return 1
  fi

  # --- Get Absolute Paths ---
  # Use realpath to resolve the full path, handling symlinks and relative paths
  local source_file_abs
  source_file_abs=$(realpath "$source_file")
  if [[ $? -ne 0 || -z "$source_file_abs" ]]; then
     print -u2 "Error: Could not determine absolute path for '$source_file'."
     return 1
  fi

  local source_filename=$(basename "$source_file_abs")
  local target_path="$target_dir/$source_filename"

  # --- Ensure Target Directory Exists ---
  print -P "%F{cyan}Ensuring target directory exists: %f'$target_dir'"
  mkdir -p "$target_dir"
  if [[ $? -ne 0 ]]; then
    print -u2 "%F{red}Error: Could not create directory '$target_dir'.%f"
    return 1
  fi

  # --- Check for Existing File/Link in Target ---
  if [[ -e "$target_path" ]]; then
      print -u2 "%F{yellow}Warning: '$target_path' already exists. Aborting to prevent overwrite.%f"
      return 1
  fi

  # --- Move the File ---
  print -P "%F{cyan}Moving: %f'$source_file_abs' -> '$target_path'"
  # Use mv -v for verbose output (optional)
  mv -v "$source_file_abs" "$target_path"
  if [[ $? -ne 0 ]]; then
    print -u2 "%F{red}Error: Failed to move file '$source_filename'.%f"
    return 1
  fi

  # --- Create the Symlink ---
  print -P "%F{cyan}Creating symlink: %f'$source_file_abs' -> '$target_path'"
  # Use ln -sv for symbolic (s) and verbose (v)
  ln -sv "$target_path" "$source_file_abs"
  if [[ $? -ne 0 ]]; then
    print -u2 "%F{red}Error: Failed to create symlink at '$source_file_abs'.%f"
    # Attempt to move the file back if symlink fails? (Optional - can add complexity)
    # print -u2 "%F{yellow}Attempting to move file back...%f"
    # mv -v "$target_path" "$source_file_abs"
    return 1
  fi

  # --- Run lazygit Sync ---
  print -P "%F{cyan}Changing to '$target_dir' and running 'lazyg \"sync\"'...%f"
  # Use pushd/popd to manage directory changes cleanly
  pushd "$target_dir" >/dev/null 2>&1
  if [[ $? -ne 0 ]]; then
      print -u2 "%F{red}Error: Could not change directory to '$target_dir'.%f"
      return 1 # pushd failed, no need for popd
  fi

  # Run the command
  lazyg "sync"
  local lazyg_status=$? # Capture the exit status

  # Return to the original directory
  popd >/dev/null 2>&1

  if [[ $lazyg_status -ne 0 ]]; then
    print -u2 "%F{yellow}Warning: 'lazyg \"sync\"' command finished with non-zero status ($lazyg_status).%f"
    # Decide if this should be a failure - returning 0 allows script to continue
  fi

  print -P "%F{green}Successfully processed '%f$source_filename%F{green}'.%f"
  return 0 # Indicate success
}

dockerstop(){
doas docker stop $(doas docker ps -q) && doas systemctl stop docker
}

currentconnections() {
 for ip in $(ss -nt | frawk 'NR>1 {print $5}' | cut -d':' -f1 | sort -u); do
      dig -x "$ip" +short
  done
}

recent() {
    local count=${1:-20}  # Default to 20 if no argument is given
    bfs . -type f -printf "%T@ %p\n" | sort -nr | cut -d ' ' -f2- | head -n "$count"
}

fixpihole(){
doas killall dnsmasq
doas pihole -r
doas systemctl restart NetworkManager
doas ip addr flush dev wlp7s0
doas ip addr add 192.168.1.183/24 dev wlp7s0
}

changebrowser(){
doas update-alternatives --config gnome-www-browser
doas update-alternatives --config x-www-browser
}

vaultwarden() {
doas docker run -d --name vaultwarden -v /vw-data/:/data/ -p 80:80 vaultwarden/server:latest
}

rmpaywall(){
doas docker run -p 8080:8080 -d --env RULESET=https://t.ly/14PSf --name ladder ghcr.io/everywall/ladder:latest
}

pdftools(){
doas docker run -d \
  -p 8080:8080 \
  -v ./trainingData:/usr/share/tessdata \
  -v ./extraConfigs:/configs \
  -v ./logs:/logs \
  -e DOCKER_ENABLE_SECURITY=false \
  -e INSTALL_BOOK_AND_ADVANCED_HTML_OPS=false \
  -e LANGS=en_GB \
  --name stirling-pdf \
  frooodle/s-pdf:latest
}

openproject(){
doas docker run -it -p 8080:80 \
  -e OPENPROJECT_SECRET_KEY_BASE=secret \
  -e OPENPROJECT_HOST__NAME=localhost:8080 \
  -e OPENPROJECT_HTTPS=false \
  -e OPENPROJECT_DEFAULT__LANGUAGE=en \
  openproject/openproject:14
}

delgithistory() {
  local commit_message="${1:-Clean git history}"
  
  echo "Creating new orphan branch..."
  git checkout --orphan latest_branch
  
  echo "Adding all files to the new branch..."
  git add -A
  
  echo "Committing changes..."
  git commit -am "$commit_message"
  
  echo "Deleting main branch..."
  git branch -D main
  
  echo "Renaming current branch to main..."
  git branch -m main
  
  echo "Force pushing to remote repository..."
  git push -f origin main
  
  echo "Running garbage collection..."
  git gc --aggressive --prune=all
  
  echo "Git history has been reset!"
}

cd() {
  if [ "$#" = "0" ]; then
    builtin cd
  elif [ "$1" = ".." ] || [ "${1:0:1}" = "/" ] || [ "${1:0:2}" = "~/" ]; then
    builtin cd "$1"
  else
    if [ -d "$1" ]; then
      builtin cd "$1"
    else
      target_dir=$(bfs . -maxdepth 1 -iname "$1" -type d -print -quit)
      if [ -n "$target_dir" ]; then
        echo "Found directory: $target_dir"
        builtin cd "$target_dir"
      else
        echo "Directory not found: $1"
      fi
    fi
  fi
}

function macos() {
    doas docker run -it \
        --device /dev/kvm \
        -p 50922:10022 \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=${DISPLAY:-:0.0}" \
        -e GENERATE_UNIQUE=true \
        -e CPU='Haswell-noTSX' \
        -e CPUID_FLAGS='kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on' \
        -e MASTER_PLIST_URL='https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom-sonoma.plist' \
        sickcodes/docker-osx:sonoma
}

function command_not_found_handler {
  /usr/lib/command-not-found -- $1
}

function zshaddhistory() {
  if [[ $? -eq 127 ]]; then
    command_not_found_handler $1
  fi
}

function reloadnetwork() {
doas systemctl restart systemd-resolved.service
doas systemctl restart systemd-resolved.service
}

# function cargo-update {
# for crate in $(cargo install --list | frawk '{print $1}'); do
#     if [ "$crate" = "pdu" ] || [ "$crate" = "btm" ]; then
#         echo "Skipping $crate"
#         continue
#     fi
#     cargo binstall $crate
# done
# }

function upheldback() {
doas apt list --upgradable | awk -F/ '/upgradable/ {print $1}' | /usr/bin/xargs doas apt install -y
}

function dict() {
  local word=${1:?Word required}
  curl -s "dict://dict.org/d:$word"
}

# Smart open function
__smart_open() {
  local target="${1:-.}"
  local abs

  abs=$(realpath -m "$target" 2>/dev/null || echo "$target")

  if [[ -d "$abs" ]]; then
    # Use the .desktop entry for ROX
    command gtk-launch rox.desktop "$abs" 2>/dev/null || \
    command xdg-open "$abs"
  else
    command xdg-open "$abs"
  fi
}

# Aliases with same behavior
e()        { __smart_open "$@"; }
explorer() { __smart_open "$@"; }
ii()       { __smart_open "$@"; }
start()    { __smart_open "$@"; }

alias jjpull='jj git fetch && jj rebase -d main'
alias trash='xdg-open ~/.local/share/Trash/files'
alias termeverything='~/AppImages/term.everythingmmulet.com.appimage'
alias kernels='ls -1 /boot/vmlinuz-*'
alias clip='xclip -selection clipboard'
alias wp='doas docker start wordpressdb && doas docker start wordpress'
alias lzd='doas $(which lazydocker)'
alias kdedefaults='kcmshell6 componentchooser'
alias apthistory='$EDITOR /var/log/apt/history.log'
alias emptyramslots='doas dmidecode -t memory| rg -i "No module installed"'

alias ghosttyconfig='$HOME/.config/ghostty/config'
alias heavytasklist='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 20'
#alias mpvav1='mpv * --hwdec=0'

alias rmfolders='rm -r */'
alias lockdns='doas chattr +i /etc/resolv.conf'
alias unlockdns='doas chattr +i /etc/resolv.conf'

alias mvupdir='mv * ../'
alias biosversion='doas dmidecode -s bios-version'
alias beeperfix='rm -rfv .config/Beeper/GPUCache'
alias lutris='/usr/games/lutris'
alias fat32format='doas mkfs.vfat -F 32'
alias exfatformat='doas mkfs.exfat'
alias ext4format='doas mkfs.ext4 -I 256 -O 64bit -E lazy_itable_init'
alias xfsformat='doas mkfs.xfs'
alias ntfsformat='doas mkfs.ntfs -f'
alias f2fsformat='doas mkfs.f2fs'
alias btrfsformat='doas mkfs.btrfs'

alias gfn='google-chrome-stable --proxy-server="127.0.0.1:8080"'
alias df='dysk'
alias grep='rg'
alias awk='frawk'
alias find='bfs'
#alias xargs='gargs'

alias runningprocesses='doas lsof|rg txt'
alias rmtrash='rm --empty-trash'
alias polkit='/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1'
alias dockermanage='doas $(which lazydocker)'
alias winedesktop='cd  ~/.local/share/applications/wine'
alias freshrss='doas docker start freshrss'
alias dockerkillall='doas docker kill $(doas docker ps -q)'
alias publicip='curl --http3 -s https://ipinfo.io/ip'
alias wine='wine64'
alias pkill='killall -I -v'

alias wakeups='cat /proc/acpi/wakeup |rg -i enabled'
alias wc='$HOME/wc2/wc2 -lwm'
alias wc2='$HOME/wc2/wc2 -lwm'
alias ls='eza'
alias shuf='shuf-rs'

alias setlocale='setxkbmap gb &'

alias dockerupdate='doas sh -c '\''docker images --format "{{.Repository}}" | sort | uniq | grep -v "<none>" | xargs -I {} docker pull {}'\'''

alias labwcstart='$EDITOR ~/.config/labwc/autostart'
alias labwckeys='$EDITOR ~/.config/labwc/rc.xml'
alias keymap='setxkbmap -print -verbose 10'

alias glances='doas docker run --rm -e TZ="${TZ}" -v /var/run/docker.sock:/var/run/docker.sock:ro -v /run/user/1000/podman/podman.sock:/run/user/1000/podman/podman.sock:ro --pid host --network host -it nicolargo/glances:latest-full'

alias uxplayaudio='uxplay -vs 0'
alias openallpdf="find . -iname '*\.pdf' -print0 | xargs -0 -n1 mupdf"

alias dy="dig +short @dns.toys"
alias flatpakdown='flatpak remote-info --log flathub'
alias flatpak='flatpak --user'

alias jellyfin='doas docker run -d -v /srv/jellyfin/config:/config -v /srv/jellyfin/cache:/cache -v "$HOME/Jellyfin Server Media":/media -p 8096:8096 -p 7359:7359/udp jellyfin/jellyfin:latest'

alias errors='doas journalctl -p err'
alias saveimgclip='xclip -selection clipboard -t image/png -o > $HOME/Desktop/clipboard.png'
alias update-grub='doas grub-mkconfig -o /boot/grub/grub.cfg'

alias build='zig build-exe'
alias setresolution='xrandr --output HDMI-A-2 --mode'
alias Set-Resolution='setresolution'

alias sysd='doas $EDITOR /etc/systemd/system.conf'
alias vars='set|less'
alias gpuinfo='glxinfo -B'
alias cpuinfo='doas dmidecode --type processor'
alias gcm='whereis'
alias lite-xl='/usr/local/bin/lite-xl/lite-xl'
alias lite='lite-xl'
alias uptime='uptime --since && uptime --pretty'

alias lsblk='lsblk|rg -v loop'
alias usb='/usr/binlsblk|rg sda'
alias printers='lpstat -p'
alias bluetooth='bluetoothctl devices'

alias unmountios='fusermount -u /media/dkendall/iOS'
alias mountios='ifuse /media/dkendall/iOS'
alias unmount='doas umount'
alias mount='doas mount -o rw,uid=1000,gid=1000,user,exec,umask=003'

alias fixwifi='doas dhclient -v enp7s0'
alias edit-apt='$EDITOR /etc/apt/sources.list'
alias bufferw='doas sync & watch -n 1 rg -e Dirty: /proc/meminfo'

alias pip='python -m pip'
alias pip3='pip'

alias icewmkeys='$EDITOR $HOME/.icewm/keys'
alias icewmstart='$EDITOR $HOME/.icewm/startup'
alias tvn='tvnamer --recursive'
alias tvrename='tvn "$HOME/Jellyfin Server Media/TV"'
alias debversion='apt-cache policy'
alias micandsystem='pactl load-module module-loopback latency_msec=1'
alias micandsystemoff='pactl unload-module module-loopback'
alias recordall='micandsystem'
alias recordalloff='micandsystemoff'
alias uninstall='remove'
alias de='ls -l /usr/share/xsessions/'
alias loginmgr='cat /etc/X11/default-display-manager'
alias displaymanager='loginmgr'
alias nom='$HOME/go/bin/nom'

# macOS
alias afconvert='ffmpeg'
alias afinfo='mediainfo'
alias afplay='mpv'
alias airport='networkstatus'
alias alloc='free'
alias apropos='tldr'
alias automator='echo Automator not configured'
alias asr='echo Restore not necessary'
alias atsutil='fc-cache -vf'
alias bless='echo All bootable OK'
alias pmset='systemctl'
alias softwareupdate='up'
alias caffeinate='caffeine'
alias textutil='vips'
alias mdfind='fd'
alias locate='fd'
alias networkquality='speedtest-cli'
alias screencapture='scrot'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias say='espeak'
alias sips='vipsthumbnail'
alias networksetup='nmcli'
alias qlmanage='feh'
#alias brew='$HOME/homebrew/bin/brew'

alias mkfs.ntfs='mkfs.ntfs --fast'
alias mkfs.ext4='mkfs.ext4 -E lazy_itable_init'
alias open='xdg-open'
alias Invoke-Item='xdg-open'
alias Start-Process='xdg-open'
alias move='mv'

alias copy='cpr'
alias remove-item='rm'
alias remove-item-r='rm -r'
alias get-content='bat'
alias gci='bat'
alias gc='bat'
alias invoke-restmethod='irm'
alias irm='curl'
alias invoke-expression='iex'
alias iex='eval'
alias drivers='doas lspci -v'
alias logs='doas journalctl|less|rg -i'

alias last='doas journalctl -u acpid'

alias convertdeb='doas alien --to-rpm'
alias convertrpm='doas alien'
alias gitc='git clone --depth 2'
alias edithosts='doas $EDITOR /etc/hosts'
alias fd='fzf --query'
alias webcam='doas modprobe v4l2loopback'
alias cloudsync='onedrive --sync --force'

#alias ffmpeg='$HOME/ffmpeg/ffmpeg'
alias ffprobe='mediainfo'
#alias qt-faststart='$HOME/ffmpeg/qt-faststart'

alias linuxservices='systemctl list-unit-files --type=service --state=enabled'
alias macosservices='doas launchctl list'
alias checkfiles='rsync --checksum --dry-run -rvn /media/dkendall/exFAT/ $HOME/'
alias dl='axel -a -n 16'
alias dls='aria2c --enable-rpc=true --rpc-allow-origin-all=true --rpc-listen-all=true --console-log-level=error -x 16'
alias rpmall='doas rpm -Uvh *'
alias chkdsk='fsck'
alias Get-Volume='doas lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL | rg -v loop'
alias default='kcmshell5 filetypes'
alias rmpipall='pip freeze --user | xargs pip uninstall -y'
alias rmpnpm='rm -rf -v $PNPM_HOME'

alias nextdnsinstall='sh -c "$(curl -sL https://nextdns.io/install)"'
alias e.='open .'
alias uefi='systemctl reboot --firmware-setup'

alias img2txt='image2txt'
alias networkstatus='nmcli dev status'
alias inst='doas apt install'
alias remove='doas apt remove'
alias purge='doas apt purge'
alias netstat='ss -t -r state established'
alias ipconfig='ip route'
alias ifconfig='ip route'
alias cleanup='clean'
alias audit='doas lynis --forensics && pip-audit'

alias batc='bat --paging=never --style=plain'
alias lsh='ls -lah -U'
alias lsf='ls -d "$PWD"/*'
alias cls='clear'
alias rc='$EDITOR $HOME/setup_scripts/zshrc'
alias visudo='doas $EDITOR /etc/sudoers.d/dkendall'
alias edit-grub='doas $EDITOR /etc/default/grub'

alias instrpm='doas rpm -ivh --force'
alias gdebi='doas gdebi'
alias instdeb='gdebi'
alias delrecent='rm $HOME/.local/share/recently-usd.xbel && doas touch $HOME/.local/share/recently-usd.xbel'
alias unshareusb='/bin/eveusbc unshare all'
alias shareusb='/bin/eveusbc share 12345 1-9.1'
alias screenrec='ffmpeg -video_size 1920x1200 -framerate 60 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default output-"$($now)".mkv'
alias ffmpeglist='ffmpeg -list_devices true -f dshow -i dummy'
alias flatten="find ./ -mindepth 2 -type f -exec mv -i '{}' . \;"
alias emptydel='find ./ -empty -type d -delete'
alias delempty='emptydel'
alias gohome='cd "$HOME"'
alias changejava='doas alternatives --config java'
alias addapp='xdg-open /usr/local/bin'
alias logoff='doas pkill -u dkendall'
alias logout='logoff'
#alias yt-dlp='/usr/local/bin/yt-dlp'
alias autoremove='doas apt autoremove -y'

function editdns(){
doas $EDITOR /etc/supervisor/conf.d/dnsproxy.conf
doas systemctl restart supervisor
}

certinfo() {
  gnutls-cli --print-cert "$1" < /dev/null | certtool --certificate-info
}

clearhistory(){
rm ~/.zsh_history
history -p
}

ffup() {
parallel ::: "xfe $HOME" "axel -n 16 -o $HOME/user.js https://raw.githubusercontent.com/MANICX100/setup_scripts/main/user-overrides.js $HOME/user.js" "xfe $HOME/.var/app/org.mozilla.firefox/.mozilla/firefox/0v4n3hk1.default-release/"
}

boostvolume() {
pactl list | rg -oP 'Sink #\K([0-9]+)' | while read -r i ; do pactl -- set-sink-volume $i +100% ; done
}

resetvolume() {
pactl list | rg -oP 'Sink #\K([0-9]+)' | while read -r i ; do pactl -- set-sink-volume $i 100% ; done
}

rmr() {
  find . -type f -name "$1" -delete
}

makeproject() {
  local project_name="$1"
  
  mkdir -p "$project_name"
  cd "$project_name"

  mkdir lib res src

  touch .gitignore
  touch .gitmodules 
  touch LICENSE
  touch README.md
  touch build.zig

  echo "Created project: $project_name"
}

function cpr() {
  local source_file=$1
  local target_dir=$2

  rsync -avAXESlHh --no-whole-file --size-only "${source_file}" "${target_dir}"
}

function cmdpath() {
  ps -p $1 -o cmd= | pbcopy
}

clean() {
flatpak uninstall --unused
doas apt autoremove -y
doas apt clean
am -c
}

rmcache(){
rm -rf -v $HOME/.cache
doas rm -rfv /var/tmp/flatpak-cache-*
echo 3 | doas tee /proc/sys/vm/drop_caches
}

timeweb(){
curl -L -w "time_namelookup: %{time_namelookup}\ntime_connect: %{time_connect}\ntime_appconnect: %{time_appconnect}\ntime_pretransfer: %{time_pretransfer}\ntime_redirect: %{time_redirect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}\n" $@
}

#systemctl() {
 # command doas systemctl "$@"
 # watch -n 1 systemctl status "$@"
#}

essentialpkgs() {
dpkg-query -Wf '${Package;-40}${Priority}\n' | rg "required"
}

displayserv() {
printf 'Session is: %s\n' "${DISPLAY:+X11}${WAYLAND_DISPLAY:+WAYLAND}"
}

icewmup() {
rm $HOME/.icewm/keys
axel -n 16 -o $HOME/.icewm/keys "https://raw.githubusercontent.com/MANICX100/setup_scripts/main/icewm-keys"
icesh restart
gohome
}

setresolutionall() {
    for output in $(xrandr | rg " connected" | frawk '{ print $1 }'); do
        xrandr --output $output --mode $1
    done
}

all() {
    for file in ./*; do
        "$@" "$file"
    done
}

reinstall() {
    if [ $# -eq 0 ]; then
        echo "Usage: reinstall <packagename>"
        return 1
    fi
    packagename=$@
    doas apt remove -y $packagename
    doas apt install -y $packagename
}

function revsyncfolders() {
rmcache
doas mount -o rw,uid=1000,gid=1000,user,exec,umask=003 /dev/sda1 /media/dkendall/exFAT
rsync -avAXESlHh --delete --no-compress --no-whole-file --size-only /media/dkendall/exFAT/Linux $HOME/ 
doas mount -o rw,uid=1000,gid=1000,user,exec,umask=003 /dev/nvme1n1p4 /media/dkendall/windows
rsync -avAXESlHh --delete --no-compress --no-whole-file --size-only /media/dkendall/exFAT/Windows /media/dkendall/windows/Users/dkendall/ 
doas umount /dev/sda1
doas umount /dev/nvme1n1p4
}

function syncfolders() {
rmcache
doas mount -o rw,uid=1000,gid=1000,user,exec,umask=003 /dev/sda1 /media/dkendall/exFAT
rsync -avAXESlHh --delete --no-compress --no-whole-file --size-only $HOME/ /media/dkendall/exFAT/Linux
doas mount -o rw,uid=1000,gid=1000,user,exec,umask=003 /dev/nvme1n1p4 /media/dkendall/windows
rsync -avAXESlHh --delete --no-compress --no-whole-file --size-only /media/dkendall/windows/Users/dkendall/ /media/dkendall/exFAT/Windows
doas umount /dev/sda1
doas umount /dev/nvme1n1p4
}

function please() {
    if alias -L | rg -q "^alias $1="; then
        cmd=$(alias -L | rg "^alias $1=" | sd "^alias $1='(.*)'$" "\$1")
        /usr/bin/doas zsh -c "$cmd ${@:2}"
    elif typeset -f | rg -q "^$1 \(\)"; then
        cmd=$(typeset -f $1)
        /usr/bin/doas zsh -c "$cmd; $1 ${@:2}"
    else
        /usr/bin/doas "$@"
    fi
}

function up() {
  topgrade
  doas apt upgrade --with-new-pkgs -y
  #git -C $HOME/powerlevel10k pull
  #dockerupdate
  #cargo-update
  cargo install-update -a
  #bun upgrade
  #doas snap refresh
  upheldback
  #doas pihole -up
  autoremove
}

function display_path() {
    echo $PATH
}

function remove_from_path() {
    PATH=$(echo $PATH | sd "(^|:)$1(:|$)" "\1\2" | sd '^:|:$' '' | sd '::' ':')
}

function extract {
 if [ $# -eq 0 ]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 fi
    for n in "$@"; do
        if [ ! -f "$n" ]; then
            echo "'$n' - file doesn't exist"
            return 1
        fi

        case "${n%,}" in
          *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                       tar zxvf "$n"       ;;
          *.lzma)      unlzma ./"$n"      ;;
          *.bz2)       bunzip2 ./"$n"     ;;
          *.cbr|*.rar) unrar x -ad ./"$n" ;;
          *.gz)        gunzip ./"$n"      ;;
          *.cbz|*.epub|*.zip) unzip ./"$n"   ;;
          *.z)         uncompress ./"$n"  ;;
          *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar|*.vhd)
                       7z x ./"$n"        ;;
          *.xz)        unxz ./"$n"        ;;
          *.exe)       cabextract ./"$n"  ;;
          *.cpio)      cpio -id < ./"$n"  ;;
          *.cba|*.ace) unace x ./"$n"     ;;
          *.zpaq)      zpaq x ./"$n"      ;;
          *.arc)       arc e ./"$n"       ;;
          *.cso)       ciso 0 ./"$n" ./"$n.iso" && \
                            extract "$n.iso" && \rm -f "$n" ;;
          *.zlib)      zlib-flate -uncompress < ./"$n" > ./"$n.tmp" && \
                            mv ./"$n.tmp" ./"${n%.*zlib}" && rm -f "$n"   ;;
          *.dmg)
                      hdiutil mount ./"$n" -mountpoint "./$n.mounted" ;;
          *)
                      echo "extract: '$n' - unknown archive method"
                      return 1
                      ;;
        esac
    done
}

onedrivelink() {
    if [ $# -eq 0 ]; then
        echo "Please provide a filename."
        return 1
    fi

    filename=$1
    homedir=$HOME"/OneDrive/"$filename

    if [ -e "$homedir" ]; then
        doas ln -s $homedir /usr/local/bin/$filename
        doas chmod +x /usr/local/bin/$filename
        echo "Symlink created and execution permission granted."
    else
        echo "The file does not exist in the OneDrive folder."
    fi
}

function projectdl() {

  if [ $# -eq 0 ]; then
    echo "No arguments supplied. Please supply a Github username/repo."
    return 1
  fi

  local user_repo=$1
  local download_dir="/usr/local/bin"

  curl -s https://api.github.com/repos/$user_repo/releases/latest \
    | jq -r '.assets[] | select(.name | test("linux";"i")) | .browser_download_url' \
    | xargs -I{} axel -n 16 -o $download_dir {}

  printf "Do you want to extract the downloaded files? (yes/no): "
  read -r extract_choice
  extract_choice=$(echo "$extract_choice" | tr '[:upper:]' '[:lower:]')

  if [[ $extract_choice == "yes" ]]; then
    for file in $download_dir/*; do
      extract "$file" 
    done
  fi

}


playtv() {
    for file in $HOME/Videos/Personal/*; do
        xdg-open "$file"
    done
}

openall() {
    for file in *; do
        if [ -f "$file" ]; then
            xdg-open "$file"
        fi
    done
}

rename-item() {
    mv "$1" "$2"
}

fp() {
    if [ $# -eq 0 ]; then
        echo "Usage: fp <application-name>"
        return
    fi

    app_name=$1

    # Find the application ID
    app_id=$(flatpak list --app --columns=name,application | frawk -v app="$app_name" '{ if ($1 == app) { print $2 } }')

    if [ -z "$app_id" ]; then
        echo "No application found with the name: $app_name"
        return
    fi

    flatpak run $app_id
}

replaceline() {
    lineNumber=$1
    replacement=$2
    filePath=$3
    tempFile=${filePath}_temp
    frawk -v n="$lineNumber" -v s="$replacement" 'NR == n {print s; next} {print}' $filePath > $tempFile
    mv $tempFile $filePath
}

gitsetup() {
git config --global user.name "Danny Kendall"
git config --global user.email "d.manicx100@gmail.com"
git config --global rebase.updateRefs true
git config --global credential.helper store
git config --global --add push.default current
git config --global --add push.autoSetupRemote true
}

instsearch() {
  if test $# -eq 0; then
    echo "Please provide a package name."
    return 1
  fi

  pkg_name=$1

  echo "Searching for package '$pkg_name'"

# Search in dpkg
if type dpkg >/dev/null 2>&1; then
  echo "=== DEB ==="
  dpkg -l | rg -i "$pkg_name"
fi


  # Search in flatpak
  if type flatpak >/dev/null 2>&1; then
    echo "=== FLATPAK ==="
    flatpak list | rg -i "$pkg_name"
  fi

  # Search in snap
  if type snap >/dev/null 2>&1; then
    echo "=== SNAP ==="
    snap list | rg -i "$pkg_name"
  fi

  # Search in am
  if type am >/dev/null 2>&1; then
    echo "=== APPIMAGES ==="
    am -f | rg -i "$pkg_name"
  fi

  # Search in dnf
  if type dnf >/dev/null 2>&1; then
    echo "=== RPM ==="
    dnf list installed | rg -i "$pkg_name"
  fi

  # Search in zypper
  if type zypper >/dev/null 2>&1; then
    echo "=== RPM ==="
    zypper se -i | rg -i "$pkg_name"
  fi

  # Search in paru
  if type paru >/dev/null 2>&1; then
    echo "=== AUR ==="
    paru -Q | rg -i "$pkg_name"
  fi

  # Search in brew
  if type brew >/dev/null 2>&1; then
    echo "=== BREW ==="
    brew list | rg -i "$pkg_name"
  fi

  # Search in mas
  if type mas >/dev/null 2>&1; then
    echo "=== APPSTORE ==="
    mas list | rg -i "$pkg_name"
  fi
}

pkgsearch() {
  if test $# -eq 0; then
    echo "Please provide a package name."
    return 1
  fi

  pkg_name=$1

  echo "Searching for package '$pkg_name'"

  if command -v dpkg >/dev/null; then
    # Search in apt
    echo "=== DEB ==="
    apt-cache search "$pkg_name" | rg -i "$pkg_name"
  fi

  if command -v dnf >/dev/null; then
    # Search in dnf
    echo "=== RPM ==="
    dnf search "$pkg_name"
  fi

  if command -v zypper >/dev/null; then
    # Search in zypper
    echo "=== RPM ==="
    zypper se "$pkg_name"
  fi

  if command -v paru >/dev/null; then
    # Search in paru
    echo "=== AUR ==="
    paru -Ss "$pkg_name"
  fi

  if command -v brew >/dev/null; then
    # Search in brew
    echo "=== BREW ==="
    brew search "$pkg_name"
  fi

  # Search in flatpak
  if command -v flatpak >/dev/null; then
    echo "=== FLATPAK ==="
    flatpak remote-ls flathub | rg -i "$pkg_name"
  fi

  # Search in snap
  if command -v snap >/dev/null; then
    echo "=== SNAP ==="
    snap find "$pkg_name"
  fi

  # Search in am
  if command -v am >/dev/null; then
    echo "=== APPIMAGES ==="
    am -q "$pkg_name"
  fi

  if command -v mas >/dev/null; then
    # Search in mas
    echo "=== APPSTORE ==="
    mas search "$pkg_name"
  fi
}

disable-all-network-interfaces() {
    if type ip > /dev/null 2>&1; then
        for iface in $(ip link show | rg '^[0-9]+:' | rg -oP '[a-zA-Z0-9@.:]+'); do
            echo "Disabling $iface"
            doas ip link set $iface down
        done
    else
        for service in $(networksetup -listallnetworkservices); do
            echo "Disabling $service"
            doas networksetup -setnetworkserviceenabled "$service" off
        done
    fi
}

enable-all-network-interfaces() {
    if type ip > /dev/null 2>&1; then
        for iface in $(ip link show | rg '^[0-9]+:' | rg -oP '[a-zA-Z0-9@.:]+'); do
            echo "Enabling $iface"
            doas ip link set $iface up
        done
    else
        for service in $(networksetup -listallnetworkservices); do
            echo "Enabling $service"
            doas networksetup -setnetworkserviceenabled "$service" on
        done
    fi
}

networkcycle() {
    disable-all-network-interfaces
    enable-all-network-interfaces
}

Resync-Time() {
    if ! command -v ntpdate >/dev/null 2>&1; then
        echo "ntpdate is not installed. Please install it and try again."
        return 1
    fi
    echo "Resyncing system time..."
    doas ntpdate pool.ntp.org
}

fdo() {
    query=$(printf "%s " "$@")
    selected_file=$(fzf --query "$query")
    xdg-open "$selected_file"
}

git_unsynced() {
    for dir in $(find . -name .git -type d -prune); do
        if ! git -C "${dir%/*}" diff --quiet; then
            echo "$dir has uncommitted changes"
            git -C "${dir%/*}" status --short
        fi
    done
}

burnin_srt() {
    filename=$(basename "$1")  # get the full file name
    base=$(echo $filename | sed 's/\.[^.]*$//')  # get the file name without the extension
    subtitle=$(echo $1 | sed 's/\.[^.]*$/.srt/')
    ffmpeg -i "$1" -vf subtitles="$subtitle" -preset ultrafast -threads 0 "$base-srt.mkv"
}

speedupvid() {
    filename=$(basename "$1")  # get the full file name
    extension=$(echo $filename | sed 's/.*\.//')  # get the extension
    base=$(echo $filename | sed 's/\.[^.]*$//')  # get the file name without the extension
    ffmpeg -i "$1" -filter_complex "[0:v]setpts=1/$2*PTS[v];[0:a]atempo=$2[a]" -map "[v]" -map "[a]" -preset ultrafast -threads 0 "$base-speed.mkv"
}

burnin_srt_all() {
    for ext in mp4 avi mkv; do
        for file in *.$ext; do
            # If the glob didn't match any files, move to next iteration
            [ -e "$file" ] || continue
            burnin_srt "$file"
            rm "$file"
        done
    done
}

speedupvid_all() {
    for ext in mp4 avi mkv; do
        for file in *.$ext; do
            # If the glob didn't match any files, move to next iteration
            [ -e "$file" ] || continue
            speedupvid "$file" 1.2
            rm "$file"
            rm *.srt
        done
    done
}

create_empty_srt_files() {
    for f in *.mp4 *.mkv *.avi; do
        if [ -f "$f" ]; then
            base=$(echo "$f" | sed -E 's/\.[^.]+$//')
            srt_file="$base.srt"
            if [ ! -f "$srt_file" ]; then
                touch "$srt_file"
            fi
        fi
    done
}

unhide_files() {
    for file in .*; do
        mv "$file" "${file#.}"
    done
}

hide_files() {
    for file in *; do
        if [ -f "$file" ]; then
            mv "$file" ".$file"
        fi
    done
}

tgupdate() {
$EDITOR $HOME/.config/topgrade.toml
topgrade
}

serv() {
    doas redbean -C /usr/local/bin/ca.crt -K /usr/local/bin/ca.key -p 80 -p 443 -D $@
}

rmopt() {
    rm -rf -v "/opt/$1"
    rm -rf -v "/usr/local/bin/$1"
    rm -rf -v "/usr/local/share/applications/$1.desktop"
}

openperm() {
    doas chmod -R a+rwx $@
}

takeown() {
    doas chown dkendall $@
}

rmspecial() {
    find . -type f -exec bash -c 'mv "$1" "${1//[^[:alnum:].-]/}"' _ {} \;
    unhide_files
}

dictate() {
    cd nerd-dictation
    ./nerd-dictation begin --vosk-model-dir=./model &
}

enddictate() {
    ./nerd-dictation end
    gohome
}

yt-dlp-trim() {
    yt-dlp -f "[protocol!*=dash]" --external-downloader ffmpeg --external-downloader-args "ffmpeg_i:-ss $2 -to $3" $1
}

ffsrtspeed() {
    ffmpeg -i $1 -i $3 -filter_complex "[0:v]setpts=1/$2*PTS[v];[0:a]rubberband=tempo=$2[a]" -map "[v]" -map "[a]" -map 1 -preset ultrafast $($now)-output.mkv
}

image2txt() {
    read -p 'Please provide the file path for the image: ' confirm
    tesseract -l eng $confirm $($now)-output-from-ocr
    cat $($now)-output-from-ocr.txt|xclip -selection c
}

yt-dlp-audio() {
    yt-dlp -f 'ba' -x --audio-format mp3 $@
}

Get-PubIP() {
    wget --no-cache -q -O - ipinfo.io/ip
}

bak() {
    zip -r $HOME/$($now)-bak.zip /etc/default/ /etc/profile.d/ /usr/local/bin /opt/
}

stripclip() {
    xclip -selection c -o | xargs | rg -o '.*' | xclip -selection c
}

osinfo=$(rg -ioP '^ID=\K.+' /etc/os-release)

flushdns() {
doas resolvectl flush-caches
echo "Successfully flushed the DNS Resolver Cache"
}

orderfiles() {
    list=(./**.*)
    for val in ${list[@]}; do
        ext=$(path extension -- $val | string replace . "")
        mkdir -p "$ext"
        cp "$val" "./$ext"
    done
}


yt() {
  cd "$HOME/Videos/yt/"
  yt-dlp -f 'bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]' \
    'https://www.youtube.com/playlist?list=PLJElTFmVZU3vW-BIfsI2AmfVDL9PzqFmg' \
    --external-downloader axel --external-downloader-args "-n 16"

  cd "$HOME"
}

lazyg() {
    local message="$1"
    jj git fetch
    jj rebase -d main
    jj describe -m "$message"
    jj bookmark set main
    jj git push
}

newgit() {
    git add .
    git commit -a --allow-empty-message -m " "
    git push
}

gitprep() {
    git stash
    git pull
    git stash pop
}

gitIgnoreRm() {
    git rm -r --cached .
    git add .
    git commit -m "Update .gitignore"
}

eval "$(zoxide init zsh)"
. "$HOME/.cargo/env"
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"
source ~/powerlevel10k/powerlevel10k.zsh-theme

# bun completions
[ -s "/home/dan/$HOME/.bun/_bun" ] && source "/home/dan/$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
FNM_PATH="/home/dan/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# rm-safely - Safe rm command
source "/home/dan/.rm-safely" >/dev/null 2>&1

#updatecheck
