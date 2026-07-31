# i3wm — Fedora Adaptation

Fedora-ready port of [harilvfs/i3wmdotfiles](https://github.com/harilvfs/i3wmdotfiles) with **Nord dark** theme, **RU/EN-safe keycodes**, and Hyprland-like feel (gaps, shadows, blur, rounded corners).

## Features

- **i3 gaps** with Nord colors and pixel borders
- **RU/EN-safe keycodes** — Super+Q, Super+HJKL, etc. work on any layout
- **Polybar** with workspaces, window title, volume, brightness, CPU, RAM, battery, tray
- **Rofi** Nord launcher, powermenu, keybindings help
- **Picom** glx backend: shadows, fade, blur, rounded corners
- **Dunst** notifications in Nord style
- **Kitty** terminal with Catppuccin Mocha theme, padding, transparency
- **Fish / Starship / Zoxide / Eza** shell ecosystem from Arch dotfiles
- **Neovim, Tmux, Zellij, Fastfetch** configs included
- **GTK3 / Qt5 / Qt6 / Kvantum** theme integration
- **Wallpapers** cloned from `harilvfs/wallpapers`

## Install

```bash
cd /home/fedora/Documents/Code/X11/i3-fedora-ready
./install.sh
```

The installer:

1. Backs up existing `~/.config/*` to `~/.config/i3-fedora-backup-<timestamp>`.
2. Installs all packages via `dnf`.
3. Downloads and installs **JetBrainsMono Nerd Font**.
4. Clones wallpapers to `~/Pictures/wallpapers`.
5. Copies all configs to `~/.config/` and home dotfiles.
6. Optionally installs GTK/icon themes and SDDM.
7. Verifies `i3` config syntax.

## Keybindings

> All letter keys use **keycodes**, so they work on both Russian and English layouts. Mapped from your Hyprland (JaKooLit) config.

| Key | Action |
|-----|--------|
| `Super + D` | App launcher (Rofi) |
| `Super + Enter` | Terminal (Kitty) |
| `Super + E` | File manager (Thunar) |
| `Super + B` | Open browser |
| `Super + H` | Show keybindings help |
| `Super + Shift + ?` | Welcome menu |
| `Super + Q` | Close active window |
| `Super + Shift + Q` | Kill active process |
| `Ctrl + Alt + Delete` | Logout |
| `Ctrl + Alt + L` | Lock screen |
| `Ctrl + Alt + P` | Power menu |
| `Super + F` | Fullscreen |
| `Super + Shift + F` | Fullscreen global |
| `Super + Space` | Toggle floating |
| `Super + Shift + Space` | Enable floating |
| `Super + Arrows` | Focus |
| `Super + Shift + Arrows` | Move window |
| `Super + 1..0` | Switch workspace |
| `Super + Shift + 1..0` | Move window to workspace |
| `Super + Tab` / `Super + Shift + Tab` | Next / prev workspace |
| `Super + ,` / `Super + .` | Prev / next workspace |
| `Super + Shift + [` / `Super + Shift + ]` | Move to prev / next workspace |
| `Super + U` | Show scratchpad |
| `Super + Shift + U` | Move window to scratchpad |
| `Super + R` | Resize mode |
| `Super + Shift + G` | Gaps mode |
| `Super + Shift + C` | Reload i3 config |
| `Super + Shift + R` | Restart i3 |
| `Super + W` | Random wallpaper |
| `Print` / `Super + Print` / `Super + Shift + Print` | Screenshot (maim) |
| `F6` / `Super + F6` | Screenshot fallback for laptops without Print |
| `XF86 Volume/Brightness/Media` | Media keys |
| `Alt + Tab` | Window switcher (Rofi) |

## Will this work on my laptop?

I verified the i3 config syntax and polybar config parsing on this machine, but I **cannot guarantee** everything will work on your exact hardware without testing. Things that may need manual tuning:

- **Intel UHD 620 + NVIDIA MX130**: If picom glitches or has high CPU usage, switch to `xrender` backend in `~/.config/picom/picom.conf` (`backend = "xrender";`). Make sure `xorg-x11-drv-nvidia` is installed if you need the NVIDIA GPU.
- **Battery names**: Polybar auto-detects `BAT0`/`BAT1` and `ADP1`/`ACAD` in `launch.sh`. If battery doesn't show, run `ls /sys/class/power_supply/` and set `POLYBAR_BATTERY`/`POLYBAR_ADAPTER` in `~/.config/polybar/launch.sh`.
- **Brightness keys**: If `XF86MonBrightnessUp/Down` don't work, check `brightnessctl` output and your Fn-key mappings.
- **WiFi password after reboot**: NetworkManager + `nm-applet` + `gnome-keyring-daemon` should remember passwords. If you are asked every time, open `nm-connection-editor`, edit your WiFi connection, and make sure it is set to **"Connect automatically"** and **"Available to all users"** (the second requires saving the password in the system keyring).

## Differences from upstream Arch dotfiles

- `odiaeresis` German keysym replaced with keycodes for RU/EN compatibility.
- `dex` / `xss-lock -- slock` autostart removed or made conditional.
- Polybar battery/adapter names auto-detected at launch (uses `BAT0`/`AC0` on this laptop).
- Picom uses standard `glx` backend without fork-specific animations (marked in config).
- `i3lock` falls back to solid Nord background if `bg.png` wallpaper is missing.
- Package names corrected for Fedora (`Thunar`, `network-manager-applet`, `blueman`, etc.).
- `starship` installed via official curl script (not in default Fedora repos).
- `polkit-gnome` replaced by `lxqt-policykit-agent` (already installed on this system).

## Troubleshooting

```bash
# Check i3 config for errors
i3 -C -c ~/.config/i3/config

# Test polybar manually
~/.config/polybar/launch.sh

# Test picom manually
picom --config ~/.config/picom/picom.conf -b

# Restore backup
cp -r ~/.config/i3-fedora-backup-<timestamp>/* ~/.config/
```

## Credits

- Original dotfiles: [harilvfs/i3wmdotfiles](https://github.com/harilvfs/i3wmdotfiles)
- Nord theme: [nordtheme.com](https://www.nordtheme.com/)
- Wallpapers: [harilvfs/wallpapers](https://github.com/harilvfs/wallpapers)
