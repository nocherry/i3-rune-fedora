#!/usr/bin/env bash
# ponytail: reload i3 config only if it is valid
CONFIG="${1:-$HOME/.config/i3/config}"
if i3 -C -c "$CONFIG" 2>/tmp/i3-config-check.err; then
    i3-msg reload >/dev/null 2>&1
    notify-send "i3" "Config reloaded"
else
    notify-send -u critical "i3" "Config has errors, reload cancelled"
fi
