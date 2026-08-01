#!/usr/bin/env bash
# ponytail: one owned polybar launcher, restarted after crashes

runtime_dir=${XDG_RUNTIME_DIR:-/tmp/i3-fedora-$UID}
state_dir=${XDG_STATE_HOME:-$HOME/.local/state}/i3-fedora
mkdir -p -m 700 "$runtime_dir" "$state_dir"
pidfile="$runtime_dir/polybar-launcher.pid"
log="$state_dir/polybar.log"

if read -r old_pid < "$pidfile" 2>/dev/null && kill -0 "$old_pid" 2>/dev/null; then
    old_cmd=$(tr '\0' ' ' < "/proc/$old_pid/cmdline" 2>/dev/null)
    [[ "$old_cmd" == *".config/polybar/launch.sh"* ]] && kill "$old_pid" 2>/dev/null
fi
printf '%s\n' "$$" > "$pidfile"

child=""
cleanup() {
    [[ -n "$child" ]] && kill "$child" 2>/dev/null
    if read -r current_pid < "$pidfile" 2>/dev/null && [[ "$current_pid" == "$$" ]]; then
        rm -f "$pidfile"
    fi
}
trap cleanup EXIT INT TERM
chmod 700 "$runtime_dir" "$state_dir"

if [[ -z "${POLYBAR_BATTERY:-}" ]]; then
    for path in /sys/class/power_supply/BAT*; do
        [[ -e "$path" ]] && export POLYBAR_BATTERY=${path##*/} && break
    done
fi
if [[ -z "${POLYBAR_ADAPTER:-}" ]]; then
    for path in /sys/class/power_supply/AC* /sys/class/power_supply/ADP*; do
        [[ -e "$path" ]] && export POLYBAR_ADAPTER=${path##*/} && break
    done
fi
if [[ -z "${POLYBAR_NETWORK:-}" ]]; then
    wifi_device=""
    while IFS=: read -r device type state; do
        if [[ "$type" == "wifi" ]]; then
            [[ -z "$wifi_device" ]] && wifi_device=$device
            [[ "$state" == "connected" ]] && wifi_device=$device && break
        fi
    done < <(LC_ALL=C nmcli -t -f DEVICE,TYPE,STATE device status 2>/dev/null)
    [[ -n "$wifi_device" ]] && export POLYBAR_NETWORK=$wifi_device
fi
if [[ -z "${POLYBAR_BACKLIGHT:-}" ]]; then
    for path in /sys/class/backlight/*; do
        [[ -e "$path" ]] && export POLYBAR_BACKLIGHT=${path##*/} && break
    done
fi

printf '%s\n' "--- $(date --iso-8601=seconds)" > "$log"
while true; do
    polybar main >> "$log" 2>&1 &
    child=$!
    wait "$child"
    child=""
    sleep 1
done
