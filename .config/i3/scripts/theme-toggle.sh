#!/usr/bin/env bash
# ponytail: toggle full desktop theme between dark and light
set -e

state_file="$HOME/.config/i3/theme-state"
current=$(cat "$state_file" 2>/dev/null || echo "dark")

if [ "$current" = "dark" ]; then
    next="light"
else
    next="dark"
fi

# i3 borders
cp "$HOME/.config/i3/themes/${next}.conf" "$HOME/.config/i3/theme-current.conf"

# polybar colors
cp "$HOME/.config/polybar/colors-${next}.ini" "$HOME/.config/polybar/colors-current.ini"

# kitty terminal theme
cp "$HOME/.config/kitty/theme-${next}.conf" "$HOME/.config/kitty/theme-current.conf"

# rofi theme
rofi_config="$HOME/.config/rofi/config.rasi"
if [ "$next" = "light" ]; then
    sed -i 's|themes/nord.rasi|themes/nord-light.rasi|' "$rofi_config"
else
    sed -i 's|themes/nord-light.rasi|themes/nord.rasi|' "$rofi_config"
fi

# GTK theme via gsettings (best-effort)
if [ "$next" = "light" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "Papirus" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light" 2>/dev/null || true
else
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
fi

# Save state
echo "$next" > "$state_file"

# Reload i3 (picks up border colors)
i3-msg reload >/dev/null 2>&1 || true

# Restart polybar (picks up colors)
~/.config/polybar/launch.sh >/dev/null 2>&1 || true

notify-send "Theme" "$next mode enabled"
