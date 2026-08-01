#!/usr/bin/env bash

STEP=5
DEVICE=${POLYBAR_BACKLIGHT:-}
args=()
[[ -n "$DEVICE" ]] && args=(-d "$DEVICE")

get_brightness() {
    local value
    value=$(brightnessctl "${args[@]}" -m 2>/dev/null | cut -d, -f4 | sed -n '1p')
    printf '%s\n' "${value:-n/a}"
}

case "$1" in
    up)
        brightnessctl "${args[@]}" set +${STEP}% >/dev/null
        ;;
    down)
        brightnessctl "${args[@]}" set ${STEP}%- >/dev/null
        ;;
esac

get_brightness
