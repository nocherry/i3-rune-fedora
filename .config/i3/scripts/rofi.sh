#!/usr/bin/env bash
# ponytail: toggle rofi; if already running — close it, else open drun modi
if pgrep -x rofi >/dev/null 2>&1; then
    pkill -x rofi
else
    rofi -show drun -modi drun,filebrowser,run,window
fi
