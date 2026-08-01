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
killall -USR1 kitty 2>/dev/null || true

# rofi theme
rofi_config="$HOME/.config/rofi/config.rasi"
if [ "$next" = "light" ]; then
    sed -i 's|themes/nord.rasi|themes/nord-light.rasi|' "$rofi_config"
else
    sed -i 's|themes/nord-light.rasi|themes/nord.rasi|' "$rofi_config"
fi

# GTK theme: gsettings + xsettingsd
xsettingsd_config="$HOME/.config/xsettingsd/xsettingsd.conf"
gtk_config="$HOME/.config/gtk-3.0/settings.ini"
if [ "$next" = "light" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "Papirus" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light" 2>/dev/null || true
    [ -f "$xsettingsd_config" ] && sed -i 's|Net/ThemeName ".*"|Net/ThemeName "Adwaita"|' "$xsettingsd_config"
    [ -f "$xsettingsd_config" ] && sed -i 's|Net/IconThemeName ".*"|Net/IconThemeName "Papirus"|' "$xsettingsd_config"
    [ -f "$gtk_config" ] && sed -i 's|gtk-application-prefer-dark-theme=.*|gtk-application-prefer-dark-theme=false|; s|gtk-theme-name=.*|gtk-theme-name=Adwaita|; s|gtk-icon-theme-name=.*|gtk-icon-theme-name=Papirus|' "$gtk_config"
else
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true
    [ -f "$xsettingsd_config" ] && sed -i 's|Net/ThemeName ".*"|Net/ThemeName "Adwaita-dark"|' "$xsettingsd_config"
    [ -f "$xsettingsd_config" ] && sed -i 's|Net/IconThemeName ".*"|Net/IconThemeName "Papirus-Dark"|' "$xsettingsd_config"
    [ -f "$gtk_config" ] && sed -i 's|gtk-application-prefer-dark-theme=.*|gtk-application-prefer-dark-theme=true|; s|gtk-theme-name=.*|gtk-theme-name=Adwaita-dark|; s|gtk-icon-theme-name=.*|gtk-icon-theme-name=Papirus-Dark|' "$gtk_config"
fi

# Restart xsettingsd to propagate GTK theme changes to running apps
pkill -HUP xsettingsd 2>/dev/null || (pkill xsettingsd 2>/dev/null; xsettingsd &)

# Save state
echo "$next" > "$state_file"

# Reload i3 (picks up border colors)
timeout 2 i3-msg reload >/dev/null 2>&1 || true

notify-send "Theme" "$next mode enabled"
