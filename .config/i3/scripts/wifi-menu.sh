#!/usr/bin/env bash
# ponytail: rofi WiFi network menu using nmcli

# Rescan for networks
nmcli device wifi rescan 2>/dev/null || true

# Build list: ACTIVE  SSID  SIGNAL  SECURITY
mapfile -t lines < <(nmcli -t -f SSID,SIGNAL,SECURITY,ACTIVE device wifi list 2>/dev/null)

list=""
for line in "${lines[@]}"; do
    IFS=: read -r ssid signal security active <<< "$line"
    [ -z "$ssid" ] && continue
    marker=""
    [ "$active" = "yes" ] && marker="* "
    list+="${marker}${ssid}  [${signal}%]  ${security}\n"
done

# Add toggle option
list="[toggle WiFi on/off]\n${list}"

choice=$(echo -e "$list" | rofi -dmenu -i -p "WiFi")
[ -z "$choice" ] && exit 0

# Handle toggle
if [[ "$choice" == "[toggle WiFi on/off]" ]]; then
    nmcli radio wifi toggle
    exit 0
fi

# Parse SSID (everything before the signal indicator)
ssid=$(echo "$choice" | sed -E 's/^\*? *//; s/  \[.*//')
[ -z "$ssid" ] && exit 0

# Try to connect
if nmcli connection show "$ssid" &>/dev/null; then
    nmcli connection up "$ssid" && notify-send "WiFi" "Connected to $ssid" || notify-send -u critical "WiFi" "Failed to connect to $ssid"
else
    nmcli device wifi connect "$ssid" && notify-send "WiFi" "Connected to $ssid" || notify-send -u critical "WiFi" "Failed to connect to $ssid"
fi
