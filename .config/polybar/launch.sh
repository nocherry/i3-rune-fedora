#!/usr/bin/env bash
# ponytail: launch polybar with auto-restart on crash and single-instance guard

# Kill previous launcher loops (excluding ourselves — pkill -f would match self)
for pid in $(pgrep -f 'config/polybar/launch.sh' 2>/dev/null); do
    [ "$pid" != "$$" ] && kill "$pid" 2>/dev/null
done
polybar-msg cmd quit 2>/dev/null || true
killall -q polybar 2>/dev/null || true
sleep 0.3

# Auto-detect battery and adapter names for this machine
export POLYBAR_BATTERY=${POLYBAR_BATTERY:-$(ls /sys/class/power_supply/ 2>/dev/null | grep -E '^BAT' | head -n1)}
export POLYBAR_ADAPTER=${POLYBAR_ADAPTER:-$(ls /sys/class/power_supply/ 2>/dev/null | grep -E '^ADP|^AC' | head -n1)}

# Launch loop: if polybar crashes, restart it automatically
echo "---" | tee -a /tmp/polybar.log
while true; do
    polybar main 2>&1 | tee -a /tmp/polybar.log
    sleep 1
done
