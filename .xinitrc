#!/bin/sh

pgrep dunst > /dev/null || /usr/bin/dunst &

# Auto-lock after 10 minutes (only if xautolock is installed)
if command -v xautolock >/dev/null 2>&1; then
    xautolock \
      -time 10 \
      -locker "i3lock -c #2e3440" \
      -notify 10 \
      -notifier "/usr/bin/notify-send 'Locking soon' 'The screen will lock in 10 seconds...'" &
fi

# it works like:
# startx ~/.xinitrc dwm
# startx ~/.xinitrc i3
#
# don't use this method if you don't use both window managers, if you are only on i3 then just put
# exec i3
# that should work via startx directly

case "$1" in
    i3)
        exec i3
        ;;
    dwm)
        exec dwm
        ;;
    *)
        exec i3
        ;;
esac
