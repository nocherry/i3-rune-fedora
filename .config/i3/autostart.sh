#!/bin/bash
# Kill old instances
killall polybar picom dunst nm-applet blueman-applet lxqt-policykit-agent 2>/dev/null
sleep 0.3

# Russian keyboard (Alt+Shift)
setxkbmap -layout us,ru -option grp:alt_shift_toggle &

# Polkit (GUI sudo dialogs)
/usr/bin/lxqt-policykit-agent &

# Compositor (shadows, transparency)
picom --backend glx -b &

# Notifications
dunst &

# Network icon in tray
nm-applet &

# Bluetooth icon in tray
blueman-applet &

# Top bar
~/.config/polybar/launch.sh &

# Wallpaper
feh --bg-fill ~/.config/i3/wallpaper.png &
