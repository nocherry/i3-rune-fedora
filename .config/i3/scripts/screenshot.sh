#!/usr/bin/env bash
# ponytail: simple maim wrapper with modes; RU/EN-safe because called from keycodes
mode="${1:-area}"
mkdir -p "$HOME/Pictures/Screenshots"
out="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"

case "$mode" in
    full)   maim "$out" ;;
    area)   maim -s "$out" ;;
    delay5) sleep 5; maim "$out" ;;
    delay10) sleep 10; maim "$out" ;;
    *)      echo "Usage: $0 {full|area|delay5|delay10}" >&2; exit 1 ;;
esac
