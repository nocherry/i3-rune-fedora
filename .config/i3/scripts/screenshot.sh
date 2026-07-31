#!/usr/bin/env bash
# ponytail: simple maim wrapper with modes; RU/EN-safe because called from keycodes
mode="${1:-area}"
mkdir -p "$HOME/Pictures/Screenshots"
out="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"

copy_clipboard() {
    [ -s "$out" ] && xclip -selection clipboard -t image/png < "$out" && \
        notify-send "Screenshot" "Copied to clipboard"
}

case "$mode" in
    full)
        maim "$out" && copy_clipboard
        ;;
    area)
        # ponytail: maim -s needs slop; if missing, fall back to full screen
        if command -v slop >/dev/null 2>&1; then
            maim -s "$out" && copy_clipboard
        else
            notify-send "Screenshot" "slop not installed; using full screen"
            maim "$out" && copy_clipboard
        fi
        ;;
    delay5)
        sleep 5
        maim "$out" && copy_clipboard
        ;;
    delay10)
        sleep 10
        maim "$out" && copy_clipboard
        ;;
    *)
        echo "Usage: $0 {full|area|delay5|delay10}" >&2
        exit 1
        ;;
esac
