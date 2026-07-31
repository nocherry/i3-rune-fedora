#!/usr/bin/env bash
# ponytail: screenshot wrapper; area mode uses flameshot (frozen screen + select)
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
        # flameshot captures screen first, shows frozen overlay, then selects.
        # -s = accept on selection (no editor), -p = save path, -c = copy to clipboard.
        flameshot gui -p "$out" -c -s
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
