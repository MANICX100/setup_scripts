#!/bin/bash

# Path to your Wine prefix
WINEPREFIX="$HOME/.wine"

# Get list of regular applications
regular_apps=$(dmenu_path)

# Get list of Wine applications
wine_apps=$(bfs "$WINEPREFIX" -type f -iname "*.exe" | sort | uniq | sed 's/^/Wine: /')

# Combine both lists
all_apps=$(printf "%s\n%s\n" "$regular_apps" "$wine_apps" | sort)

# Use dmenu to select an application
selected_app=$(echo "$all_apps" | dmenu -i -p "Run:")

# Launch the selected application
if [[ $selected_app == Wine:* ]]; then
    # It's a Wine app
    wine_exe="${selected_app#Wine: }"
    wine "$wine_exe" &
else
    # It's a regular app
    $selected_app &
fi
