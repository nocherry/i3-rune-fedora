#!/usr/bin/env bash
# ponytail: toggle rofi default theme between dark (nord) and light (nord-light)
config="$HOME/.config/rofi/config.rasi"
[ -f "$config" ] || { echo "Missing $config" >&2; exit 1; }

if grep -q 'nord-light' "$config"; then
    sed -i 's|themes/nord-light.rasi|themes/nord.rasi|' "$config"
    notify-send "Rofi theme" "Dark theme enabled"
else
    sed -i 's|themes/nord.rasi|themes/nord-light.rasi|' "$config"
    notify-send "Rofi theme" "Light theme enabled"
fi
