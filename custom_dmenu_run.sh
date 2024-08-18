#!/bin/bash
WINEPREFIX="$HOME/.wine"

# Function to print debug information
debug_print() {
    echo "DEBUG: $1" >&2
}

# Get valid PATH directories and ensure /usr/local/bin is included
IFS=: read -r -a path_dirs <<< "$PATH"
valid_path_dirs=()
for dir in "${path_dirs[@]}"; do
    # Exclude Flatpak directories from PATH
    if [[ "$dir" != */flatpak/* ]]; then
        valid_path_dirs+=("$dir")
    fi
done
[[ ! " ${valid_path_dirs[*]} " =~ " /usr/local/bin " ]] && valid_path_dirs+=("/usr/local/bin")

debug_print "Valid PATH directories: ${valid_path_dirs[*]}"

# Get list of all executable files in PATH directories (excluding Flatpak)
path_files=$(bfs "${valid_path_dirs[@]}" -executable -printf "%f\n" 2>/dev/null | tr '[:upper:]' '[:lower:]' | sort -u)
debug_print "PATH files: $path_files"

# Get list of Flatpak apps
flatpak_apps=$(bfs /var/lib/flatpak/exports/bin -executable -printf "Flatpak: %f\n" 2>/dev/null | tr '[:upper:]' '[:lower:]' | sort -u)
debug_print "Flatpak apps: $flatpak_apps"

# Get list of Wine applications
wine_apps=$(bfs "$WINEPREFIX" -type f -iname "*.exe" -printf "Wine: %f\n" 2>/dev/null | tr '[:upper:]' '[:lower:]' | sort -u)
debug_print "Wine apps: $wine_apps"

# Get list of .desktop files
desktop_files=$(bfs /usr/share/applications ~/.local/share/applications -type f -iname "*.desktop" -printf "Desktop: %f\n" 2>/dev/null | tr '[:upper:]' '[:lower:]' | sort -u)
debug_print "Desktop files: $desktop_files"

# Combine all lists
all_apps=$(printf "%s\n%s\n%s\n%s\n" "$path_files" "$flatpak_apps" "$wine_apps" "$desktop_files" | sort -u)
debug_print "All apps:"
debug_print "$all_apps"

# Use dmenu to select an application
selected_app=$(echo "$all_apps" | dmenu -i -p "Run:")

# Launch the selected application
case "$selected_app" in
    wine:*)
        wine "${selected_app#wine: }" &
        ;;
    desktop:*)
        desktop_file="${selected_app#desktop: }"
        if command -v gio &> /dev/null; then
            GIO_LAUNCHED_DESKTOP_FILE_LOG_STDOUT=1 gio launch "$desktop_file" &
        else
            echo "Failed to launch $desktop_file: gio not found"
            exit 1
        fi
        ;;
    flatpak:*)
        "${selected_app#flatpak: }" &
        ;;
    *)
        "$selected_app" &
        ;;
esac
