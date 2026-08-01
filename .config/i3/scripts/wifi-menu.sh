#!/usr/bin/env bash
# ponytail: rofi WiFi network menu using nmcli
export LC_ALL=C

# nmcli escapes ':' and '\' in terse output; IFS=: does not understand that.
split_nmcli() {
    local input="$1" char field="" i
    NMCLI_FIELDS=()
    for ((i = 0; i < ${#input}; i++)); do
        char=${input:i:1}
        if [[ "$char" == \\ ]] && ((i + 1 < ${#input})); then
            ((i++))
            field+=${input:i:1}
        elif [[ "$char" == : ]]; then
            NMCLI_FIELDS+=("$field")
            field=""
        else
            field+="$char"
        fi
    done
    NMCLI_FIELDS+=("$field")
}

if [[ "${1:-}" == "--self-test" ]]; then
    split_nmcli 'Cafe\:Lab:AA\:BB:80:WPA2:yes'
    [[ "${NMCLI_FIELDS[0]}" == 'Cafe:Lab' && "${NMCLI_FIELDS[1]}" == 'AA:BB' && "${#NMCLI_FIELDS[@]}" == 5 ]]
    exit
fi

exec 9>"${XDG_RUNTIME_DIR:-$HOME/.cache}/i3-fedora-wifi-menu.lock"
flock -n 9 || exit 0

while true; do
    nmcli device wifi rescan 2>/dev/null || true
    mapfile -t lines < <(nmcli -t --escape yes -f SSID,BSSID,SIGNAL,SECURITY,ACTIVE device wifi list 2>/dev/null)

    ssids=()
    bssids=()
    options=$'T\t[toggle WiFi on/off]\nS\t[advanced network settings]\nX\t[close]\n'
    for line in "${lines[@]}"; do
        split_nmcli "$line"
        ssid=${NMCLI_FIELDS[0]:-}
        [[ -z "$ssid" ]] && continue
        index=${#ssids[@]}
        ssids+=("$ssid")
        bssids+=("${NMCLI_FIELDS[1]:-}")
        label=${ssid//$'\n'/ }
        label=${label//$'\t'/ }
        marker=" "
        [[ "${NMCLI_FIELDS[4]:-}" == "yes" ]] && marker="*"
        printf -v row '%d\t%s %s  [%s%%]  %s\n' "$index" "$marker" "$label" "${NMCLI_FIELDS[2]:-0}" "${NMCLI_FIELDS[3]:---}"
        options+="$row"
    done

    choice=$(printf '%s' "$options" | rofi -dmenu -i -no-click-to-exit -kb-cancel "Escape,Super+q" -p "WiFi")
    [[ -z "$choice" ]] && exit 0
    index=${choice%%$'\t'*}

    case "$index" in
        X) exit 0 ;;
        T)
            state=$(nmcli -t -f WIFI general 2>/dev/null)
            [[ "$state" == "enabled" ]] && nmcli radio wifi off || nmcli radio wifi on
            ;;
        S) nm-connection-editor ;;
        *)
            [[ "$index" =~ ^[0-9]+$ && -n "${ssids[index]+set}" ]] || continue
            ssid=${ssids[index]}
            bssid=${bssids[index]}
            if output=$(nmcli device wifi connect "$ssid" bssid "$bssid" 2>&1); then
                notify-send "WiFi" "Connected to $ssid"
            else
                notify-send -u critical "WiFi" "Could not connect to $ssid. Open advanced settings.\n$output"
            fi
            ;;
    esac
done
