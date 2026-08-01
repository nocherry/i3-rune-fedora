#!/usr/bin/env bash

card=${AUDIO_CARD:-0}
source_name=${AUDIO_SOURCE:-alsa_input.pci-0000_00_1f.3.analog-stereo}
headset_port=${HEADSET_MIC_PORT:-analog-input-headset-mic}
internal_port=${INTERNAL_MIC_PORT:-analog-input-internal-mic}
lock=${XDG_RUNTIME_DIR:-/tmp}/i3-audio-port-autoswitch.lock
last_state=

jack_state() {
    if amixer -c "$card" cget iface=CARD,name='Headphone Jack' 2>/dev/null | grep -q ': values=on'; then
        printf '%s\n' plugged
    else
        printf '%s\n' unplugged
    fi
}

apply_port() {
    state=$(jack_state)
    [[ "$state" == "$last_state" ]] && return
    if [[ "$state" == plugged ]]; then
        port=$headset_port
    else
        port=$internal_port
    fi
    pactl set-source-port "$source_name" "$port" && last_state=$state
}

if [[ "${1:-}" == "--self-test" ]]; then
    command -v amixer >/dev/null && command -v alsactl >/dev/null && command -v pactl >/dev/null
    pactl list sources short | grep -q "$source_name"
    jack_state >/dev/null
    exit
fi

if [[ "${1:-}" == "--once" ]]; then
    apply_port
    exit
fi

exec 9>"$lock"
flock -n 9 || exit 0
until pactl info >/dev/null 2>&1; do sleep 1; done
apply_port
while read -r _; do
    apply_port
done < <(alsactl monitor "hw:$card")
