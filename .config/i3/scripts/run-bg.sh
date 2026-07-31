#!/usr/bin/env bash
# ponytail: run a GUI app in background, keep terminal clean, log output
name="${1:-app}"
shift
mkdir -p "$HOME/.local/share/i3/launchers"
log="$HOME/.local/share/i3/launchers/${name}.log"

# Suppress common GTK warnings and keep them in log instead of terminal
GTK_MODULES="" nohup "$@" >"$log" 2>&1 &
notify-send "Launcher" "Started $name"
