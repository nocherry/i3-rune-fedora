#!/usr/bin/env bash
# ponytail: persistent X11 color-temperature control
state_file="$HOME/.config/i3/eye-care-state"
warm_temp=${EYE_CARE_WARM_TEMP:-4200}

valid_temp() {
    [[ "$1" =~ ^[0-9]+$ ]] && ((10#$1 >= 2500 && 10#$1 <= 6500))
}

if [[ "${1:-}" == "--self-test" ]]; then
    valid_temp 4200 && ! valid_temp 2000 && ! valid_temp text
    exit
fi

if [[ "${1:-}" == "status" ]]; then
    current=$(cat "$state_file" 2>/dev/null || printf '%s' neutral)
    [[ "$current" == "neutral" ]] && printf '%s\n' "󰖨 6500K" || printf '󰖨 %sK\n' "$current"
    exit
fi

if command -v redshift >/dev/null 2>&1; then
    backend=redshift
elif command -v xrandr >/dev/null 2>&1; then
    backend=xrandr
else
    notify-send -u critical "Eye care" "redshift or xrandr is required"
    exit 1
fi

apply_xrandr() {
    local mode="$1" gamma output status
    case "$mode" in
        neutral) gamma="1:1:1" ;;
        *)
            if ((10#$mode >= 5750)); then gamma="1:0.95:0.90"
            elif ((10#$mode >= 4600)); then gamma="1:0.85:0.70"
            elif ((10#$mode >= 3850)); then gamma="1:0.72:0.52"
            else gamma="1:0.62:0.42"
            fi
            ;;
    esac
    while read -r output status _; do
        [[ "$status" == "connected" ]] && xrandr --output "$output" --gamma "$gamma"
    done < <(xrandr --query)
}

apply_mode() {
    local mode="$1" quiet="${2:-}"
    if [[ "$mode" == "neutral" ]]; then
        [[ "$backend" == "redshift" ]] && redshift -x >/dev/null || apply_xrandr neutral
        message="Neutral white"
    elif valid_temp "$mode"; then
        [[ "$backend" == "redshift" ]] && redshift -P -O "$mode" >/dev/null || apply_xrandr "$mode"
        message="${mode}K ($backend)"
    else
        return 1
    fi
    printf '%s\n' "$mode" > "$state_file"
    [[ "$quiet" == "quiet" ]] || notify-send "Eye care" "$message"
}

case "${1:-menu}" in
    menu)
        choice=$(printf '%s\n' "Neutral white (6500K)" "Soft warm (5000K)" "Warm (4200K)" "Very warm (3500K)" | rofi -dmenu -i -p "Screen color")
        case "$choice" in
            "Neutral white (6500K)") apply_mode neutral ;;
            "Soft warm (5000K)")     apply_mode 5000 ;;
            "Warm (4200K)")          apply_mode 4200 ;;
            "Very warm (3500K)")     apply_mode 3500 ;;
        esac
        ;;
    toggle)
        current=$(cat "$state_file" 2>/dev/null || printf '%s' neutral)
        [[ "$current" == "neutral" ]] && apply_mode "$warm_temp" || apply_mode neutral
        ;;
    restore)
        apply_mode "$(cat "$state_file" 2>/dev/null || printf '%s' neutral)" quiet
        ;;
    neutral) apply_mode neutral ;;
    *) apply_mode "$1" ;;
esac
