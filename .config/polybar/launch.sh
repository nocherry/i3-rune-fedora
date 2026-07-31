#!/usr/bin/env bash
# ponytail: launch polybar with auto-restart on crash and single-instance guard

PIDFILE="/tmp/polybar-launch.pid"

# Kill previous launcher loop (and its polybar children) using saved PID
if [ -f "$PIDFILE" ]; then
    oldpid=$(cat "$PIDFILE" 2>/dev/null)
    if [ -n "$oldpid" ] && kill -0 "$oldpid" 2>/dev/null; then
        kill -TERM -"$oldpid" 2>/dev/null || true
        sleep 0.3
    fi
fi
echo $$ > "$PIDFILE"

# Terminate any leftover polybar instances
polybar-msg cmd quit 2>/dev/null || true
killall -q polybar || true
while pgrep -x polybar >/dev/null; do sleep 0.1; done

# Auto-detect battery and adapter names for this machine
export POLYBAR_BATTERY=${POLYBAR_BATTERY:-$(ls /sys/class/power_supply/ 2>/dev/null | grep -E '^BAT' | head -n1)}
export POLYBAR_ADAPTER=${POLYBAR_ADAPTER:-$(ls /sys/class/power_supply/ 2>/dev/null | grep -E '^ADP|^AC' | head -n1)}

# Launch loop: if polybar crashes, restart it automatically
echo "---" | tee -a /tmp/polybar.log
while true; do
    polybar main 2>&1 | tee -a /tmp/polybar.log
    sleep 1
done
