#!/usr/bin/env bash
# ponytail: rofi-based wallpaper picker with Random and fallback options
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
FALLBACK="$HOME/.config/i3/wallpaper.png"

mkdir -p "$WALLPAPER_DIR"

# Build list: random, fallback option, then sorted filenames
mapfile -t files < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) -printf '%f\n' 2>/dev/null | sort)

list="Random\nSet as fallback"
[ ${#files[@]} -gt 0 ] && list="$list\n$(printf '%s\n' "${files[@]}")"

choice=$(echo -e "$list" | rofi -dmenu -i -p "Wallpaper")
[ -z "$choice" ] && exit 0

case "$choice" in
    Random)
        ~/.config/i3/scripts/wallpaper.sh
        ;;
    "Set as fallback")
        wp=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' \) | shuf -n 1)
        if [ -n "$wp" ]; then
            cp "$wp" "$FALLBACK"
            feh --bg-fill --no-fehbg "$FALLBACK"
            notify-send "Wallpaper" "Fallback updated"
        else
            notify-send -u critical "Wallpaper" "No wallpapers found in $WALLPAPER_DIR"
        fi
        ;;
    *)
        feh --bg-fill --no-fehbg "$WALLPAPER_DIR/$choice"
        ;;
esac
