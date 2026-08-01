#!/usr/bin/env bash
# ponytail: run a GUI app in background, keep terminal clean, log output
name="${1:-app}"
shift
if [ "$#" -eq 0 ] || ! command -v "$1" >/dev/null 2>&1; then
    notify-send -u critical "Launcher" "Command not found for $name"
    exit 1
fi
mkdir -p "$HOME/.local/share/i3/launchers"
log="$HOME/.local/share/i3/launchers/${name}.log"

# Suppress common GTK warnings and keep them in log instead of terminal
GTK_MODULES="" nohup "$@" >"$log" 2>&1 &
pid=$!
sleep 0.2
if kill -0 "$pid" 2>/dev/null; then
    notify-send "Launcher" "Started $name"
else
    notify-send -u critical "Launcher" "$name failed; see $log"
    exit 1
fi
