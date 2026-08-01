#!/usr/bin/env bash
# Configure Handy for toggle-to-record and clipboard-only output.
set -e

default_settings="$HOME/.local/share/com.pais.handy/settings_store.json"
settings_file="${1:-$default_settings}"
was_running=false

if [[ ! -f "$settings_file" ]]; then
    printf 'Handy settings not found: %s\n' "$settings_file" >&2
    exit 1
fi

if [[ "$settings_file" == "$default_settings" ]] && pgrep -x handy >/dev/null 2>&1; then
    was_running=true
    pkill -x handy
    for _ in {1..50}; do
        pgrep -x handy >/dev/null 2>&1 || break
        sleep 0.1
    done
    if pgrep -x handy >/dev/null 2>&1; then
        printf '%s\n' "Handy did not stop; settings were not changed" >&2
        exit 1
    fi
fi

[[ -e "$settings_file.before-i3-fedora" ]] || cp -a "$settings_file" "$settings_file.before-i3-fedora"

python3 - "$settings_file" <<'PY'
import json
import os
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as file:
    data = json.load(file)

settings = data["settings"]
settings["bindings"]["transcribe"]["current_binding"] = "ctrl+space"
settings["push_to_talk"] = False
settings["paste_method"] = "none"
settings["clipboard_handling"] = "copy_to_clipboard"

temporary = f"{path}.tmp"
with open(temporary, "w", encoding="utf-8") as file:
    json.dump(data, file, ensure_ascii=False, indent=2)
    file.write("\n")
os.chmod(temporary, os.stat(path).st_mode)
os.replace(temporary, path)
PY

if [[ "$was_running" == true ]]; then
    nohup handy --start-hidden >/dev/null 2>&1 &
fi

notify-send "Handy" "Ctrl+Space toggle and clipboard output configured" 2>/dev/null || true
