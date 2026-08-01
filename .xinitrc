#!/bin/sh

[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

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
