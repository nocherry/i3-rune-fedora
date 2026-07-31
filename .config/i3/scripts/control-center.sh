#!/usr/bin/env bash
# ponytail: rofi quick settings / control center
choice=$(cat <<'EOF' | rofi -dmenu -i -p "Control"
WiFi: toggle
WiFi: settings
Bluetooth: toggle
Bluetooth: settings
Volume: +5%
Volume: -5%
Volume: mute
Brightness: +5%
Brightness: -5%
Screenshot: area
Screenshot: full
Screenshot: to clipboard (area)
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
    "WiFi: toggle")        nmcli radio wifi toggle ;;
    "WiFi: settings")      nm-connection-editor ;;
    "Bluetooth: toggle")   bluetoothctl power toggle ;;
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
