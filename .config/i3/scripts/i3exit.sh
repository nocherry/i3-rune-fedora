#!/bin/sh

confirm() {
    [ "$(printf 'Cancel\nConfirm\n' | rofi -dmenu -p "Confirm $1?")" = "Confirm" ]
}

locked() {
    pgrep -x xsecurelock >/dev/null 2>&1 || pgrep -x i3lock >/dev/null 2>&1
}

lock_screen() {
    locked && return 0
    if pgrep -x xss-lock >/dev/null 2>&1; then
        xset s activate
    else
        "$HOME/.config/i3/scripts/lock-screen.sh" >/dev/null 2>&1 &
    fi

    attempts=0
    while [ "$attempts" -lt 50 ]; do
        locked && return 0
        sleep 0.1
        attempts=$((attempts + 1))
    done
    return 1
}

case "$1" in
    lock)
        lock_screen
        ;;
    logout)
        confirm logout || exit 0
        i3-msg exit
        ;;
    suspend)
        lock_screen && systemctl suspend -i
        ;;
    hibernate)
        lock_screen && systemctl hibernate -i
        ;;
    reboot)
        confirm reboot || exit 0
        systemctl reboot
        ;;
    shutdown)
        confirm shutdown || exit 0
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
