#!/bin/bash

lock="󰌾 Заблокировать экран"
logout="󰍃 Выйти из сеанса"
suspend="󰒲 Перейти в сон"
reboot="󰑓 Перезагрузить"
shutdown="󰐥 Выключить"

options="$lock\n$logout\n$suspend\n$reboot\n$shutdown"

theme="$HOME/.config/rofi/themes/powermenu.rasi"

chosen=$(printf '%b\n' "$options" | rofi -dmenu -i -no-custom -kb-cancel "Escape,Super+q" -p "Питание" -theme "$theme")

case "$chosen" in
    "$lock") ~/.config/i3/scripts/i3exit.sh lock ;;
    "$logout") ~/.config/i3/scripts/i3exit.sh logout ;;
    "$suspend") ~/.config/i3/scripts/i3exit.sh suspend ;;
    "$reboot") ~/.config/i3/scripts/i3exit.sh reboot ;;
    "$shutdown") ~/.config/i3/scripts/i3exit.sh shutdown ;;
esac
