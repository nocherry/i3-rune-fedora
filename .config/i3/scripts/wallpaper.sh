#!/usr/bin/env bash
# Set random wallpaper from ~/Pictures/wallpapers with fallback.
# Handles filenames with spaces and missing directories gracefully.

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
FALLBACK="$HOME/.config/i3/wallpaper.png"
CURRENT="$HOME/.config/i3/wallpaper-current"

if [ -s "$CURRENT" ]; then
    IFS= read -r wp < "$CURRENT"
    if [ -f "$wp" ]; then
        exec feh --bg-fill --no-fehbg "$wp"
    fi
fi

if [ -s "$HOME/.config/nitrogen/bg-saved.cfg" ] && command -v nitrogen >/dev/null 2>&1; then
    exec nitrogen --restore
fi

mapfile -d '' files < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) -print0 2>/dev/null)
wp=""
[ ${#files[@]} -gt 0 ] && wp=${files[RANDOM % ${#files[@]}]}

if [ -n "$wp" ]; then
    feh --bg-fill --no-fehbg "$wp"
else
    [ -f "$FALLBACK" ] && feh --bg-fill --no-fehbg "$FALLBACK"
fi
