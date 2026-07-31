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
    local reply
    echo -en "${CYAN}  ${prompt} ${YELLOW}[Y/n]${NC} "
    read -r reply
    reply="${reply:-Y}"
    [[ "${reply,,}" == "y" || "${reply,,}" == "yes" ]]
}

header "i3wm — Fedora Adaptation Installer"
echo "  Theme: Nord dark | RU/EN safe keycodes"
echo ""

# Backup existing configs
header "Backup"
mkdir -p "$BACKUP_DIR"
for cfg in i3 polybar rofi picom dunst kitty fish nvim tmux zellij fastfetch \
           gtk-3.0 Kvantum qt5ct qt6ct xsettingsd starship; do
    if [ -d "$HOME/.config/$cfg" ]; then
        cp -r "$HOME/.config/$cfg" "$BACKUP_DIR/"
        echo "  Backed up $cfg"
    fi
done
for f in .bashrc .xinitrc; do
    if [ -f "$HOME/$f" ]; then
        cp "$HOME/$f" "$BACKUP_DIR/"
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
    network-manager-applet blueman pavucontrol brightnessctl maim flameshot playerctl \
    xorg-x11-server-Xorg xorg-x11-xinit xrandr xset xsetroot \
    gnome-keyring gnome-settings-daemon lxqt-policykit \
    neovim btop fastfetch fish zoxide eza yad xclip xss-lock i3lock \
    nwg-look qt5ct qt6ct kvantum \
    jetbrains-mono-fonts-all google-noto-emoji-fonts google-noto-color-emoji-fonts \
    fontawesome-fonts papirus-icon-theme \
    unzip curl git || true

# Install JetBrainsMono Nerd Font if missing
if ! fc-list | grep -qi "JetBrainsMono.*Nerd"; then
    header "Installing JetBrainsMono Nerd Font"
    mkdir -p "$FONT_DIR"
    tmp_dir=$(mktemp -d)
    latest_url=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep -o "https://github.com/ryanoasis/nerd-fonts/releases/download/.*/JetBrainsMono.zip" | head -1)
    if [ -n "$latest_url" ]; then
        curl -L -o "$tmp_dir/JetBrainsMono.zip" "$latest_url"
        unzip -q "$tmp_dir/JetBrainsMono.zip" -d "$FONT_DIR"
        rm -rf "$tmp_dir"
        fc-cache -fv "$FONT_DIR"
        msg "JetBrainsMono Nerd Font installed."
    else
        warn "Could not download JetBrainsMono Nerd Font automatically."
    fi
else
    msg "JetBrainsMono Nerd Font already installed."
fi

# Install eza if missing (some Fedora versions ship it, some don't)
if ! command -v eza &>/dev/null; then
    header "Installing eza"
    tmp_dir=$(mktemp -d)
    latest_url=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest | grep -o "https://github.com/eza-community/eza/releases/download/.*/eza_x86_64-unknown-linux-gnu.zip" | head -1)
    latest_url=${latest_url:-"https://github.com/eza-community/eza/releases/download/v0.21.1/eza_x86_64-unknown-linux-gnu.zip"}
    curl -L -o "$tmp_dir/eza.zip" "$latest_url"
    unzip -q "$tmp_dir/eza.zip" -d "$tmp_dir"
    sudo cp "$tmp_dir/eza" /usr/local/bin/
    sudo chmod +x /usr/local/bin/eza
    rm -rf "$tmp_dir"
    msg "eza installed."
fi

# Install starship if missing (not in default Fedora repos on this machine)
if ! command -v starship &>/dev/null; then
    header "Installing Starship"
    curl -sS https://starship.rs/install.sh | sh -s -- -y || warn "Starship install failed (non-fatal)."
fi

# Install greenclip if missing (clipboard history manager, static binary)
if ! command -v greenclip &>/dev/null; then
    header "Installing greenclip"
    mkdir -p "$HOME/.local/bin"
    curl -L -o "$HOME/.local/bin/greenclip" https://github.com/erebe/greenclip/releases/download/v4.2/greenclip
    chmod +x "$HOME/.local/bin/greenclip"
    msg "greenclip installed to ~/.local/bin/greenclip"
fi

# Install libinput-gestures if missing (not in Fedora repos — install from GitHub)
if [ ! -x "$HOME/.local/bin/libinput-gestures" ]; then
    header "Installing libinput-gestures (from GitHub)"
    mkdir -p "$HOME/.local/bin"
    curl -sL -o "$HOME/.local/bin/libinput-gestures" https://raw.githubusercontent.com/bulletmark/libinput-gestures/master/libinput-gestures
    chmod +x "$HOME/.local/bin/libinput-gestures"
    if [ -s "$HOME/.local/bin/libinput-gestures" ]; then
        msg "libinput-gestures installed to ~/.local/bin"
    else
        warn "libinput-gestures download failed (non-fatal). Touchpad gestures will not work."
    fi
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
cp -r "$REPO_DIR/.config/"* "$HOME/.config/"

# Copy home dotfiles
[ -f "$REPO_DIR/.bashrc" ] && cp "$REPO_DIR/.bashrc" "$HOME/.bashrc"
[ -f "$REPO_DIR/.xinitrc" ] && cp "$REPO_DIR/.xinitrc" "$HOME/.xinitrc"

# Set execute permissions
chmod +x "$HOME/.config/i3/scripts/"*.sh
chmod +x "$HOME/.config/i3/launchers/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/polybar/launch.sh"
chmod +x "$HOME/.config/polybar/brightness.sh"
chmod +x "$HOME/.xinitrc" 2>/dev/null || true

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
    rm -rf "$HOME/themes" "$HOME/icons"
    git clone https://github.com/harilvfs/themes.git "$HOME/themes" || warn "themes clone failed"
    git clone https://github.com/harilvfs/icons.git "$HOME/icons" || warn "icons clone failed"

    mkdir -p "$HOME/.themes" "$HOME/.icons"
    for item in "$HOME/themes"/*/; do
        [ -d "$item" ] || continue
        name=$(basename "$item")
        if [ -d "$HOME/.themes/$name" ]; then
            warn "  $name already in ~/.themes, skipping"
        else
            mv "$item" "$HOME/.themes/"
        fi
    done
    for item in "$HOME/icons"/*/; do
        [ -d "$item" ] || continue
        name=$(basename "$item")
        if [ -d "$HOME/.icons/$name" ]; then
            warn "  $name already in ~/.icons, skipping"
        else
            mv "$item" "$HOME/.icons/"
        fi
    done
    rm -rf "$HOME/themes" "$HOME/icons"
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
if ask "Replace LightDM with SDDM + astronaut theme? (Default: keep LightDM)"; then
    header "SDDM"
    sudo dnf install -y --skip-unavailable sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia || warn "Could not install SDDM"
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
        printf "[General]\nDisplayServer=x11\n" | sudo tee /etc/sddm.conf.d/x11.conf >/dev/null
        printf "[Theme]\nCurrent=sddm-astronaut-theme\n" | sudo tee /etc/sddm.conf >/dev/null
        printf "[General]\nInputMethod=qtvirtualkeyboard\n" | sudo tee /etc/sddm.conf.d/virtualkbd.conf >/dev/null
        msg "SDDM theme configured for X11."
    else
        warn "sddm-astronaut-theme not found in repo."
    fi
    sudo systemctl disable gdm lightdm greetd 2>/dev/null || true
    sudo systemctl enable sddm
    msg "SDDM enabled."
fi

# Verification
header "Verification"
if i3 -C -c "$HOME/.config/i3/config"; then
    msg "i3 config syntax OK"
else
    warn "i3 config has syntax errors"
fi

missing_pkgs=()
for pkg in i3 polybar rofi picom dunst kitty thunar feh nitrogen nm-applet blueman-applet pavucontrol brightnessctl maim playerctl i3lock xclip greenclip; do
    command -v "$pkg" &>/dev/null || missing_pkgs+=("$pkg")
done

if [ ${#missing_pkgs[@]} -eq 0 ]; then
    msg "All core packages found."
else
    warn "Missing packages: ${missing_pkgs[*]}"
    warn "Install with: sudo dnf install <pkg>"
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
echo ""
echo "If anything breaks:"
echo "  cp -r $BACKUP_DIR/* ~/.config/"
echo ""
