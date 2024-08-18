#!/bin/bash
WINEPREFIX="$HOME/.wine"

IFS=: read -r -a path_dirs <<< "$PATH:/usr/local/bin"
valid_path_dirs=()
for dir in "${path_dirs[@]}"; do
    if [[ "$dir" != */flatpak/* ]]; then
        valid_path_dirs+=("$dir")
    fi
done

path_files=$(bfs "${valid_path_dirs[@]}" -maxdepth 1 -printf "%f\n" 2>/dev/null | rg -v '\.desktop$' | sort -u)

flatpak_apps=$(flatpak list --app --columns=application | sort -u | sed 's/^/Flatpak: /')

wine_apps=$(bfs "$WINEPREFIX" -type f -iname "*.exe" -printf "Wine: %P\n" 2>/dev/null | sort -u)

desktop_files=$(bfs /usr/share/applications ~/.local/share/applications -type f -name "*.desktop" -printf "Desktop: %f\n" 2>/dev/null | sort -u)

all_apps=$(printf "%s\n%s\n%s\n%s\n" "$path_files" "$flatpak_apps" "$wine_apps" "$desktop_files" | sort -u)

selected_app=$(echo "$all_apps" | dmenu -i -p "Run:")

case "$selected_app" in
    Wine:*)
        wine_path="${selected_app#Wine: }"
        full_path="$WINEPREFIX/$wine_path"
        if [ -f "$full_path" ]; then
            wine "$full_path" &
        else
            echo "Error: File not found - $full_path" >&2
        fi
        ;;
    Desktop:*)
        desktop_file="${selected_app#Desktop: }"
        if [ -f "/usr/share/applications/$desktop_file" ]; then
            gio launch "/usr/share/applications/$desktop_file" &
        elif [ -f "$HOME/.local/share/applications/$desktop_file" ]; then
            gio launch "$HOME/.local/share/applications/$desktop_file" &
        else
            echo "Error: Desktop file not found - $desktop_file" >&2
        fi
        ;;
    Flatpak:*)
        flatpak_app="${selected_app#Flatpak: }"
        flatpak run "$flatpak_app" &
        ;;
    *)
        if command -v "$selected_app" >/dev/null 2>&1; then
            "$selected_app" &
        else
            echo "Error: Command not found - $selected_app" >&2
        fi
        ;;
esac
