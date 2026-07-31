#!/usr/bin/env bash
# Set random wallpaper from ~/Pictures/wallpapers with fallback.
# Handles filenames with spaces and missing directories gracefully.

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
FALLBACK="$HOME/.config/i3/wallpaper.png"

wp=$(find "$WALLPAPER_DIR" -type f 2>/dev/null | shuf -n 1)

if [ -n "$wp" ]; then
    feh --bg-fill --no-fehbg "$wp"
else
    feh --bg-fill --no-fehbg "$FALLBACK"
fi
