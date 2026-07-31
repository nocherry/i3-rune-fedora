#!/usr/bin/env bash

# Terminate already running bar instances
polybar-msg cmd quit 2>/dev/null
killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# Auto-detect battery and adapter names for this machine
export POLYBAR_BATTERY=${POLYBAR_BATTERY:-$(ls /sys/class/power_supply/ 2>/dev/null | grep -E '^BAT' | head -n1)}
export POLYBAR_ADAPTER=${POLYBAR_ADAPTER:-$(ls /sys/class/power_supply/ 2>/dev/null | grep -E '^ADP|^AC' | head -n1)}

# Launch the bar
echo "---" | tee -a /tmp/polybar.log
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bars launched..."
