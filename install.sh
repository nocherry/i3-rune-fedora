#!/bin/bash
set -e

RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
CYAN='\e[0;36m'
BOLD='\e[1m'
NC='\e[0m'

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/i3-fedora-backup-$(date +%Y%m%d-%H%M%S)"
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
FONT_DIR="$HOME/.local/share/fonts"

msg()    { echo -e "${GREEN}  ${*}${NC}"; }
warn()   { echo -e "${YELLOW}  ${*}${NC}"; }
info()   { echo -e "${CYAN}  ${*}${NC}"; }
header() { echo -e "\n${BOLD}${CYAN}══ ${*} ══${NC}\n"; }

ask() {
    local prompt="$1"
    local default="${2:-y}"
    local hint="[Y/n]"
    local reply
    [ "$default" = "n" ] && hint="[y/N]"
    echo -en "${CYAN}  ${prompt} ${YELLOW}${hint}${NC} "
    read -r reply
    reply="${reply:-$default}"
    [[ "${reply,,}" == "y" || "${reply,,}" == "yes" ]]
}

header "i3wm — Fedora Adaptation Installer"
echo "  Theme: Nord dark | RU/EN safe keycodes"
echo ""

if [ "$(uname -m)" != "x86_64" ]; then
    warn "Greenclip v4.2 is pinned as an x86_64 binary; this installer does not support $(uname -m)."
    exit 1
fi

# Backup existing configs
header "Backup"
mkdir -p "$BACKUP_DIR/.config" "$BACKUP_DIR/home"
for cfg in i3 polybar rofi picom dunst kitty fish nvim tmux zellij fastfetch \
           gtk-3.0 Kvantum qt5ct qt6ct xsettingsd xdg-desktop-portal wireplumber starship sddm; do
    if [ -d "$HOME/.config/$cfg" ]; then
        cp -a "$HOME/.config/$cfg" "$BACKUP_DIR/.config/"
        echo "  Backed up $cfg"
    fi
done
for cfg in greenclip.toml libinput-gestures.conf; do
    if [ -e "$HOME/.config/$cfg" ]; then
        cp -a "$HOME/.config/$cfg" "$BACKUP_DIR/.config/"
        echo "  Backed up $cfg"
    fi
done
for f in .bashrc .xinitrc .xprofile; do
    if [ -f "$HOME/$f" ]; then
        cp -a "$HOME/$f" "$BACKUP_DIR/home/"
        echo "  Backed up $f"
    fi
done
echo "  Backup saved to: $BACKUP_DIR"

# Install packages
# Note: --skip-unavailable is used because some packages (pasystray, xorg-x11-server-utils,
# fontawesome-fonts-web) are not present in newer Fedora repos but are non-critical.
header "Installing packages"
sudo dnf install -y --skip-unavailable \
    i3 polybar rofi picom dunst kitty thunar feh nitrogen \
    network-manager-applet blueman pavucontrol pulseaudio-utils alsa-utils brightnessctl redshift maim flameshot playerctl \
    xorg-x11-server-Xorg xorg-x11-xinit xrandr xset xsetroot \
    gnome-keyring gnome-settings-daemon lxqt-policykit \
    xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde kf6-kwallet pam-kwallet \
    neovim btop fastfetch fish zoxide eza starship yad xclip xss-lock xsecurelock i3lock ImageMagick trash-cli libinput-utils \
    nwg-look qt5ct qt6ct kvantum \
    jetbrains-mono-fonts-all google-noto-emoji-fonts google-noto-color-emoji-fonts \
    fontawesome-fonts papirus-icon-theme \
    python3 python3-xlib unzip curl git

# Make lid close suspend in every laptop state. Takes effect after reboot/login.
header "Laptop lid suspend"
sudo install -Dm644 \
    "$REPO_DIR/etc/systemd/logind.conf.d/90-i3-fedora-lid.conf" \
    /etc/systemd/logind.conf.d/90-i3-fedora-lid.conf
msg "Lid close is configured to suspend; reboot after installation."

# Install JetBrainsMono Nerd Font if missing
if ! fc-list | grep -qi "JetBrainsMono.*Nerd"; then
    header "Installing JetBrainsMono Nerd Font"
    mkdir -p "$FONT_DIR"
    tmp_dir=$(mktemp -d)
    font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
    font_sha256="76f05ff3ace48a464a6ca57977998784ff7bdbb65a6d915d7e401cd3927c493c"
    if curl --fail --location --output "$tmp_dir/JetBrainsMono.zip" "$font_url" && \
       printf '%s  %s\n' "$font_sha256" "$tmp_dir/JetBrainsMono.zip" | sha256sum --check --status; then
        unzip -q "$tmp_dir/JetBrainsMono.zip" -d "$FONT_DIR"
        fc-cache -fv "$FONT_DIR"
        msg "JetBrainsMono Nerd Font installed."
    else
        warn "Could not download or verify JetBrainsMono Nerd Font."
    fi
    rm -rf "$tmp_dir"
else
    msg "JetBrainsMono Nerd Font already installed."
fi

# Clone wallpapers
header "Wallpapers"
if [ -d "$WALLPAPER_DIR" ]; then
    warn "Wallpapers directory already exists."
else
    mkdir -p "$HOME/Pictures"
    git clone https://github.com/harilvfs/wallpapers.git "$WALLPAPER_DIR" || warn "Failed to clone wallpapers (non-fatal)."
fi

# Copy configs
header "Installing configs"
mkdir -p "$HOME/.config"
for source in "$REPO_DIR/.config/"*; do
    target="$HOME/.config/${source##*/}"
    if [ -L "$target" ]; then
        warn "Refusing to overwrite symlink: $target"
        exit 1
    fi
done
cp -a "$REPO_DIR/.config/." "$HOME/.config/"
rm -f "$HOME/.config/wireplumber/main.lua.d/51-headset-mic.lua"
sed -i "s|@HOME@|$HOME|g" "$HOME/.config/greenclip.toml"
mkdir -p -m 700 "$HOME/.cache/greenclip-images"

# Telegram's Qt GL window can stop repainting after media playback under Picom GLX.
if command -v flatpak >/dev/null 2>&1 && flatpak info org.telegram.desktop >/dev/null 2>&1; then
    flatpak override --user --env=QT_XCB_GL_INTEGRATION=none org.telegram.desktop
fi

# Download fixed helper versions and reject changed upstream files.
mkdir -p "$HOME/.local/bin"
tmp_dir=$(mktemp -d)
greenclip_url="https://github.com/erebe/greenclip/releases/download/v4.2/greenclip"
greenclip_sha256="80b189fc9ce2e0a56e33be642875f5c3fb53647465f8024a541621307a6a290f"
gestures_url="https://raw.githubusercontent.com/bulletmark/libinput-gestures/2e4cc4c296fda34cf5a6a00b37a31f33d60dc038/libinput-gestures"
gestures_sha256="29a69b8823a7be176e4a980a4ec2366d92ad0845a7f80e61b846833374ae92ef"
curl --fail --location --output "$tmp_dir/greenclip" "$greenclip_url"
printf '%s  %s\n' "$greenclip_sha256" "$tmp_dir/greenclip" | sha256sum --check --status
curl --fail --location --output "$tmp_dir/libinput-gestures" "$gestures_url"
printf '%s  %s\n' "$gestures_sha256" "$tmp_dir/libinput-gestures" | sha256sum --check --status
install -m 755 "$tmp_dir/greenclip" "$HOME/.local/bin/greenclip"
install -m 755 "$tmp_dir/libinput-gestures" "$HOME/.local/bin/libinput-gestures"
rm -rf "$tmp_dir"

# Copy home dotfiles
if [ -L "$HOME/.bashrc" ] || [ -L "$HOME/.xinitrc" ] || [ -L "$HOME/.xprofile" ]; then
    warn "Refusing to overwrite symlinked home dotfiles."
    exit 1
fi
[ -f "$REPO_DIR/.bashrc" ] && cp "$REPO_DIR/.bashrc" "$HOME/.bashrc"
[ -f "$REPO_DIR/.xinitrc" ] && cp "$REPO_DIR/.xinitrc" "$HOME/.xinitrc"
[ -f "$REPO_DIR/.xprofile" ] && cp "$REPO_DIR/.xprofile" "$HOME/.xprofile"

# Set execute permissions
chmod +x "$HOME/.config/i3/scripts/"*.sh
chmod +x "$HOME/.config/i3/scripts/"*.py
chmod +x "$HOME/.config/i3/launchers/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/polybar/launch.sh"
chmod +x "$HOME/.config/polybar/brightness.sh"
chmod +x "$HOME/.xinitrc" 2>/dev/null || true

# Handy stores settings only after its first launch; configure it when available.
if command -v handy >/dev/null 2>&1; then
    if [ -f "$HOME/.local/share/com.pais.handy/settings_store.json" ]; then
        "$HOME/.config/i3/scripts/configure-handy.sh"
    else
        warn "Handy is installed but has no settings yet. Launch it once, then run configure-handy.sh."
    fi
fi

# Initialize theme state to dark if not present
[ -f "$HOME/.config/i3/theme-state" ] || echo "dark" > "$HOME/.config/i3/theme-state"

# Copy local wallpapers to fallback location and wallpaper dir
if [ -f "$REPO_DIR/wallpaper.png" ]; then
    mkdir -p "$HOME/.config/i3"
    cp "$REPO_DIR/wallpaper.png" "$HOME/.config/i3/wallpaper.png"
    cp "$REPO_DIR/wallpaper-alt.png" "$HOME/.config/i3/wallpaper-alt.png" 2>/dev/null || true
    mkdir -p "$WALLPAPER_DIR"
    cp "$REPO_DIR/wallpaper.png" "$WALLPAPER_DIR/bg.png"
    cp "$REPO_DIR/wallpaper-alt.png" "$WALLPAPER_DIR/" 2>/dev/null || true
    echo "  Wallpaper installed"
fi

# Install themes/icons (optional)
if ask "Download GTK/Icon themes from harilvfs/themes and harilvfs/icons?"; then
    header "Themes & Icons"
    tmp_dir=$(mktemp -d)
    git clone https://github.com/harilvfs/themes.git "$tmp_dir/themes" || warn "themes clone failed"
    git clone https://github.com/harilvfs/icons.git "$tmp_dir/icons" || warn "icons clone failed"

    mkdir -p "$HOME/.themes" "$HOME/.icons"
    for item in "$tmp_dir/themes"/*/; do
        [ -d "$item" ] || continue
        name=$(basename "$item")
        if [ -d "$HOME/.themes/$name" ]; then
            warn "  $name already in ~/.themes, skipping"
        else
            mv "$item" "$HOME/.themes/"
        fi
    done
    for item in "$tmp_dir/icons"/*/; do
        [ -d "$item" ] || continue
        name=$(basename "$item")
        if [ -d "$HOME/.icons/$name" ]; then
            warn "  $name already in ~/.icons, skipping"
        else
            mv "$item" "$HOME/.icons/"
        fi
    done
    rm -rf "$tmp_dir"
    msg "Themes and icons installed to ~/.themes and ~/.icons"
fi

# LightDM / i3 session entry
header "Display Manager"
if [ -d /usr/share/xsessions/ ]; then
    if [ ! -f /usr/share/xsessions/i3.desktop ]; then
        warn "i3.desktop session not found in /usr/share/xsessions/"
        info "LightDM uses .desktop files in /usr/share/xsessions/ to show i3 entry."
        info "If i3 is missing after login, run: sudo dnf install i3  (usually already installed)"
    else
        msg "i3.desktop session entry already exists. LightDM should show i3."
    fi
else
    warn "/usr/share/xsessions/ not found. Display manager may not be installed."
fi

# Optional SDDM (user reported SDDM on Wayland broke X11 sessions, so this is opt-in)
if ask "Replace LightDM with SDDM + astronaut theme? (Default: keep LightDM)" n; then
    header "SDDM"
    sudo dnf install -y --skip-unavailable sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia
    if [ -d "$REPO_DIR/.config/sddm/themes/sddm-astronaut-theme" ]; then
        sudo mkdir -p /usr/share/sddm/themes /etc/sddm.conf.d
        sudo cp -r "$REPO_DIR/.config/sddm/themes/sddm-astronaut-theme" /usr/share/sddm/themes/
        # Install SDDM theme fonts system-wide so the greeter can render them
        if [ -d /usr/share/sddm/themes/sddm-astronaut-theme/Fonts ]; then
            sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
            sudo fc-cache -fv /usr/share/fonts/
            msg "SDDM theme fonts installed."
        fi
        # Force SDDM to use X11 backend (avoid Wayland issues on X11-only setups)
        printf "[General]\nDisplayServer=x11\n" | sudo tee /etc/sddm.conf.d/90-i3-fedora-x11.conf >/dev/null
        printf "[Theme]\nCurrent=sddm-astronaut-theme\n" | sudo tee /etc/sddm.conf.d/90-i3-fedora-theme.conf >/dev/null
        printf "[General]\nInputMethod=qtvirtualkeyboard\n" | sudo tee /etc/sddm.conf.d/90-i3-fedora-virtualkbd.conf >/dev/null
        msg "SDDM theme configured for X11."
    else
        warn "sddm-astronaut-theme not found in repo."
    fi
    sudo systemctl enable --force sddm.service
    sudo systemctl disable gdm lightdm greetd 2>/dev/null || true
    msg "SDDM enabled."
fi

# Verification
header "Verification"
if i3 -C -c "$HOME/.config/i3/config"; then
    msg "i3 config syntax OK"
else
    warn "i3 config has syntax errors"
    exit 1
fi

missing_pkgs=()
for pkg in i3 polybar rofi picom dunst kitty thunar feh nitrogen nm-connection-editor blueman-applet pavucontrol brightnessctl redshift maim flameshot playerctl xsecurelock magick xclip; do
    command -v "$pkg" &>/dev/null || missing_pkgs+=("$pkg")
done
[ -x "$HOME/.local/bin/greenclip" ] || missing_pkgs+=("greenclip")
[ -x "$HOME/.local/bin/libinput-gestures" ] || missing_pkgs+=("libinput-gestures")

if [ ${#missing_pkgs[@]} -eq 0 ]; then
    msg "All core packages found."
else
    warn "Missing packages: ${missing_pkgs[*]}"
    warn "Install with: sudo dnf install <pkg>"
    exit 1
fi

# Done
header "Done"
echo ""
echo "Next steps:"
echo "  1. Log out"
echo "  2. Select 'i3' session (or run startx from TTY)"
echo "  3. Super + Enter      = Terminal (Kitty)"
echo "  4. Super + D          = App menu (Rofi)"
echo "  5. Super + Shift + D  = Toggle dark/light Rofi theme"
echo "  6. Super + \`         = Control center (quick settings)"
echo "  7. Super + Shift + \` = Clipboard history"
echo "  8. Super + W          = Select wallpaper"
echo "  9. Super + Q          = Close window (works on RU too!)"
echo "  10. Alt + Shift       = RU/EN keyboard"
echo "  11. Touchpad gestures require access to input devices; see README.md"
echo ""
echo "If anything breaks:"
echo "  cp -a '$BACKUP_DIR/.config/.' '$HOME/.config/'"
echo "  cp -a '$BACKUP_DIR/home/.' '$HOME/'"
echo ""
