#!/bin/bash

# Path to your Wine prefix
WINEPREFIX="$HOME/.wine"

# Get the list of directories in the PATH variable and filter out non-existent directories
IFS=: read -r -a path_dirs <<< "$PATH"
valid_path_dirs=()
for dir in "${path_dirs[@]}"; do
    if [ -d "$dir" ]; then
        valid_path_dirs+=("$dir")
    fi
done

# Get list of regular applications by searching in valid PATH directories
regular_apps=$(bfs "${valid_path_dirs[@]}" -type f -executable -not -name "*.desktop" -not -name "*.exe" -print0 | xargs -0 -I {} basename {} | sort -f)

# Get list of Wine applications
wine_apps=$(bfs "$WINEPREFIX" -type f -iname "*.exe" | sort -f | sed 's/^/Wine: /')

# Get list of .desktop files
desktop_files=$(bfs /usr/share/applications ~/.local/share/applications -type f -iname "*.desktop" | sort -f | sed 's/^/Desktop: /')

# Combine all lists
all_apps=$(printf "%s\n%s\n%s\n" "$regular_apps" "$wine_apps" "$desktop_files" | sort -f)

# Use dmenu to select an application
selected_app=$(echo "$all_apps" | dmenu -i -p "Run:")

# Launch the selected application
if [[ $selected_app == Wine:* ]]; then
    # It's a Wine app
    wine_exe="${selected_app#Wine: }"
    wine "$wine_exe" &
elif [[ $selected_app == Desktop:* ]]; then
    # It's a .desktop file
    desktop_file="${selected_app#Desktop: }"
    if command -v gtk-launch &> /dev/null; then
        gtk-launch "$(basename "$desktop_file" .desktop)" &
    elif command -v dex &> /dev/null; then
        dex "$desktop_file" &
    elif command -v gio &> /dev/null; then
        GIO_LAUNCHED_DESKTOP_FILE_LOG_STDOUT=1 gio launch "$desktop_file" &
    else
        echo "Failed to launch $desktop_file: No suitable launcher found"
        exit 1
    fi
else
    # Check if the selected app is a .desktop file
    if [[ $selected_app == *.desktop ]]; then
        if command -v gtk-launch &> /dev/null; then
            gtk-launch "$(basename "$selected_app" .desktop)" &
        elif command -v dex &> /dev/null; then
            dex "$selected_app" &
        elif command -v gio &> /dev/null; then
            GIO_LAUNCHED_DESKTOP_FILE_LOG_STDOUT=1 gio launch "$selected_app" &
        else
            echo "Failed to launch $selected_app: No suitable launcher found"
            exit 1
        fi
    else
        # It's a regular app, just execute it by name
        "$selected_app" &
    fi
fi

