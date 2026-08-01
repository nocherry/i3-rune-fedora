#!/bin/sh

umask 077

build_fallback() {
    size=$(xrandr --current 2>/dev/null | sed -n 's/.* current \([0-9][0-9]*\) x \([0-9][0-9]*\).*/\1x\2/p')
    size=${size:-1920x1080}
    width=${size%x*}
    height=${size#*x}
    center_x=$((width / 2))
    center_y=$((height / 2))
    left=$((center_x - 360))
    right=$((center_x + 360))
    top=$((center_y - 250))
    bottom=$((center_y + 250))
    image=${1:-${XDG_RUNTIME_DIR:-/tmp}/i3-lock-screen.png}
    source="$HOME/.config/i3/wallpaper.png"
    [ -s "$HOME/.config/i3/wallpaper-current" ] && IFS= read -r source < "$HOME/.config/i3/wallpaper-current"
    [ -f "$source" ] || source="$HOME/Pictures/wallpapers/bg.png"
    font=$(fc-match -f '%{file}' 'JetBrainsMono Nerd Font' 2>/dev/null)
    [ -n "$font" ] || font=DejaVu-Sans

    if [ -f "$source" ]; then
        magick "$source" -auto-orient -resize "${size}^" -gravity center -extent "$size" -blur 0x12 \
            -fill '#1f222dcc' -draw "rectangle 0,0 $width,$height" \
            -fill '#2e3440ee' -draw "roundrectangle $left,$top $right,$bottom 28,28" \
            -font "$font" -gravity center \
            -fill '#eceff4' -pointsize 62 -annotate +0-175 "$(date '+%H:%M')" \
            -fill '#d8dee9' -pointsize 18 -annotate +0-125 "$(date '+%A, %d %B')" \
            -fill '#eceff4' -pointsize 25 -annotate +0-82 'Сеанс заблокирован' \
            -fill '#d8dee9' -pointsize 17 -annotate +0+115 'Введите пароль и нажмите Enter' \
            -fill '#88c0d0' -pointsize 15 -annotate +0+160 'RU / EN: Alt + Shift' \
            -fill '#a3be8c' -pointsize 14 -annotate +0+205 'Esc очищает ввод' \
            "$image"
    else
        magick -size "$size" 'xc:#1f222d' \
            -fill '#2e3440' -draw "roundrectangle $left,$top $right,$bottom 28,28" \
            -font "$font" -gravity center \
            -fill '#eceff4' -pointsize 62 -annotate +0-175 "$(date '+%H:%M')" \
            -fill '#d8dee9' -pointsize 18 -annotate +0-125 "$(date '+%A, %d %B')" \
            -fill '#eceff4' -pointsize 25 -annotate +0-82 'Сеанс заблокирован' \
            -fill '#d8dee9' -pointsize 17 -annotate +0+115 'Введите пароль и нажмите Enter' \
            -fill '#88c0d0' -pointsize 15 -annotate +0+160 'RU / EN: Alt + Shift' \
            -fill '#a3be8c' -pointsize 14 -annotate +0+205 'Esc очищает ввод' \
            "$image"
    fi
    printf '%s\n' "$image"
}

if [ "${1:-}" = "--preview" ]; then
    build_fallback "${2:-}"
    exit
fi

if command -v xsecurelock >/dev/null 2>&1; then
    export XSECURELOCK_SAVER=saver_blank
    export XSECURELOCK_BACKGROUND_COLOR='#1f222d'
    export XSECURELOCK_AUTH_BACKGROUND_COLOR='#2e3440'
    export XSECURELOCK_AUTH_FOREGROUND_COLOR='#eceff4'
    export XSECURELOCK_AUTH_WARNING_COLOR='#bf616a'
    export XSECURELOCK_SHOW_DATETIME=1
    export XSECURELOCK_DATETIME_FORMAT='%H:%M | %A, %d %B'
    export XSECURELOCK_SHOW_USERNAME=1
    export XSECURELOCK_SHOW_HOSTNAME=0
    export XSECURELOCK_SHOW_KEYBOARD_LAYOUT=1
    export XSECURELOCK_SINGLE_AUTH_WINDOW=1
    export XSECURELOCK_PASSWORD_PROMPT=asterisks
    export XSECURELOCK_FONT='JetBrainsMono Nerd Font-16'
    export XSECURELOCK_AUTH_TIMEOUT=120
    export XSECURELOCK_BLANK_TIMEOUT=-1
    export XSECURELOCK_COMPOSITE_OBSCURER=0
    exec xsecurelock
fi

image=$(build_fallback) || exit 1
exec i3lock -n -e -f -k -i "$image"
