#!/usr/bin/env bash

THEME="$HOME/.config/rofi/themes/keybindings.rasi"

keybinds=$(cat <<'EOF'
  Super + D                →   App launcher (Rofi)
  Super + B                →   Open browser
  Super + Enter            →   Terminal (Kitty)
  Super + E                →   File manager (Thunar)
  Super + H                →   Show this keybindings list
  Super + ?                →   Welcome menu
  Super + Q                →   Close active window
  Super + Shift + Q        →   Kill active process
  Ctrl + Alt + Delete      →   Logout
  Ctrl + Alt + L           →   Lock screen
  Ctrl + Alt + P           →   Power menu
  Super + F                →   Fullscreen
  Super + Shift + F        →   Fullscreen global
  Super + Space            →   Toggle floating
  Super + Shift + Space    →   Float all-ish (enable floating)
  Super + Left/Right/Up/Down       →   Focus
  Super + Shift + Left/Right/Up/Down →   Move window
  Super + 1 … 9 / 0        →   Switch to workspace 1–10
  Super + Shift + 1 … 9/0  →   Move window to workspace 1–10
  Super + Tab              →   Next workspace
  Super + Shift + Tab      →   Previous workspace
  Super + Comma            →   Previous workspace
  Super + Period           →   Next workspace
  Super + Shift + [        →   Move to previous workspace
  Super + Shift + ]        →   Move to next workspace
  Super + U                →   Show scratchpad (special workspace)
  Super + Shift + U        →   Move window to scratchpad
  Super + R                →   Resize mode
  Super + Shift + G        →   Gaps mode
  Super + Shift + C        →   Reload i3 config
  Super + Shift + R        →   Restart i3
  Super + W                →   Random wallpaper
  Print                    →   Screenshot fullscreen (F6 as fallback)
  Super + Shift + S        →   Screenshot area (Hyprland style)
  Super + Print            →   Screenshot area
  Super + Shift + Print    →   Screenshot area
  XF86 Volume Up/Down      →   Volume ±5%
  XF86 Mute                →   Toggle mute
  XF86 Mic Mute            →   Toggle mic mute
  XF86 Brightness Up/Down  →   Brightness ±5%
  XF86 Audio Play/Next/Prev →   Media controls
  Alt + Tab                →   Cycle windows (rofi)
EOF
)

echo "$keybinds" | rofi \
    -dmenu \
    -i \
    -p "  Keybinds" \
    -mesg "  Type to filter" \
    -theme "$THEME" \
    -no-custom \
    -format i

exit 0
