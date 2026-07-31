#!/usr/bin/env bash
# ponytail: show recent i3 errors/warnings in rofi (live log via i3-dump-log)
i3-dump-log 2>/dev/null | grep -iE "error|warning|critical" | tail -n 50 | \
    rofi -dmenu -i -p "i3 errors" -theme-str 'window {width: 80%; height: 50%;}'
exit 0
