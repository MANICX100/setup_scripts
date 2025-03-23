#!/bin/bash

# Directory containing wallpapers
WALLPAPER_DIR="/home/dkendall/OneDrive/Wallpapers"

# Interval in seconds between wallpaper changes
INTERVAL=300  # Change every 5 minutes

while true; do
    for wallpaper in "$WALLPAPER_DIR"/*; do
        # Set the wallpaper with feh
        feh --bg-center "$wallpaper"
        # Wait for the specified interval
        sleep "$INTERVAL"
    done
done
