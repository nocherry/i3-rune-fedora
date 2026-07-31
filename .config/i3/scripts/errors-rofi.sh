#!/usr/bin/env bash
# ponytail: show recent i3 errors/warnings in rofi
LOGFILE="$HOME/.local/share/i3/log"
mkdir -p "$HOME/.local/share/i3"

if [ -s "$LOGFILE" ]; then
    tail -n 200 "$LOGFILE" | grep -iE "error|warning|critical" | tail -n 50 | \
        rofi -dmenu -i -p "i3 errors" -theme-str 'window {width: 80%; height: 50%;}'
else
    notify-send "i3 errors" "No log captured yet. Run i3-dump-log in background or press Super+Shift+C."
fi
