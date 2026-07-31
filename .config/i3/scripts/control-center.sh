#!/usr/bin/env bash
# ponytail: rofi quick settings / control center
choice=$(cat <<'EOF' | rofi -dmenu -i -p "Control"
WiFi: networks
WiFi: toggle on/off
WiFi: settings
Bluetooth: toggle on/off
Bluetooth: settings
Volume: +5%
Volume: -5%
Volume: mute
Brightness: +5%
Brightness: -5%
Screenshot: area
Screenshot: full
Launch: tg-ws-proxy
Lock
Logout
Reboot
Shutdown
Theme: toggle dark/light
Polybar: toggle
Wallpaper: random
Wallpaper: select
EOF
)

[ -z "$choice" ] && exit 0

case "$choice" in
    "WiFi: networks")      ~/.config/i3/scripts/wifi-menu.sh ;;
    "WiFi: toggle on/off") nmcli radio wifi $(nmcli radio wifi | grep -q enabled && echo off || echo on) ;;
    "WiFi: settings")      nm-connection-editor ;;
    "Bluetooth: toggle on/off") bluetoothctl power $(bluetoothctl show | grep -q "Powered: yes" && echo off || echo on) ;;
    "Bluetooth: settings") blueman-manager ;;
    "Volume: +5%")         pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
    "Volume: -5%")         pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
    "Volume: mute")        pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
    "Brightness: +5%")     brightnessctl set +5% ;;
    "Brightness: -5%")     brightnessctl set 5%- ;;
    "Screenshot: area")    ~/.config/i3/scripts/screenshot.sh area ;;
    "Screenshot: full")   ~/.config/i3/scripts/screenshot.sh full ;;
    "Screenshot: to clipboard (area)") ~/.config/i3/scripts/screenshot.sh area ;;
    "Launch: tg-ws-proxy") ~/.config/i3/launchers/tg-ws-proxy.sh ;;
    "Lock")               ~/.config/i3/scripts/i3exit.sh lock ;;
    "Logout")             ~/.config/i3/scripts/i3exit.sh logout ;;
    "Reboot")             ~/.config/i3/scripts/i3exit.sh reboot ;;
    "Shutdown")           ~/.config/i3/scripts/i3exit.sh shutdown ;;
    "Theme: toggle dark/light") ~/.config/i3/scripts/theme-toggle.sh ;;
    "Polybar: toggle")     polybar-msg cmd toggle ;;
    "Wallpaper: random")   ~/.config/i3/scripts/wallpaper.sh ;;
    "Wallpaper: select")   ~/.config/i3/scripts/wallpaper-selector.sh ;;
esac
