#!/usr/bin/env bash
# Visible per-workspace layout chooser; Super+L and Super+Д share keycode 46.

horizontal="Горизонтально: все окна слева / справа"
vertical="Вертикально: все окна сверху / снизу"
tabbed="Вкладки"
stacked="Стопка"
default="Обычный тайлинг"
toggle="Сменить направление split"

command_for_choice() {
    case "$1" in
        "$horizontal") printf '%s\n' "split h" ;;
        "$vertical")   printf '%s\n' "split v" ;;
        "$tabbed")     printf '%s\n' "layout tabbed" ;;
        "$stacked")    printf '%s\n' "layout stacking" ;;
        "$default")    printf '%s\n' "layout default" ;;
        "$toggle")     printf '%s\n' "layout toggle split" ;;
    esac
}

workspace_target() {
    i3-msg -t get_tree | python3 -c '
import json, sys

root = json.load(sys.stdin)

def has_focus(node):
    return node.get("focused") or any(has_focus(child) for child in node.get("nodes", []) + node.get("floating_nodes", []))

def find_workspace(node):
    if node.get("type") == "workspace" and has_focus(node):
        return node
    for child in node.get("nodes", []):
        found = find_workspace(child)
        if found:
            return found

target = find_workspace(root)
if not target:
    raise SystemExit(1)

# Skip wrappers with one child so the command reaches the first level that
# actually arranges multiple tiled windows.
while len(target.get("nodes", [])) == 1 and target["nodes"][0].get("nodes"):
    target = target["nodes"][0]
print(target["id"])
'
}

if [[ "${1:-}" == "--self-test" ]]; then
    [[ "$(command_for_choice "$horizontal")" == "split h" && "$(command_for_choice "$tabbed")" == "layout tabbed" ]]
    exit
fi

choice=$(printf '%s\n' "$horizontal" "$vertical" "$tabbed" "$stacked" "$default" "$toggle" | \
    rofi -dmenu -i -kb-cancel "Escape,Super+q" -p "Режим текущего рабочего стола")
command=$(command_for_choice "$choice")
[[ -n "$command" ]] || exit 0
target=$(workspace_target) || {
    notify-send "Layout" "Не удалось найти текущий рабочий стол"
    exit 1
}
i3-msg "[con_id=$target] $command" >/dev/null
