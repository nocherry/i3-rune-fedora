#!/usr/bin/env bash
# ponytail: run a command in background, redirect output to log, notify on start
name="${1:-app}"
shift
mkdir -p "$HOME/.local/share/i3/launchers"
log="$HOME/.local/share/i3/launchers/${name}.log"
nohup "$@" >"$log" 2>&1 &
notify-send "Launcher" "Started $name"
