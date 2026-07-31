# План адаптации i3 dotfiles с Arch → Fedora

## Цель

Полностью перенести `i3wmdotfiles-main` (Arch) на Fedora, чтобы i3 запускался, выглядел в стиле Nord и ощущался как Hyprland (гэпы, тени, прозрачность, панель, уведомления, рабочий процесс).

## Решения

- Визуальная тема: **Nord dark** из Arch-репо.
- Раскладка: **keycodes вместо bindsym** для буквенных клавиш — чтобы работало на RU/EN.
- Терминал: **Kitty** (как в Arch), Alacritty убираем.
- Менеджер входа: SDDM с astronaut-theme (опционально, включаемым флагом).
- Обои: клонируем `harilvfs/wallpapers` в `~/Pictures/wallpapers`.
- Шрифты: ставим JetBrainsMono Nerd Font, Noto Emoji, Font Awesome (для иконок polybar/rofi).

## Этапы

### 1. Пакеты

Установить через `dnf`:

```text
i3 polybar rofi picom dunst kitty flameshot thunar feh \
network-manager-applet blueman pasystray brightnessctl \
xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-server-utils \
gnome-keyring gnome-settings-daemon polkit-gnome \
neovim btop fastfetch starship fish zoxide eza yad xclip xss-lock slock \
nwg-look qt5ct qt6ct kvantum \
jetbrains-mono-fonts-all google-noto-emoji-fonts google-noto-color-emoji-fonts
```

Плюс вручную (если нет в репо):
- `ttf-meslo-nerd` → заменяем на JetBrainsMono Nerd Font из релизов.
- `xautolock` → ставим из репо, если есть.
- `dex` → не критично, заменяем собственным автозапуском.

### 2. Структура конфигов

Скопировать в `i3-fedora-ready/.config/`:

```text
i3/
  config          → адаптированный под Fedora + keycodes
  scripts/        → welcome.sh, powermenu.sh, i3exit.sh, keybindings.sh, brightness.sh
polybar/
  config.ini      → Nord theme + автоопределение батареи
  launch.sh       → запускает bar "main" (Fedora) или "toph" (переименовать)
  brightness.sh   → brightnessctl
rofi/
  config.rasi     → базовый
  themes/         → nord.rasi, powermenu.rasi, keybindings.rasi, sidetab-nord.rasi
picom/picom.conf  → стандартный picom (без форка-анимаций), Nord shadows/blur
dunst/dunstrc     → Nord colors + nerd icons
kitty/
fish/
nvim/
tmux/
zellij/
fastfetch/
gtk-3.0/
Kvantum/
qt5ct/
qt6ct/
xsettingsd/
starship/starship.toml
.bashrc
.xinitrc
```

### 3. Адаптация i3 config

- Заменить `bindsym $mod+odiaeresis focus right` на `bindcode $mod+46 focus right` (физическая клавиша L).
- Добавить keycodes для всех буквенных хоткеев (RU-safe): Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, X, C, V, B, N, M, /, и т.д.
- Убрать `dex` и `xss-lock -- slock` из автозапуска.
- Исправить пути обоев на `~/Pictures/wallpapers/`.
- Добавить автозапуск: `nm-applet`, `blueman-applet`, `pasystray`, `dunst`, `picom`, `polybar`, `setxkbmap`, `gnome-keyring-daemon`, `lxpolkit`/`polkit-gnome-authentication-agent-1`.
- Добавить floating rules для Hiddify/Happ (VPN), Pavucontrol, Nm-connection-editor.

### 4. Polybar

- Единый бар с Nord-цветами, иконками Nerd Font.
- Модули слева: `i3` (workspace icons), `xwindow`.
- Модули справа: `pulseaudio`, `brightness`, `cpu`, `memory`, `battery`, `date`, `systray`.
- Автоопределение батареи/адаптера в `launch.sh` (BAT0/BAT1, ADP1/ACAD).
- `brightness.sh` через `brightnessctl`.
- Иконки батареи/звука/CPU/памяти — Nerd Font glyphs.

### 5. Rofi

- Launcher: `nord.rasi`.
- Powermenu: `powermenu.rasi` + `i3/scripts/powermenu.sh`.
- Keybindings help: `keybindings.rasi` + `i3/scripts/keybindings.sh`.
- Все цвета в стиле Nord.

### 6. Picom

- Без анимаций (стандартный picom на Fedora).
- glx backend, тени, углы (corner-radius), blur для прозрачности.
- Исключения: dock, desktop, Rofi, Dunst, Polybar.

### 7. Dunst

- Nord-цвета, закруглённые углы, иконки.
- Привязка к top-right с отступом от панели.

### 8. GTK / Qt / Themes / Icons / Cursor

- Установить темы и иконки из `harilvfs/themes` и `harilvfs/icons`.
- Прописать в `gtk-3.0/settings.ini`, `lxappearance`.
- Настроить `Kvantum`, `qt5ct`, `qt6ct`.
- Курсоры: `Bibata-Modern-Ice` или `Capitaine Cursors`.

### 9. SDDM (опционально)

- Скопировать `sddm/themes/sddm-astronaut-theme/` в `/usr/share/sddm/themes/`.
- Создать `/etc/sddm.conf` с `Current=sddm-astronaut-theme`.
- `systemctl disable gdm` / `systemctl enable sddm`.
- Включать только по запросу пользователя (не по умолчанию).

### 10. Install script

- `install.sh`:
  1. Backup `~/.config/i3`, `polybar`, `rofi`, `picom`, `dunst`, `kitty`, `fish`, etc.
  2. `sudo dnf install -y` всё нужное.
  3. Установить JetBrainsMono Nerd Font в `~/.local/share/fonts/`.
  4. Скопировать все `.config/*` в `~/.config/`.
  5. Скопировать `.bashrc`, `.xinitrc` в `$HOME` (с бэкапом).
  6. Скопировать обои в `~/Pictures/wallpapers/`.
  7. Скопировать темы/иконки в `~/.themes/` и `~/.icons/`.
  8. Опционально: настроить SDDM.
  9. Проверить `i3 -C -c ~/.config/i3/config`.
  10. Вывести summary.

### 11. Проверка

- `i3 -C -c ~/.config/i3/config` — без ошибок.
- `polybar -c ~/.config/polybar/config.ini main` — запускается, батарея/звук работают.
- `picom --config ~/.config/picom/picom.conf -b` — без падений.
- `dunst` — запускается.
- `rofi -show drun` — показывается.
- Проверить, что все бинды отрабатывают на RU/EN.

## Файлы для изменения

- `.config/i3/config`
- `.config/i3/scripts/*`
- `.config/polybar/config.ini`
- `.config/polybar/launch.sh`
- `.config/polybar/brightness.sh`
- `.config/rofi/config.rasi`
- `.config/rofi/themes/*`
- `.config/picom/picom.conf`
- `.config/dunst/dunstrc`
- `install.sh`
- `README.md`
