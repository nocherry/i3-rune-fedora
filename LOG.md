# Лог адаптации i3 Arch → Fedora

## 2026-07-31

### Что сделано

1. **Изучены оба репозитория**: `i3wmdotfiles-main` (Arch) и `i3-fedora-ready` (текущая Fedora-адаптация).
2. **Создан `PLAN.md`** — пошаговый план переноса.
3. **Создан `LOG.md`** — этот файл, для прозрачности решений.

### Дополнительные пожелания пользователя

- Перенести **обои/фото/видео** (клонировать `harilvfs/wallpapers`).
- Установить **Nerd-шрифты** для корректных иконок в polybar/rofi/dunst/kitty.
- Добавить **анимации** и визуальные эффекты, как в Hyprland.
- Сделать **Kitty красивым** в консоли.
- Сохранить **все взаимодействия** (welcome, powermenu, keybindings, трей).

### Почему такие решения

- **Тёмная тема Nord из Arch**: пользователь явно выбрал её в ответе на вопрос. Kitty остаётся Catppuccin Mocha, потому что именно такой `theme.conf` идёт в Arch-репо.
- **Keycodes вместо bindsym для буквенных клавиш**: Arch-конфиг использует немецкий keysym `odiaeresis`, который не существует на US/RU раскладке. Keycodes (физические номера клавиш) работают независимо от языка.
- **Kitty вместо Alacritty**: в Arch-репо уже есть полноценный kitty-конфиг, и пользователь выбрал "всё подряд". Kitty с padding + прозрачностью + cursor trail выглядит современно.
- **Стандартный picom вместо форка с анимациями**: в Fedora нет готового пакета `picom-animations-git`, используем glx backend + тени/углы/blur/fade. Это максимально близко к Hyprland без сторонних форков.
- **JetBrainsMono Nerd Font**: используется в i3, polybar, rofi, dunst. Стандартный `jetbrains-mono-fonts-all` не содержит Nerd-иконки, поэтому ставим рукой из релизов.
- **brightnessctl вместо light**: в Fedora `brightnessctl` есть в репо, `light` может отсутствовать.
- **flameshot вместо maim**: в Arch-конфиге используется flameshot, и он есть в Fedora.
- **polkit-gnome-authentication-agent-1**: замена Arch `polkit-gnome` → Fedora `polkit-gnome`.
- **Автоопределение батареи BAT0/BAT1 и адаптера ADP1/ACAD**: разные ноутбуки по-разному именуют power supply.
- **SDDM опционально**: не включаем по умолчанию, чтобы не ломать текущий менеджер входа.

### Копирование недостающих конфигов

- Скопированы все дополнительные конфиги из Arch: `kitty`, `fish`, `nvim`, `tmux`, `zellij`, `fastfetch`, `gtk-3.0`, `Kvantum`, `qt5ct`, `qt6ct`, `xsettingsd`, `starship`, `.bashrc`, `.xinitrc`, `sddm`.
- Скопированы скрипты i3 (`welcome.sh`, `powermenu.sh`, `i3exit.sh`, `keybindings.sh`) и темы rofi.
- Сделан бэкап `.config.orig` перед изменениями.
- Почему: пользователь выбрал "всё подряд", поэтому переносим всю экосистему, а не только i3.

### Адаптация i3 config

- Создан новый `~/.config/i3/config` на базе Arch-конфига.
- Все буквенные bindsym заменены на keycodes (`bindcode`) — работает на RU/EN.
- Стандартная vim-раскладка HJKL для фокуса и перемещения.
- Super+; (keycode 47) вместо немецкого `odiaeresis` для фокуса вправо.
- Автозапуск: `setxkbmap`, polkit-gnome, gnome-keyring, xsettingsd, nm-applet, blueman-applet, pasystray, dunst, feh, polybar, picom, welcome.sh.
- Убран `dex` (нет в Fedora) и `xss-lock -- slock` (slock заменён на i3lock).
- Floating rules для VPN (Hiddify/Happ) и системных диалогов.

### Адаптация Polybar

- Перекрашена в Nord dark палитру из Arch.
- Бар переименован в `main`.
- Добавлено автоопределение батареи/адаптера через переменные окружения в `launch.sh`.
- Иконки Nerd Font для батареи, звука, CPU, памяти, яркости.

### Адаптация Rofi / Picom / Dunst

- Rofi использует `nord.rasi`, `launcher.rasi` перекрашен в Nord.
- Picom: glx backend, тени, fade, blur kawase, rounded corners, прозрачность неактивных окон.
- Dunst перекрашен в Nord-цвета.

### Обновление вспомогательных скриптов

- `keybindings.sh`: убраны `Ö`, заменён Alacritty на Kitty, добавлены resize/gaps пояснения.
- `i3exit.sh`: lock падает на сплошной Nord-фон, если `bg.png` не найден.

### Install script

- Переписан `install.sh`: backup, dnf packages, Nerd Font, wallpapers, configs, permissions, optional SDDM, verification.
- README переписан под новое состояние.

### Адаптация i3 config — Hyprland keybindings

- Найдена и проанализирована актуальная Hyprland-конфигурация пользователя: `~/.config/hypr/configs/Keybinds.conf`, `~/.config/hypr/UserConfigs/UserKeybinds.conf`, `~/.config/hypr/configs/Laptops.conf`.
- Переписан `~/.config/i3/config` так, чтобы хоткеи максимально повторяли Hyprland (JaKooLit dots):
  - `Super+D` — Rofi
  - `Super+Enter` — Kitty
  - `Super+E` — Thunar
  - `Super+B` — браузер
  - `Super+H` — keybindings help
  - `Super+Q` — закрыть окно
  - `Ctrl+Alt+L` — lock
  - `Ctrl+Alt+P` — powermenu
  - `Super+Tab` / `Super+Shift+Tab` — следующий/предыдущий воркспейс
  - `Super+Shift+[` / `Super+Shift+]` — move to prev/next workspace
  - `Super+U` / `Super+Shift+U` — scratchpad (аналог special workspace)
  - Стрелки для фокуса/перемещения (как в Hyprland)
  - F6 fallback для скриншотов на ноутбуках без Print
- Все буквенные клавиши привязаны через `bindcode` (keycodes), чтобы работали на русской раскладке.
- Сохранён режим `resize` (Super+R) и `gaps` (Super+Shift+G).

### Polybar

- Исправлена ошибка формата батареи: `format-charging` теперь использует `<label-charging>`, а не `<label>`.
- Батарея и адаптер берутся из переменных окружения `POLYBAR_BATTERY` / `POLYBAR_ADAPTER` (автоопределение в `launch.sh`).
- Запущена проверка: `polybar -c config.ini main` загружается без ошибок.

### LightDM / SDDM

- Пользователь использует LightDM (SDDM на Wayland ломал X11-сессии).
- `install.sh` больше НЕ включает SDDM по умолчанию.
- Добавлена проверка наличия `/usr/share/xsessions/i3.desktop` для LightDM.
- SDDM + astronaut-theme оставлен опцией; при выборе шрифты темы копируются в `/usr/share/fonts/` и обновляется `fc-cache`.

### Kvantum / SDDM

- Проверено, что `Kvantum/Nord-Kvantum/` (kvconfig + svg) и `sddm/themes/sddm-astronaut-theme/` (со шрифтами в `Fonts/`) уже скопированы в `i3-fedora-ready/.config/`.
- В `install.sh` добавлено копирование шрифтов SDDM-темы в `/usr/share/fonts/`.

### Скриншоты и зависимости

- У пользователя уже установлен `maim`, но не `flameshot`. Чтобы не добавлять лишний пакет, скриншоты переключены на `maim`.
- Убран `xdotool` (не установлен) из скриптов скриншотов.
- `install.sh` обновлён: убран `flameshot`, добавлены `maim`, `playerctl`, `thunar`.

### LightDM / Polkit / WiFi / NVIDIA

- Пользователь использует LightDM (SDDM на Wayland ломал X11). `install.sh` не трогает LightDM по умолчанию.
- В `i3/config` политик-агент заменён на автоопределение: сначала `lxqt-policykit-agent` (уже установлен), fallback на `polkit-gnome-authentication-agent-1`.
- WiFi-пароль: `nm-applet` + `gnome-keyring-daemon` должны сохранять пароль. Если будет запрашивать каждый раз — нужно включить "Connect automatically" и "Available to all users" в `nm-connection-editor`.
- NVIDIA MX130 + Intel UHD 620: picom на glx может глючить; в README указан fallback на `xrender`.

### Проверка

- `bash -n install.sh` — OK.
- `i3 -C -c ~/.config/i3/config` — OK, ошибок нет.
- `polybar -c ~/.config/polybar/config.ini main` — загружается без ошибок.

## Полный аудит железа и конфигов (2026-07-31)

### 1. Железо

| Компонент | Что нашлось | Риски |
|-----------|-------------|-------|
| CPU | Intel i5-8250U (Kaby Lake-R) | — |
| GPU | Intel UHD 620 + NVIDIA MX130 | picom glx может глючить на старом Intel; fallback на xrender |
| Дисплей | eDP-1 1920×1080 | — |
| Батарея | BAT0, адаптер AC0 | polybar должен использовать AC0, не ADP1 |
| Звук | PipeWire (PulseAudio-совместимый) | pactl работает, pavucontrol есть |
| WiFi | wlp2s0 (ASUS) | пароль должен сохраняться через NetworkManager + gnome-keyring |
| Bluetooth | hci0 (ASUS) | blueman-applet нужен для трея |
| Тачпад | не виден в xinput | возможно, внешняя мышь или другой драйвер |

### 2. Пакеты — проверка по факту

**Уже установлены (проверено rpm):**
i3, polybar, rofi, picom, dunst, kitty, feh, brightnessctl, maim, playerctl, xclip, xss-lock, i3lock, nwg-look, qt5ct, qt6ct, kvantum, jetbrains-mono-fonts, google-noto-emoji-fonts, papirus-icon-theme, btop, yad, git, unzip, curl, lxqt-policykit, bat, fastfetch.

**Установлены, но под другими именами:**
- `Thunar` (не `thunar`)
- `network-manager-applet` (binary `nm-applet`)
- `blueman` (binary `blueman-applet`)
- `wget2-wget` (binary `wget`)

**Отсутствуют (ставятся через install.sh):**
`pasystray`, `fontawesome-fonts-web`, `starship` (ставим curl-скриптом), `fish`, `zoxide`, `eza`, `neovim`, `gnome-keyring`, `gnome-settings-daemon`, `polkit-gnome` (в репо нет — не нужен, есть lxqt-policykit), `slock` (заменяем на i3lock), `xautolock` (опционально).

### 3. Найденные и устранённые проблемы

#### 3.1 Picom
- **Было:** deprecated `glx-no-stencil`, deprecated `:c` в `_GTK_FRAME_EXTENTS@:c`.
- **Стало:** убраны deprecated-опции. Теперь `picom --diagnostics` показывает только информационный warning про EGL.
- **Почему:** устаревшие опции вызывают warnings и могут ломаться в будущих версиях picom.

#### 3.2 Polybar
- **Было:** battery module использовал `<label>` вместо `<label-charging>` / `<label-discharging>` — polybar падал с ошибкой.
- **Стало:** форматы исправлены. Батарея/адаптер берутся из `POLYBAR_BATTERY` / `POLYBAR_ADAPTER`, автоопределяемых в `launch.sh` (ищет `ADP|^AC`).
- **Почему:** на твоём ноутбуке адаптер называется AC0, а не ADP1.

#### 3.3 Dunst
- **Было:** legacy `height = 100` и `offset = 12x42` — dunst ругался.
- **Стало:** `height = (0, 100)` и `offset = (12, 42)`.
- **Почему:** новый синтаксис dunst 1.12+, иначе каждый запуск будет спамить warnings.

#### 3.4 Kitty
- **Было:** `tabs.conf` существовал, но не подключался в `kitty.conf` (закомментирован).
- **Стало:** `include tabs.conf` добавлен.
- **Почему:** иначе кастомные табы/сплиты в Kitty не работали бы.

#### 3.5 i3 config — автозапуск polkit
- **Было:** жёстко прописан `/usr/libexec/polkit-gnome-authentication-agent-1`, а в Fedora у тебя `lxqt-policykit-agent`.
- **Стало:** автоопределение — сначала lxqt, fallback на polkit-gnome.
- **Почему:** иначе GUI-запросы пароля (пакетная установка, wifi, и т.д.) не показывались бы.

#### 3.6 .xinitrc
- **Было:** использовал `slock` и `xautolock`, которых нет в системе.
- **Стало:** `i3lock` + условный `xautolock` (только если установлен).
- **Почему:** startx из TTY не должен падать из-за отсутствующих программ.

#### 3.7 .bashrc
- **Было:** pacman/yay-алиасы, `nitch` в конце (не установлен), `install_bashrc_support` использовал `yum`.
- **Стало:** pacman-алиасы заменены на dnf-эквиваленты, `nitch` вызывается только если найден, `install_bashrc_support` использует `dnf`.
- **Почему:** без этого каждый запуск терминала выдавал бы ошибки.

#### 3.8 install.sh
- **Было:** неправильные имена пакетов (`thunar` вместо `Thunar`, `nm-applet` вместо `network-manager-applet` и т.д.), стarship не ставился (нет в репо), `wget` предполагался установленным.
- **Стало:** имена исправлены, starship ставится через официальный curl-скрипт, используется `curl` для загрузок.
- **Почему:** иначе `dnf install` падал бы на несуществующих пакетах.

#### 3.10 install.sh — права на выполнение
- **Было:** скрипт не был executable, пользователь получал `permission denied`.
- **Стало:** `chmod +x install.sh`.
- **Почему:** `bash ./install.sh` сработал бы без прав, но `./install.sh` требует `+x`.

## Результаты запуска install.sh (2026-07-31)

### Что прошло хорошо
- Бэкап создан: `/home/fedora/.config/i3-fedora-backup-20260731-184420`
- Конфиги успешно скопированы в `~/.config/`
- Темы и иконки склонированы в `~/.themes` и `~/.icons`
- `i3 -C -c ~/.config/i3/config` — OK
- SDDM включён, astronaut-theme + шрифты установлены
- Nerd Font, eza, themes/icons — установлены

### Проблемы, обнаруженные при установке

#### 1. `dnf install` упал из-за отсутствующих пакетов
**Было:** `No match for argument: pasystray`, `xorg-x11-server-utils`, `fontawesome-fonts-web`.
**Почему:** эти пакеты отсутствуют в репозиториях Fedora 43.
**Исправлено в install.sh:** добавлен `--skip-unavailable`, убраны `pasystray` и `xorg-x11-server-utils`, убран `fontawesome-fonts-web`.

#### 2. Polybar шрифт Font Awesome 6 Free не найден
**Было:** в `polybar/config.ini` была ссылка на `font-1 = "Font Awesome 6 Free"`, которого нет в системе.
**Исправлено:** убрана зависимость от Font Awesome 6, все иконки теперь берутся из JetBrainsMono Nerd Font.
**Применено:** и в репозитории, и в `~/.config/polybar/config.ini` пользователя.

#### 3. SDDM включён без принудительного X11
**Было:** install.sh включил SDDM, но не добавил `DisplayServer=x11`. На твоём ноутбуке SDDM на Wayland раньше ломал X11-сессии.
**Что нужно сделать:** вручную добавить X11-конфиг SDDM:
```bash
printf "[General]\nDisplayServer=x11\n" | sudo tee /etc/sddm.conf.d/x11.conf
```
Или, если хочешь вернуть LightDM:
```bash
sudo systemctl disable sddm
sudo systemctl enable lightdm
```

### Следующие шаги для пользователя
1. Выбрать и применить один из вариантов SDDM/X11 выше.
2. Перезагрузиться.
3. Войти в i3 (через SDDM или LightDM).
4. Проверить: Super+Enter (Kitty), Super+D (Rofi), Super+Q, Alt+Shift.
5. Если SDDM всё ещё ломается — переключиться обратно на LightDM.
6. WiFi: открыть `nm-connection-editor`, включить "Connect automatically" и "Store password for all users".


1. **WiFi пароль:** открыть `nm-connection-editor`, выбрать сеть → редактировать → включить "Connect automatically" и "Store the password for all users".
2. **Обои:** после `install.sh` выполнить `git clone https://github.com/harilvfs/wallpapers ~/Pictures/wallpapers` (или installer сделает это сам).
3. **Темы/иконки:** installer предложит склонировать `harilvfs/themes` и `harilvfs/icons` в `~/.themes` и `~/.icons`. После этого выбрать их через `nwg-look` или `lxappearance`.
4. **NVIDIA:** если нужен NVIDIA-рендеринг в X11, убедиться, что установлен `xorg-x11-drv-nvidia` (обычно ставится вместе с `akmod-nvidia`). Для чисто десктопного i3 достаточно Intel.
5. **Анимации:** стандартный picom в Fedora не поддерживает "Hyprland-анимации" (форк `picom-animations`). Используемые тени/fade/blur — максимум без стороннего форка.

### 5. Финальные команды проверки

```bash
cd /home/fedora/Documents/Code/X11/i3-fedora-ready

bash -n install.sh
i3 -C -c .config/i3/config
polybar -c .config/polybar/config.ini main
picom --config .config/picom/picom.conf --diagnostics
timeout 3 dunst -config .config/dunst/dunstrc --print
for f in .config/i3/scripts/*.sh; do bash -n "$f"; done
```

## Ошибки после первого запуска i3 и их исправление (2026-07-31)

### Ошибка 1: `Super + D` не работает

**Текст ошибки:**
```
The configured command for this shortcut could not be run successfully.
ERROR: Expected one of these tokens: <end>
ERROR: Your command: exec pkill rofi || rofi -show drun -modi drun,filebrowser,run,window
```

**Причина:** i3 не понимает `||` внутри `exec`. Команда `exec pkill rofi || rofi ...` парсится как два отдельных выражения.

**Исправление:** завернуть команду в `sh -c`:
```
bindcode $mod+40 exec --no-startup-id sh -c 'pkill rofi || rofi -show drun -modi drun,filebrowser,run,window'
```

**Где исправлено:**
- `~/.config/i3/config`
- `/home/fedora/Documents/Code/X11/i3-fedora-ready/.config/i3/config`

### Ошибка 2: чёрный экран вместо обоев

**Причина:** в автозапуске использовалась команда:
```
feh --randomize --bg-fill ~/Pictures/wallpapers/*
```
В `~/Pictures/wallpapers/` есть файлы с пробелами в именах (например, `Abstract - Nature.jpg`). Shell разбивает такие имена по пробелам, и `feh` получает куски имён вместо целых файлов — поэтому обои не ставятся, экран чёрный.

**Исправление:** использовать `find` + `shuf` и брать один файл в кавычках:
```
sh -c 'wp=$(find ~/Pictures/wallpapers -type f 2>/dev/null | shuf -n 1); [ -n "$wp" ] && feh --bg-fill --no-fehbg "$wp" || feh --bg-fill --no-fehbg ~/.config/i3/wallpaper.png'
```

То же самое исправлено для `Super + W` (случайные обои).

**Где исправлено:**
- `~/.config/i3/config`
- `/home/fedora/Documents/Code/X11/i3-fedora-ready/.config/i3/config`

### Ошибка 3: pasystray не найден

**Причина:** в автозапуске был `exec --no-startup-id pasystray`, но пакет не установлен (его нет в репах Fedora 43). Это давало ошибку при старте.

**Исправление:** сделать запуск условным:
```
exec --no-startup-id sh -c "command -v pasytray >/dev/null && pasytray &"
```

**Где исправлено:**
- `~/.config/i3/config`
- `/home/fedora/Documents/Code/X11/i3-fedora-ready/.config/i3/config`
- `/home/fedora/Documents/Code/X11/i3-fedora-ready/install.sh`

### Что нужно сделать пользователю

1. Нажать `Super + Shift + C` для перезагрузки конфига i3.
2. Проверить `Super + D` — должен открыться Rofi.
3. Обои должны появиться сразу после reload (или после нового входа).
4. Если обои не появились — нажать `Super + W`.

## Ошибка 4: обои всё ещё не ставятся автоматически

**Причина:** внутри `sh -c '...'` использовался `~` вместо `$HOME`. В одинарных кавычках `~` не разворачивается в домашнюю директорию, поэтому `find ~/Pictures/wallpapers` искал буквальный путь `~/Pictures/wallpapers`, который не существует.

**Исправление:** вместо хрупких inline-команд создан отдельный скрипт `~/.config/i3/scripts/wallpaper.sh`. Он корректно работает с пробелами в именах файлов и падает на fallback-обои.

Содержимое `wallpaper.sh`:
```bash
#!/usr/bin/env bash
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
FALLBACK="$HOME/.config/i3/wallpaper.png"
wp=$(find "$WALLPAPER_DIR" -type f 2>/dev/null | shuf -n 1)
[ -n "$wp" ] && feh --bg-fill --no-fehbg "$wp" || feh --bg-fill --no-fehbg "$FALLBACK"
```

i3 config теперь вызывает:
```
exec --no-startup-id ~/.config/i3/scripts/wallpaper.sh
```

**Где исправлено:**
- `/home/fedora/Documents/Code/X11/i3-fedora-ready/.config/i3/scripts/wallpaper.sh` (новый файл)
- `/home/fedora/Documents/Code/X11/i3-fedora-ready/.config/i3/config`
- `~/.config/i3/scripts/wallpaper.sh`
- `~/.config/i3/config`

**Проверка:**
```bash
~/.config/i3/scripts/wallpaper.sh
```

## Проверка SDDM (подтверждено пользователем)

- Команда `printf "[General]\nDisplayServer=x11\n" | sudo tee /etc/sddm.conf.d/x11.conf` была применена вручную.
- Пользователь подтвердил: при входе появляется экран SDDM, X11-сессия работает.
- Эта же команда уже включена в `install.sh` — при следующем запуске скрипта будет применяться автоматически.

## Подготовка к публикации на GitHub

- Создан git-репозиторий в `/home/fedora/Documents/Code/X11/i3-fedora-ready`.
- Добавлен `.gitignore` (исключаются бэкапы `.config.orig`, `*.log`, личные файлы).
- Сделан начальный commit.

## Исправление: Super+D и Super+Shift+S не работают (2026-07-31)

### Проблема
- `Super + D` — не открывает Rofi, i3 показывает "show errors".
- `Super + Shift + S` — не делает скриншот области.
- Пользователь просит, чтобы все хоткеи работали и на русской раскладке.

### Причина
- `Super + D`: команда `exec --no-startup-id sh -c 'pkill rofi || rofi ...'` в принципе правильная, но `||` внутри `exec` исторически вызывал проблемы с i3 command parser, и пользователь продолжал видеть ошибки. Кроме того, inline-команды со спецсимволами сложно отлаживать.
- `Super + Shift + S`: этот Hyprland-хоткей вообще не был добавлен в i3 config.
- Русская раскладка: для переключения языка используется `setxkbmap us,ru` с `grp:alt_shift_toggle`. В i3 буквенные keysyms (`bindsym $mod+d`) зависят от текущей раскладки, поэтому на русском они не срабатывают. Keycodes (`bindcode <keycode>`) используют физические номера клавиш и не зависят от языка.

### Исправление
1. **Вынес toggle-логику Rofi в отдельный скрипт** `~/.config/i3/scripts/rofi.sh`:
   ```bash
   if pgrep -x rofi >/dev/null 2>&1; then
       pkill -x rofi
   else
       rofi -show drun -modi drun,filebrowser,run,window
   fi
   ```
   i3 теперь вызывает просто:
   ```
   bindcode $mod+40 exec --no-startup-id ~/.config/i3/scripts/rofi.sh
   ```

2. **Создан `~/.config/i3/scripts/screenshot.sh`** для maim:
   ```bash
   mode="${1:-area}"
   mkdir -p "$HOME/Pictures/Screenshots"
   out="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
   case "$mode" in
       full)    maim "$out" ;;
       area)    maim -s "$out" ;;
       delay5)  sleep 5; maim "$out" ;;
       delay10) sleep 10; maim "$out" ;;
   esac
   ```
   Биндинги:
   - `Print` → `screenshot.sh full`
   - `Super + Shift + Print` / `Super + Print` / `Super + Shift + S` → `screenshot.sh area`
   - `Super + Ctrl + Print` → `screenshot.sh delay5`
   - `F6` fallback → `screenshot.sh full`

3. **Все буквенные клавиши привязаны через `bindcode`**, что гарантирует работу на RU/EN:
   - `Super+D` → keycode 40
   - `Super+Shift+S` → keycode 39 + Shift
   - `Super+Q` → keycode 24
   - `Super+E` → keycode 26
   - `Super+B` → keycode 56
   - `Super+H` → keycode 43
   - `Super+F` → keycode 41
   - `Super+R` (resize mode) → keycode 27
   - `Super+U` (scratchpad) → keycode 30
   - и т.д.

4. **Обновлён `keybindings.sh`** — добавлена строка `Super + Shift + S → Screenshot area (Hyprland style)`.

5. **Убран дублирующийся комментарий** `### Wallpapers (random)`.

### Проверка
- `i3 -C -c ~/.config/i3/config` — OK.
- `i3 -C -c /home/fedora/Documents/Code/X11/i3-fedora-ready/.config/i3/config` — OK.
- `bash -n ~/.config/i3/scripts/rofi.sh` — OK.
- `bash -n ~/.config/i3/scripts/screenshot.sh` — OK.

### Что нужно сделать пользователю
1. Перезагрузить i3 конфиг: `Super + Shift + C`.
2. Проверить `Super + D` — должен открыться Rofi.
3. Проверить `Super + Shift + S` — курсор должен измениться на крестик для выделения области.
4. Проверить эти же хоткеи после переключения на русскую раскладку (`Alt + Shift`).

### Про ошибки i3
Если снова появится "show errors":
- Из него нельзя скопировать текст — это просто диалог i3-nagbar.
- Полный лог i3 можно посмотреть командой: `i3-dump-log | tail -n 50`.

**Для публикации на GitHub нужно выполнить вручную:**
1. Создать новый репозиторий на https://github.com/new (без README и .gitignore).
2. Скопировать URL (например, `https://github.com/USERNAME/i3-fedora-ready.git`).
3. Выполнить в терминале:
```bash
cd /home/fedora/Documents/Code/X11/i3-fedora-ready
git remote add origin https://github.com/USERNAME/i3-fedora-ready.git
git branch -M main
git push -u origin main
```

## Доработка: иконки в Rofi и дневная тема (2026-07-31)

### Пожелания пользователя
- Добавить иконки слева в `Super + D` (Rofi).
- Как переключать тему Rofi на дневную (светлую).

### Сделано
1. **Иконки в Rofi:**
   - В `~/.config/i3/scripts/rofi.sh` добавлены флаги `-show-icons -icon-theme "Papirus"`.
   - Тема `nord.rasi` уже содержит блоки `element-icon` и `element-text`, поэтому иконки отображаются слева от названий приложений.
   - Набор иконок `Papirus` уже установлен (`papirus-icon-theme`).

2. **Светлая тема Rofi:**
   - Создан файл `~/.config/rofi/themes/nord-light.rasi` на основе `nord.rasi` с цветами Snow Storm.
   - Создан скрипт переключения темы `~/.config/rofi/scripts/toggle-theme.sh`:
     ```bash
     if grep -q 'nord-light' ~/.config/rofi/config.rasi; then
         sed -i 's|themes/nord-light.rasi|themes/nord.rasi|'
         notify-send "Rofi theme" "Dark theme enabled"
     else
         sed -i 's|themes/nord.rasi|themes/nord-light.rasi|'
         notify-send "Rofi theme" "Light theme enabled"
     fi
     ```

3. **Горячая клавиша для переключения темы:**
   - `Super + Shift + D` → `~/.config/rofi/scripts/toggle-theme.sh`
   - Добавлена в `keybindings.sh`.

### Проверка
- `i3 -C -c ~/.config/i3/config` — OK.
- `bash -n ~/.config/rofi/scripts/toggle-theme.sh` — OK.

### Что нужно сделать пользователю
1. Перезагрузить i3: `Super + Shift + C`.
2. Нажать `Super + D` — у приложений слева должны появиться иконки.
3. Нажать `Super + Shift + D` — появится уведомление "Light theme enabled", и следующий вызов `Super + D` будет в светлой теме.
4. Ещё раз `Super + Shift + D` вернёт тёмную тему.

## Багфикс: светлая тема Rofi не применялась (2026-07-31)

### Проблема
Пользователь нажимал `Super + Shift + D`, но разницы между тёмной и светлой темой Rofi не было.

### Причина
Rofi 2.0 не мог распарсить `nord-light.rasi` из-за строки:
```
highlight: underline bold @nord10;
```
В свойстве `highlight` нельзя использовать переменные темы (`@nord10`), только литеральный цвет. Из-за этого Rofi игнорировал `nord-light.rasi` и падал обратно на дефолтную/тёмную тему.

### Исправление
- В `nord-light.rasi` заменено `highlight: underline bold @nord10;` на `highlight: underline bold #5e81ac;`.
- Убраны не-ASCII символы (em-dash) из комментариев на всякий случай.
- Пересоздан файл на основе рабочего `nord.rasi` с минимальными изменениями цветов.

### Проверка
```bash
rofi -no-config -theme ~/.config/rofi/themes/nord-light.rasi -show drun -show-icons -icon-theme Papirus
# OK, без ошибок парсинга
```

### Что нужно сделать пользователю
1. Перезагрузить i3: `Super + Shift + C`.
2. Нажать `Super + Shift + D` — уведомление "Light theme enabled".
3. Нажать `Super + D` — Rofi должен стать светлым (белый/серый фон, тёмный текст).
4. Повторное `Super + Shift + D` вернёт тёмную тему.

## Доработка: чёткая светлая тема, скриншот без размытия и сразу в буфер обмена (2026-07-31)

### Проблемы
1. Пользователь всё ещё не видел разницы между тёмной и светлой темой Rofi.
2. Скриншот области (`maim -s`) размывал экран при выделении.
3. После скриншота файл сохранялся, но не копировался в буфер обмена — нельзя сразу `Ctrl+V`.
4. Ошибки i3 нельзя скопировать из диалога `show errors`.

### Исправления

#### 1. Светлая тема Rofi — максимально контрастная
- `nord-light.rasi` переписан: белый фон (`#ffffff`) для `listview` и `inputbar`, тёмный текст (`#2e3440`), без прозрачности `screenshot`.
- Окно теперь имеет сплошной светлый фон `#f0f0f0`.
- Разница с тёмной темой должна быть очевидна.

#### 2. Скриншот без размытия
- В `screenshot.sh` для режима `area` добавлен флаг `maim -s --shader=""`.
- Это отключает шейдер slop, который по умолчанию затемнял/размывал фон при выделении области.

#### 3. Скриншот сразу в буфер обмена
- После успешного сохранения скриншота файл копируется в clipboard через `xclip`:
  ```bash
  [ -s "$out" ] && xclip -selection clipboard -t image/png < "$out" && \
      notify-send "Screenshot" "Copied to clipboard"
  ```
- Работает для всех режимов: `full`, `area`, `delay5`, `delay10`.
- После `Super + Shift + S` или `Print` можно сразу нажать `Ctrl + V` в любом приложении.

#### 4. Копирование ошибок i3
- Добавлена горячая клавиша `Super + Shift + H`:
  ```
  bindcode $mod+Shift+43 exec --no-startup-id sh -c "i3-dump-log | tail -n 50 | xclip -selection clipboard && notify-send 'i3 errors' 'Copied to clipboard'"
  ```
- Теперь можно нажать `Super + Shift + H`, и последние 50 строк лога i3 окажутся в буфере обмена.

### Обновлённые файлы
- `~/.config/rofi/themes/nord-light.rasi`
- `~/.config/i3/scripts/screenshot.sh`
- `~/.config/i3/config` (добавлен биндинг `Super + Shift + H`)
- `~/.config/i3/scripts/keybindings.sh`
- Синхронизировано в `/home/fedora/Documents/Code/X11/i3-fedora-ready/`

### Проверка
- `i3 -C -c ~/.config/i3/config` — OK.
- `bash -n ~/.config/i3/scripts/screenshot.sh` — OK.
- `rofi -no-config -theme ~/.config/rofi/themes/nord-light.rasi -show drun` — OK.

### Что нужно сделать пользователю
1. Перезагрузить i3: `Super + Shift + C`.
2. Проверить `Super + Shift + D` → `Super + D` — Rofi должен быть белым/светлым.
3. Проверить `Super + Shift + S` — экран не должен размываться, после выделения области скриншот скопирован в буфер; открой браузер/мессенджер и нажми `Ctrl + V`.
4. Проверить `Super + Shift + H` — последние ошибки i3 скопируются в буфер обмена.

## Глобальное переключение светлой/тёмной темы (2026-07-31)

### Что сделано
Реализовано полное переключение темы одной клавишей `Super + Shift + D` через `~/.config/i3/scripts/theme-toggle.sh`.

Затронутые компоненты:
1. **i3 рамки окон:**
   - `~/.config/i3/themes/dark.conf`
   - `~/.config/i3/themes/light.conf`
   - `~/.config/i3/theme-current.conf` (активная тема)
   - В `~/.config/i3/config` цвета заменены на `include ~/.config/i3/theme-current.conf`.

2. **Polybar:**
   - `~/.config/polybar/colors-dark.ini`
   - `~/.config/polybar/colors-light.ini`
   - `~/.config/polybar/colors-current.ini` (активная палитра)
   - В `~/.config/polybar/config.ini` цвета подключаются через `include-file`.

3. **Kitty:**
   - `~/.config/kitty/theme-dark.conf` — Catppuccin Mocha.
   - `~/.config/kitty/theme-light.conf` — Catppuccin Latte.
   - `~/.config/kitty/theme-current.conf` (активная тема)
   - В `~/.config/kitty/kitty.conf` подключается `theme-current.conf`.

4. **Rofi:**
   - Уже были `nord.rasi` и `nord-light.rasi`.
   - Скрипт меняет `~/.config/rofi/config.rasi`.

5. **GTK/Icons:**
   - Через `gsettings` ставится `Adwaita`/`Adwaita-dark` и `Papirus`/`Papirus-Dark`.
   - Устанавливается `color-scheme prefer-light` / `prefer-dark`.

6. **Скрипт `theme-toggle.sh`:**
   - Читает текущее состояние из `~/.config/i3/theme-state`.
   - Копирует нужные файлы тем.
   - Меняет GTK-настройки.
   - Делает `i3-msg reload` и перезапускает polybar.
   - Показывает `notify-send`.

7. **`install.sh`:**
   - Инициализирует `~/.config/i3/theme-state` значением `dark`.

### Проверка
- `bash -n ~/.config/i3/scripts/theme-toggle.sh` — OK.
- `i3 -C -c ~/.config/i3/config` — OK.
- `polybar -c ~/.config/polybar/config.ini main` — OK.
- `kitty +runpy` — OK.
- Ручное переключение `~/.config/i3/scripts/theme-toggle.sh` работает: меняется `theme-state` и `rofi/config.rasi`.

### Что нужно сделать пользователю
1. Перезагрузить i3: `Super + Shift + C`.
2. Нажать `Super + Shift + D` — должно переключиться в светлую тему:
   - рамки окон i3 станут светлыми,
   - polybar перезапустится со светлой палитрой,
   - Rofi при следующем открытии будет светлым,
   - GTK-приложения переключатся (если тема Adwaita/Papirus установлена).
3. Ещё раз `Super + Shift + D` вернёт тёмную тему.
4. Для Kitty: новые окна откроются с активной темой; уже открытые окна нужно перезапустить.

### Ограничения
- Kvantum/Qt темы не переключаются автоматически, потому что имена Kvantum-тем могут отличаться. Если нужно — добавляется отдельная строка в `theme-toggle.sh`.
- Для полного переключения GTK может понадобиться перезапуск приложений (Firefox, Telegram и т.д.).

## Фоновые лаунчеры (2026-07-31)

### Проблема
Пользователь хотел запускать процессы "сверху экрана" (из панели/меню), чтобы не видеть GTK-ошибок в терминале, как при запуске `./tg-ws-proxy`.

### Решение
- Создан универсальный обёртка `~/.config/i3/scripts/run-bg.sh`:
  - принимает имя и команду,
  - запускает в фоне через `nohup`,
  - stdout/stderr пишет в `~/.local/share/i3/launchers/<name>.log`,
  - показывает `notify-send`.
- Создан пример `~/.config/i3/launchers/tg-ws-proxy.sh`.
- В Control Center добавлен пункт `Launch: tg-ws-proxy`.

### Как добавить свои лаунчеры
1. Создать файл `~/.config/i3/launchers/имя.sh`:
   ```bash
   #!/usr/bin/env bash
   ~/.config/i3/scripts/run-bg.sh имя /полный/путь/к/программе [аргументы]
   ```
2. `chmod +x ~/.config/i3/launchers/имя.sh`.
3. Добавить строку в `~/.config/i3/scripts/control-center.sh` в меню и `case`.

### Проверка
- `bash -n ~/.config/i3/scripts/run-bg.sh` — OK.
- `bash -n ~/.config/i3/scripts/control-center.sh` — OK.

### Что нужно сделать пользователю
1. Проверить/исправить путь в `~/.config/i3/launchers/tg-ws-proxy.sh`, если `tg-ws-proxy` лежит не в `$HOME/Documents/youtube/usr/bin/`.
2. Запустить через Control Center (`Super + \`` → `Launch: tg-ws-proxy`).
3. Проверить лог: `cat ~/.local/share/i3/launchers/tg-ws-proxy.log`.

## Буфер обмена + Kitty copy/paste на RU/EN (2026-07-31)

### Что сделано
1. **Установлен `greenclip`** в `~/.local/bin/greenclip` (статический бинарь, без sudo).
2. **Создан конфиг** `~/.config/greenclip.toml`.
3. **Добавлен автозапуск демона** greenclip в i3 config.
4. **Горячая клавиша истории буфера обмена:**
   - `Super + Shift + \`` → открывает rofi со списком ранее скопированных текстов.
   - Выбранный элемент сразу попадает в clipboard.
   - Привязка через `bindcode` — работает на любой раскладке.
5. **Kitty copy/paste на русской раскладке:**
   - В `~/.config/kitty/kitty.conf` добавлены бинды на кириллические буквы:
     ```
     map ctrl+shift+c       copy_to_clipboard
     map ctrl+shift+с       copy_to_clipboard
     map ctrl+shift+v       paste_from_clipboard
     map ctrl+shift+м       paste_from_clipboard
     ```
   - Теперь в Kitty `Ctrl+Shift+C/V` работает и на US, и на RU раскладке.
6. **`install.sh` обновлён:**
   - скачивает greenclip, если отсутствует;
   - пытается поставить `libinput-gestures`;
   - добавлен greenclip в список проверки.

### Проверка
- `i3 -C -c ~/.config/i3/config` — OK.
- `kitty +runpy` — конфиг Kitty валиден.
- `bash -n install.sh` — OK.

### Что нужно сделать пользователю
1. Перезагрузить i3: `Super + Shift + C`.
2. Скопировать любой текст (`Ctrl+C` или выделить мышью).
3. Нажать `Super + Shift + \`` — появится rofi с историей, выбрать текст.
4. Проверить `Ctrl+Shift+C/V` в Kitty на русской раскладке.

## Жесты тачпада (2026-07-31)

### Что сделано
- Найден тачпад: `ELAN1200:00 04F3:303E Touchpad`.
- Создан `~/.config/libinput-gestures.conf`:
  - 3 пальца влево → следующий воркспейс.
  - 3 пальца вправо → предыдущий воркспейс.
  - 3 пальца вверх → rofi window switcher.
  - 3 пальца вниз → scratchpad.
  - Тап 4 пальцами → скриншот области.
  - Pinch out/in → громкость +/-.
- В i3 autostart добавлен запуск `libinput-gestures-setup start` (условно, если установлен).

### Ограничение
- `libinput-gestures` не установлен в системе. Нужно поставить:
  ```bash
  sudo dnf install libinput-gestures
  ```
  Пользователь уже состоит в группе `input`, поэтому перелогин не нужен.

### Проверка
- Конфиг `~/.config/libinput-gestures.conf` создан.
- `i3 -C -c ~/.config/i3/config` — OK.

### Что нужно сделать пользователю
1. Установить `sudo dnf install libinput-gestures`.
2. Перезагрузить i3.
3. Проверить жесты 3-4 пальцами.


## Крупное обновление: Hyprland-style top bar + control center + wallpaper picker + error handling (2026-07-31)

### Что сделано

#### 1. Переработан polybar под стиль Hyprland waybar
- Бар теперь **сверху**, **плавающий**, с **закруглением 12px** и полупрозрачным фоном.
- Шрифт `JetBrainsMono Nerd Font Bold`.
- Модули:
  - **Слева:** `launcher` (иконка 󰀻) + `xworkspaces`.
  - **Центр:** `date` (часы).
  - **Справа:** `tray`, `battery`, `brightness`, `volume`, `network`, `cpu`, `memory`, `powermenu`.
- Цветовые акценты как в Hyprland waybar:
  - CPU — оранжевый
  - RAM — зелёный
  - Volume — фиолетовый
  - Brightness — жёлтый
  - Date — бирюзовый
  - Battery — зелёный/жёлтый
- Кликабельность:
  - `launcher` → открывает control center.
  - `powermenu` → открывает power menu.
  - `volume` → scroll изменяет громкость, правый клик — `pavucontrol`.
  - `brightness` → scroll изменяет яркость.

Файл: `~/.config/polybar/config.ini`.

#### 2. Control center — `Super + ``
Новый скрипт `~/.config/i3/scripts/control-center.sh` открывает rofi-меню быстрых настроек:
- WiFi toggle / settings
- Bluetooth toggle / settings
- Volume ± / Mute
- Brightness ±
- Screenshot area / full
- Lock / Logout / Reboot / Shutdown
- Toggle dark/light theme (Rofi)
- Toggle polybar
- Wallpaper random / select

#### 3. Выбор обоев через rofi — `Super + W`
- `~/.config/i3/scripts/wallpaper-selector.sh` показывает список обоев из `~/Pictures/wallpapers/`.
- Пункты: `Random`, `Set as fallback`, и все файлы.
- Старый `wallpaper.sh` остался для автозапуска и пункта Random.

#### 4. Умный reload — `Super + Shift + C`
- `~/.config/i3/scripts/reload-safe.sh` сначала проверяет `i3 -C`.
- Если конфиг сломан — показывает `notify-send` и **не делает reload**.
- Если всё ок — `i3-msg reload`.

#### 5. Просмотр ошибок i3
- `Super + Shift + H` — копирует последние 50 строк лога i3 в clipboard.
- `Super + Shift + E` — открывает rofi с последними ошибками/предупреждениями.
- На автозапуске фоном пишется `i3-dump-log > ~/.local/share/i3/log`.

#### 6. Обои из Hyprland-Dots
- Скопированы обои из `/home/fedora/Fedora-Hyprland/Hyprland-Dots/wallpapers/` в `~/Pictures/wallpapers/`.

### Обновлённые файлы
- `~/.config/polybar/config.ini`
- `~/.config/i3/config`
- `~/.config/i3/scripts/keybindings.sh`
- `~/.config/i3/scripts/reload-safe.sh` (новый)
- `~/.config/i3/scripts/wallpaper-selector.sh` (новый)
- `~/.config/i3/scripts/control-center.sh` (новый)
- `~/.config/i3/scripts/errors-rofi.sh` (новый)
- Синхронизировано в `/home/fedora/Documents/Code/X11/i3-fedora-ready/`

### Проверка
- `i3 -C -c ~/.config/i3/config` — OK.
- `polybar -c ~/.config/polybar/config.ini main` — загружается, все 11 модулей на месте.
- `bash -n` на всех новых скриптах — OK.

### Что нужно сделать пользователю
1. Перезагрузить i3: `Super + Shift + C`.
2. Polybar перезапустится автоматически (`exec_always` в i3 config).
3. Проверить верхний бар: иконка лаунчера слева, воркспейсы, часы по центру, системные модули справа.
4. Кликнуть на иконку лаунчера (󰀻) слева — откроется Control Center.
5. `Super + W` — выбрать обои из списка.
6. `Super + `` — открыть Control Center с клавиатуры.
7. Проверить, что после `Super + Shift + S` скриншот копируется в буфер и экран не размывается.

## Багфикс: панель пропадала, WiFi без меню, обои без превью, copy/paste, запуск без warnings (2026-07-31)

### 1. Панель больше не пропадает
- `~/.config/polybar/launch.sh` переписан:
  - PID-файл `/tmp/polybar-launch.pid` — убивает старый цикл запуска при reload.
  - Если polybar падает — автоматически перезапускается.
- Панель теперь **на всю ширину** (`width = 100%`, `offset-x = 0`, `radius = 0), чтобы не оставлять щелей по бокам.

### 2. WiFi — полноценное меню
- Создан `~/.config/i3/scripts/wifi-menu.sh`.
- Сканирует сети `nmcli`, показывает список в rofi: `SSID [сигнал%] [защита]`.
- Подключается к выбранной сети (известной или новой).
- В Control Center пункт переименован в `WiFi: networks`.

### 3. Обои с превью
- `Super + W` теперь открывает `nitrogen` — браузер обоев с миниатюрами.
- Fallback на rofi-список, если nitrogen не установлен.
- `install.sh` теперь ставит `nitrogen`.

### 4. Kitty copy/paste на русской раскладке
- В `~/.config/kitty/kitty.conf` добавлены бинды на кириллические `с/С` и `м/М`.
- Добавлены универсальные `Ctrl+Insert` / `Shift+Insert`, которые не зависят от раскладки.

### 5. Запуск GUI-приложений без warnings в терминале
- `~/.config/i3/scripts/run-bg.sh` теперь:
  - запускает в фоне,
  - пишет лог в `~/.local/share/i3/launchers/`,
  - устанавливает `GTK_MODULES=""`, чтобы подавить warning про `colorreload-gtk-module`.
- В `~/.bashrc` добавлена функция `runbg`, чтобы из терминала тоже можно было запускать cleanly:
  ```bash
  runbg имя /путь/к/приложению
  ```

### 6. Глобальная тема теперь влияет на GTK/Qt приложения
- `theme-toggle.sh` теперь меняет:
  - i3 рамки,
  - polybar,
  - rofi,
  - kitty,
  - **GTK**: `gsettings` + `~/.config/xsettingsd/xsettingsd.conf`, перезапуск `xsettingsd`,
  - **Kvantum/Qt**: `~/.config/Kvantum/kvantum.kvconfig` переключает `catppuccin-mocha-blue` ↔ `catppuccin-latte-blue`.
- По умолчанию GTK-тема теперь `Adwaita-dark` + `Papirus-Dark` вместо `Rose-Pine`, чтобы не было warning'ов парсинга gtk-dark.css.
- `theme-toggle.sh` запускает polybar и xsettingsd в фоне, не блокируется.

### Обновлённые файлы
- `~/.config/polybar/config.ini`
- `~/.config/polybar/launch.sh`
- `~/.config/i3/scripts/wifi-menu.sh` (новый)
- `~/.config/i3/scripts/control-center.sh`
- `~/.config/i3/scripts/wallpaper-selector.sh`
- `~/.config/i3/scripts/theme-toggle.sh`
- `~/.config/i3/scripts/run-bg.sh`
- `~/.config/kitty/kitty.conf`
- `~/.config/xsettingsd/xsettingsd.conf`
- `~/.config/Kvantum/kvantum.kvconfig`
- `~/.bashrc`
- `install.sh`
- Синхронизировано в репозиторий.

### Проверка
- `i3 -C` — OK.
- `bash -n` на всех скриптах — OK.
- `kitty +runpy` — OK.
- `bash -n install.sh` — OK.

### Что нужно сделать пользователю
1. Перезагрузить i3: `Super + Shift + C`.
2. Панель должна быть на всю ширину и не пропадать.
3. `Super + W` → открывается `nitrogen` с миниатюрами обоев. Если nitrogen не установлен — поставить:
   ```bash
   sudo dnf install nitrogen
   ```
4. `Super + \`` → Control Center → `WiFi: networks` → выбрать сеть.
5. В Kitty: `Ctrl+Insert` копирует, `Shift+Insert` вставляет (независимо от раскладки). Попробовать и `Ctrl+Shift+C/V` на русском.
6. `Super + Shift + D` переключает тему; GTK/Qt приложения должны подхватывать (новые окна).
7. Для запуска `tg-ws-proxy` без warnings:
   - через Control Center → `Launch: tg-ws-proxy`, или
   - из терминала: `runbg tg-ws-proxy "$HOME/Documents/youtube/usr/bin/tg-ws-proxy"`.



## Критический багфикс: дубли панелей, скриншоты, lock, greenclip (2026-07-31)

Полный ревью кода выявил несколько критических багов. Все исправлены.

### 1. Дубли панелей polybar
**Причина:** `pkill -f 'polybar/launch.sh'` в launch.sh совпадал с командной строкой самого скрипта и убивал его. Старые циклы (со старой логикой PID-файла) при этом выживали и воскрешали polybar — накапливались 4 цикла и 2 бара.
**Исправление:** убиваем старые циклы через `pgrep -f` с исключением собственного PID, затем `killall polybar`. Цикл автоперезапуска сохранён.
**Проверено:** после `i3-msg reload` ровно 1 процесс polybar + 1 цикл launch.sh.

### 2. Скриншоты области не сохранялись
**Причина:** `maim -s --shader="" "$out"` — парсер maim при пустом значении съедал следующий токен (путь к файлу), PNG уходил в stdout, файл не создавался. Плюс `slop` не был установлен.
**Исправление:** флаг убран (maim по умолчанию не размывает), `slop` добавлен в install.sh.

### 3. Lock на suspend не работал
**Причина:** `i3lock -c #2e3440` внутри `sh -c "..."` — `#` начинал комментарий, `i3lock -c` запускался без аргумента.
**Исправление:** `-c 2e3440` без решётки (и в i3exit.sh).

### 4. greenclip не стартовал
**Причина:** в i3-сессии (SDDM) в PATH нет `~/.local/bin`, `command -v greenclip` падал.
**Исправление:** абсолютный путь `$HOME/.local/bin/greenclip` в автозапуске и в биндинге Super+Shift+`.

### 5. Ctrl+Alt+L / Ctrl+Alt+P не работали на русской
**Исправление:** переведены на bindcode (keycodes 46 и 33).

### 6. WiFi/Bluetooth toggle падали
**Причина:** `nmcli radio wifi toggle` и `bluetoothctl power toggle` — таких аргументов нет.
**Исправление:** on/off через проверку текущего состояния.

### 7. Клик по WiFi в панели
- Левый клик = `nm-connection-editor` (настройки сети, как было в начале).
- Правый клик = `wifi-menu.sh` (список сетей через rofi).
- В Control Center добавлен пункт `WiFi: networks`.

### 8. libinput-gestures
- Пакета нет в репах Fedora → ставится из GitHub в `~/.local/bin`.
- setup-скрипт удалял бинарь → запуск демона напрямую в i3 autostart.
- Бинарь включён в репо.

### 9. errors-rofi читал устаревший файл
**Исправление:** читает живой `i3-dump-log` (Super+Shift+E).

### 10. Разное
- `exec $term;focus` → `exec $term` (`;focus` был shell-мусором).
- `xdg-open "https://"` → `https://www.google.com`.
- `Thunar` → `thunar` в install.sh (регистр ломал установку).
- Добавлен `i3lock` в install.sh.

### Что сделать пользователю
1. `Super + Shift + C` — перезагрузить i3.
2. Проверить: одна панель, тёмная, на всю ширину.
3. `Super + Shift + S` — скриншот области работает, копируется в буфер.
4. Левый клик по WiFi в панели — настройки сети.
5. `Super + Shift + \`` — буфер обмена (greenclip теперь стартует).
6. Lock: закрыть крышку / `systemctl suspend` — экран блокируется.


## WiFi по клику и раскладки для каждого workspace (2026-08-01)

### Что требовалось
- По левому клику на `Famboy` в Polybar показывать список WiFi-сетей.
- Дать возможность отдельно выбирать способ тайлинга на каждом рабочем пространстве, как в Hyprland.
- Проверить авторские скрипты и конфигурации проекта на ошибки и опасные нюансы.
- Записывать принятые решения, причины и способ реализации в этот файл.

### 1. Что такое `Famboy` и как сделан клик
`Famboy` не является отдельным модулем или кнопкой. Это значение `%essid%` в модуле `[module/network]`, то есть имя текущей WiFi-сети.

Изменён `.config/polybar/config.ini`:
- левый клик запускает `~/.config/i3/scripts/wifi-menu.sh` и показывает сети через Rofi;
- правый клик запускает `nm-connection-editor` для расширенных настроек.

Почему выбран этот вариант: нужный `wifi-menu.sh` уже был в проекте и уже использует установленный NetworkManager (`nmcli`) и Rofi. Новый демон, виджет или зависимость не нужны. Старое действие не удалено, а перенесено на правый клик.

Активный `~/.config/polybar/config.ini` также синхронизирован с репозиторием, поэтому повторный запуск установщика не нужен.

Известное ограничение: текущий `wifi-menu.sh` рассчитан на обычные SSID. Имена с двоеточиями, обратными слешами или служебными фрагментами могут разбираться неверно; профиль NetworkManager с именем, отличным от SSID, также может не активироваться. Для таких сетей остаётся правый клик и `nm-connection-editor`.

### 2. Отдельная раскладка окон на каждом workspace
Добавлен режим `Super + L` в `.config/i3/config`:
- `H` — следующие окна делят контейнер горизонтально (`split h`);
- `V` — вертикально (`split v`);
- `T` — вкладки (`layout tabbed`);
- `S` — стопка (`layout stacking`);
- `A` — переключить горизонтальное/вертикальное деление (`layout toggle split`);
- `Enter` или `Esc` — выйти из режима без изменения.

Как использовать: перейти, например, на workspace 1, нажать `Super + L`, затем `H`; перейти на workspace 2, нажать `Super + L`, затем `T`. i3 хранит отдельное дерево контейнеров для каждого workspace, поэтому их раскладки не смешиваются. Разделение можно дополнительно вкладывать: выбрать окно, задать новый `H` или `V`, затем открыть следующее приложение.

Почему не переносился код из `Hyprland-main`: Hyprland является Wayland-композитором с другим внутренним API, а i3 уже нативно решает эту задачу. Копирование менеджера layout из Hyprland добавило бы несовместимый C++ код и не дало бы результата в X11/i3.

Ограничение выбранного решения: дерево сохраняется при `reload`/`restart` i3, но не после завершения X-сессии. Постоянные шаблоны с заранее назначенными приложениями делаются штатными `i3-save-tree`, `append_layout` и `assign`; они не добавлены, потому что пользователь пока не указал конкретный шаблон и приложения для каждого workspace.

Обновлены подсказки в `.config/i3/scripts/keybindings.sh` и таблица в `README.md`. Активные `~/.config/i3/config` и `~/.config/i3/scripts/keybindings.sh` синхронизированы с репозиторием.

### 3. Исправленные опасные ошибки аудита

#### Idle-lock
В `.xinitrc` было `i3lock -c #2e3440`: символ `#` внутри команды начинал shell-комментарий, и `i3lock` получал `-c` без цвета. Заменено на `i3lock -c 2e3440`. Активный `~/.xinitrc` также синхронизирован.

#### Удаление пользовательских каталогов установщиком
`install.sh` удалял `$HOME/themes` и `$HOME/icons` перед загрузкой тем. Это могло уничтожить не относящиеся к проекту файлы. Теперь репозитории клонируются во временный каталог `mktemp -d`, а удаляется только этот временный каталог.

#### Ошибка установки пакетов скрывалась
Общий вызов `dnf install` заканчивался `|| true`, поэтому установщик продолжал работу даже при полном сбое DNF. `|| true` удалён: ошибка основных пакетов теперь останавливает установку. `--skip-unavailable` по-прежнему отвечает за действительно отсутствующие необязательные пакеты.

#### Опасная установка SDDM по умолчанию
Пустой ответ раньше означал `yes`, хотя текст обещал оставить LightDM. Для SDDM теперь явно используется значение по умолчанию `No` (`[y/N]`). Тема записывается в `/etc/sddm.conf.d/theme.conf`, а не перезаписывает весь `/etc/sddm.conf`. SDDM сначала успешно включается и только затем отключаются другие display manager, чтобы при ошибке не оставить систему без экрана входа.

### 4. Результаты аудита, не изменённые автоматически
Проверены собственные конфиги и скрипты `i3-fedora-ready`. Сторонние шрифты, изображения, lock-файлы и код vendored SDDM-темы не считались авторской логикой. В `Hyprland-main` проверялась только применимость его layout-механизма к запросу; полный аудит большого upstream-проекта Hyprland не выполнялся.

Ниже проблемы, которые требуют отдельного решения или изменения ожидаемого поведения:

1. `install.sh`: backup не охватывает все перезаписываемые файлы, а команда восстановления с `*` не возвращает `.bashrc` и `.xinitrc`.
2. `install.sh`: несколько бинарников и скриптов загружаются из сети без checksum/signature; есть `curl | sh` для Starship.
3. `powermenu.sh` и `control-center.sh`: logout/reboot/shutdown выполняются без второго подтверждения и могут потерять несохранённую работу.
4. `wifi-menu.sh`: разбор `nmcli -t` некорректен для специальных SSID; одинаковые SSID не различаются по BSSID; имя connection profile ошибочно считается равным SSID.
5. Документация сочетаний расходится с конфигом: заявлены `Super+Shift+Q`, bare `Print`, bare `F6`, `Alt+Tab`; перенос на предыдущий/следующий workspace сейчас фактически только переключает workspace; `Super+Shift+Space` в конфиге заменён на `Super+Alt+Space`.
6. `.config/greenclip.toml`: путь жёстко содержит `/home/fedora`; история может сохранять пароли, токены и изображения, blacklist пуст.
7. Установка Greenclip проверяет любой бинарник в `PATH`, но i3 запускает только `$HOME/.local/bin/greenclip`.
8. `.config/polybar/launch.sh`: бесконечный лог пишется в общий `/tmp/polybar.log`; `killall polybar` останавливает и чужие экземпляры пользователя; поиск launcher-процессов слишком широкий.
9. Polybar: WiFi-интерфейс по умолчанию жёстко задан как `wlp2s0`; определение battery/adapter и устройства brightness подходит не всему оборудованию.
10. `reload-safe.sh`: фиксированный `/tmp/i3-config-check.err` допускает symlink-атаку и не удаляется.
11. GTK, xsettingsd и Qt/Kvantum указывают разные темы; theme-toggle ссылается на Catppuccin Kvantum, которого нет в репозитории.
12. `wallpaper.sh` выбирает любой файл, включая неподдерживаемое видео/metadata; выбор через Nitrogen будет заменён случайными обоями при следующем входе.
13. `.bashrc`: используются не гарантированные установщиком `trash`, Starship и Zoxide; путь пользовательских Flatpak начинается с ошибочного `/.local` вместо `$HOME/.local`.
14. Dunst запускается и из `.xinitrc`, и из i3 config; второй процесс не сможет занять notification bus.
15. `.config/i3/autostart.sh` не используется активным config и содержит устаревшие команды.
16. `run-bg.sh` сообщает успех без проверки запуска; `tg-ws-proxy.sh` содержит путь, специфичный для этого компьютера.
17. `welcome.sh` указывает upstream issue URL и неверное сочетание для повторного открытия.
18. `control-center.sh` содержит недостижимый case `Screenshot: to clipboard (area)`, которого нет в меню.
19. `i3-dump-log` в autostart создаёт только снимок при старте, а не непрерывный лог.
20. Совет README про `Available to all users` неточно описывает хранение WiFi-пароля; системный профиль NetworkManager доступен всем пользователям намеренно.

Автоматически эти пункты не изменены, потому что часть из них меняет привычные сочетания, политику безопасности, источники пакетов или поведение сессии. Они зафиксированы для следующего отдельного прохода без скрытого расширения текущей задачи.


## Подготовка исправлений для установки с GitHub (2026-08-01)

После отдельного указания исправлять не только текущую сессию, но и сам устанавливаемый проект, перечисленные выше пункты были обработаны.

### Единый WiFi-модуль без второго значка
- Отдельный белый значок создавал `nm-applet` внутри `[module/tray]`.
- Голубой `󰤨 Famboy` создаёт `[module/network]`; `Famboy` является текущим SSID.
- Автозапуск `nm-applet` удалён из репозитория и активного `~/.config/i3/config`. Пакет `network-manager-applet` оставлен, потому что из него нужен `nm-connection-editor`.
- Вся строка `󰤨 Famboy` явно обёрнута action-тегами Polybar: левая кнопка запускает `wifi-menu.sh`, правая — `nm-connection-editor`. Выбраны явные теги вместо общего `click-left`, чтобы кликабельной гарантированно была и иконка, и название сети.
- В меню левой кнопки есть переключатель WiFi, расширенные настройки и найденные сети.
- Активный `nm-applet` остановлен. NetworkManager работает системным сервисом, поэтому текущее соединение от этого не разрывается.

Первый тест не сработал, потому что `i3-msg reload` не заставил уже запущенный Polybar перечитать обработчики. После `polybar-msg cmd restart` конфигурация перечитана; меню Rofi фактически открылось по нажатию на `󰤨 Famboy`.

### Надёжный разбор WiFi-сетей
`wifi-menu.sh` больше не делит вывод `nmcli -t` простым `IFS=:`. Добавлен разбор экранированных `\:` и `\\`, выбор хранится по числовому индексу, а подключение выполняется по паре SSID/BSSID. Это исправляет SSID с двоеточием, различает точки доступа с одинаковым именем и больше не предполагает, что имя connection profile равно SSID. Для машинного вывода задан `LC_ALL=C`. Добавлен запускаемый self-test `wifi-menu.sh --self-test`.

### Исправления конфигурации
- Добавлены реально заявленные сочетания: bare `Print`, bare `F6`, `Alt+Tab`, `Super+Shift+Q`, `Super+Shift+Space`.
- `Super+Shift+[` и `Super+Shift+]` теперь действительно перемещают контейнер, а не просто переключают workspace.
- Опасные logout/reboot/shutdown подтверждаются второй кнопкой в Rofi.
- `reload-safe.sh` больше не использует предсказуемый файл `/tmp/i3-config-check.err`.
- Удалён неиспользуемый и конфликтующий `.config/i3/autostart.sh`; остаётся один autostart в i3 config.
- Удалён одноразовый снимок `i3-dump-log`, который ошибочно считался непрерывным логированием.
- Dunst больше не запускается второй раз из `.xinitrc`.
- Исправлены проверка запуска `run-bg.sh`, переносимый путь `tg-ws-proxy`, текст welcome и недостижимый case Control Center.
- GTK/xsettingsd согласованы на Adwaita/Papirus; Kvantum использует реально включённый `Nord-Kvantum`.
- `.xprofile` задаёт `QT_QPA_PLATFORMTHEME=qt5ct` и читается при `startx`.
- Обои фильтруются по поддерживаемым расширениям; выбранные Nitrogen/Rofi обои восстанавливаются после входа.
- `.bashrc` проверяет наличие Trash, Starship и Zoxide; исправлен пользовательский Flatpak PATH.
- Невозможный жест `tap 4` удалён; команды libinput-gestures используют абсолютные пути.

### Polybar и оборудование
- Launcher Polybar использует собственный PID-файл в `$XDG_RUNTIME_DIR`, завершает только свой процесс и пишет ограниченный текущим запуском лог в `$XDG_STATE_HOME`.
- Убраны широкий `killall polybar`, небезопасный общий `/tmp/polybar.log` и двойной запуск панели из theme-toggle.
- WiFi-интерфейс, battery, adapter и backlight определяются автоматически; brightness получает конкретное backlight-устройство.

### Greenclip
- Конфиг больше не содержит `/home/fedora`: установщик заменяет `@HOME@` фактическим домашним каталогом.
- Cache изображений перенесён из общего `/tmp` в приватный `~/.cache/greenclip-images`.
- Размер одной записи ограничен 10 MiB; добавлен базовый blacklist менеджеров паролей.

### Безопасность install.sh
- Backup хранит структуру `.config` и home dotfiles отдельно, включая SDDM, Greenclip, libinput-gestures и `.xprofile`; README содержит корректные команды восстановления скрытых файлов.
- Установщик прекращает работу при ошибке DNF, отсутствующих обязательных командах или невалидном i3 config.
- Запрещено молча перезаписывать symlink-конфиги, которые могут вести во внешний dotfiles-репозиторий.
- Временные GTK/icon-клоны больше не используют и не удаляют `$HOME/themes`/`$HOME/icons`.
- SDDM является opt-in `[y/N]`, получает отдельные файлы `90-i3-fedora-*.conf` и включается до отключения других display manager.
- Удалены `curl | sh` для Starship и непроверенная установка eza.
- Nerd Font 3.4.0, Greenclip 4.2 и libinput-gestures commit `2e4cc4c` закреплены по URL и SHA-256. Большие сторонние бинарники удалены из Git-репозитория; изменённый upstream-файл не пройдёт установку.
- Greenclip 4.2 ограничивает установщик архитектурой `x86_64`; ограничение явно записано в README.
- Исправлена проверка `nm-connection-editor` вместо больше не запускаемого `nm-applet`.

### Что синхронизировано в текущую сессию
- Активные i3/Polybar конфиги получили раскладки workspace и единый WiFi-модуль.
- Активный `wifi-menu.sh` обновлён и прошёл self-test.
- `nm-applet` остановлен, i3 и Polybar перечитали конфигурацию.
- Остальные исправления находятся в репозитории и попадут в домашний каталог при следующем запуске `install.sh`; установщик сейчас намеренно не запускался, чтобы без запроса не выполнять DNF и системную настройку SDDM.

### Финальная проверка
- `bash -n` для всех отслеживаемых `*.sh` — OK.
- `sh -n` для `.xinitrc`, `.xprofile`, `i3exit.sh` — OK.
- `wifi-menu.sh --self-test` для репозитория и активного файла — OK.
- `i3 -C` для репозитория и активного `~/.config/i3/config` — OK.
- Polybar 3.7.2 прочитал config и загрузил все 11 модулей — OK. Предупреждение о занятом systray ожидаемо при временном запуске второго тестового Polybar рядом с текущим.
- SHA-256 реально загруженных Nerd Font 3.4.0, Greenclip 4.2 и libinput-gestures `2e4cc4c` совпали с закреплёнными значениями — OK.
- `git diff --check` — OK.
- В текущей сессии: один `polybar main`, один launcher, процессов `nm-applet` нет — OK.
- End-to-end: Rofi-меню сетей открылось нажатием на голубой `󰤨 Famboy` — OK.
- `shellcheck` в системе отсутствует, поэтому он не запускался; его синтаксическую часть покрыла проверка `bash -n`/`sh -n`.


## Защита зрения: жёлтый/белый экран (2026-08-01)

### Решение
Добавлен `.config/i3/scripts/eye-care.sh` с сохранением режима в `~/.config/i3/eye-care-state`:
- `6500K` — нейтральный белый;
- `5000K` — слегка тёплый;
- `4200K` — тёплый режим по умолчанию;
- `3500K` — очень тёплый вечерний режим.

Управление:
- левый клик по существующей лампочке яркости в Polybar открывает меню температуры; новый значок в панель не добавлялся;
- Control Center содержит `Screen color: eye care`;
- `Super + Shift + N` переключает нейтральный и тёплый режим;
- при следующем входе i3 выполняет `eye-care.sh restore` и возвращает сохранённый цвет.

### Почему выбран этот способ
Для X11 предпочтён `redshift`, потому что он корректнее управляет цветовой температурой, чем ручная gamma. Пакет `redshift` добавлен в `install.sh` и проверку обязательных команд. Температура быстрого переключателя калибруется переменной `EYE_CARE_WARM_TEMP` в диапазоне 2500–6500, по умолчанию 4200.

В текущей системе `redshift` ещё не установлен: автоматический `sudo dnf install -y redshift` остановлен, потому что sudo требует интерактивный пароль. Чтобы функция работала сразу, скрипт автоматически использует установленный `xrandr` с приблизительными gamma-пресетами на всех подключённых мониторах. После установки Redshift backend переключится автоматически без изменения конфигурации.

### Синхронизация и проверка
- Скрипт добавлен в репозиторий и активный `~/.config/i3/scripts/` с execute permission.
- Активные i3, Control Center, Polybar и keybindings синхронизированы.
- Текущий экран безопасно сброшен в нейтральный режим.
- `eye-care.sh --self-test` для репозитория и активного файла — OK.
- `bash -n`, `i3 -C` и `git diff --check` — OK.
- `dnf repoquery redshift` нашёл `redshift-1.12-29.fc43.x86_64` в Fedora 43 — OK.

### Отдельный индикатор в Polybar
Первоначально меню было назначено существующей лампочке яркости, поэтому новый элемент визуально не появился. После уточнения добавлен отдельный модуль `[module/eyecare]` рядом с яркостью:
- показывает `󰖨 6500K` для нейтрального режима или выбранную тёплую температуру, например `󰖨 4200K`;
- обновляет значение каждые 2 секунды;
- вся надпись кликабельна и открывает меню температуры;
- существующая лампочка яркости и её проценты остаются отдельным управлением подсветкой.

Активный Polybar перезапущен. Проверено снимком текущего экрана: в верхней панели одновременно видны яркость `50%` и отдельный индикатор `4200K`. Polybar загрузил 12 модулей, включая `eyecare`.


## Постоянное WiFi-меню, сон крышки и Handy → clipboard (2026-08-01)

### План
1. Сделать WiFi-меню многоразовым и закрывать его только явно.
2. Проверить logind/inhibitors, гарантировать lock перед suspend и добавить ручную клавишу сна.
3. Найти реальную версию/конфиг Handy и исправить вывод без второго глобального hotkey.
4. Синхронизировать безопасные изменения с активной X11-сессией.
5. Проверить конфигурации и записать ограничения, особенно требующие root.

### 1. WiFi-меню больше не одноразовое
Проблема: `rofi -dmenu` завершает процесс после любого выбора, а старый `wifi-menu.sh` после действия также делал `exit`. Поэтому после toggle, подключения или настроек меню исчезало.

Решение в `.config/i3/scripts/wifi-menu.sh`:
- список строится заново внутри `while true` после каждого действия;
- добавлен явный пункт `[close]`;
- `-no-click-to-exit` запрещает закрытие кликом снаружи;
- `-kb-cancel "Escape,Super+q"` закрывает меню через `Esc` или `Super+Q` внутри самого Rofi;
- после toggle и подключения список сканируется заново и показывает новое состояние;
- `nm-connection-editor` открывается как отдельное действие, а после его закрытия WiFi-меню возвращается;
- `flock` не разрешает повторным кликом создать несколько одновременно работающих меню.

Почему `Super+Q` задан внутри Rofi: Rofi может использовать override-redirect окно, которого нет в дереве i3. Если полагаться только на i3 `kill`, можно случайно закрыть окно под меню. Собственный `kb-cancel` закрывает именно Rofi.

### 2. Закрытие крышки и ручной suspend
Фактическая проверка текущей системы:
- `/proc/acpi/button/lid/LID/state` существует — крышка определяется, во время проверки была `open`;
- systemd defaults: `HandleLidSwitch=suspend`, `HandleLidSwitchExternalPower=suspend`, `LidSwitchIgnoreInhibited=yes`;
- активные inhibitors NetworkManager, UPower и ModemManager имеют режим `delay`, а не блокируют сон;
- запущенный `xss-lock` зарегистрирован как `sleep / Lock screen first`.

Добавлен проектный файл `etc/systemd/logind.conf.d/90-i3-fedora-lid.conf`:
```ini
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
HandleLidSwitchDocked=suspend
LidSwitchIgnoreInhibited=yes
```

В отличие от defaults, сон также принудительно включён при док-станции. `install.sh` устанавливает drop-in в `/etc/systemd/logind.conf.d/`; эффект гарантирован после перезагрузки.

Добавлено `Ctrl+Alt+S` (`bindcode Ctrl+Mod1+39`). Команда сначала запускает `i3lock`, затем `systemctl suspend -i`. Флаг `-i` означает `--check-inhibitors=no`: приложения не могут отменить ручной сон. Lock встроен в `i3exit.sh`, поэтому ручной путь не зависит только от xss-lock. Hibernate использует такую же последовательность.

Root-drop-in не установлен автоматически в текущую `/etc`, потому что sudo требует пароль. Текущие systemd defaults уже усыпляют обычный ноутбук при закрытии крышки; чтобы явно применить проектное правило, включая docked mode:
```bash
sudo install -Dm644 \
  /home/fedora/Documents/Code/X11/i3-fedora-ready/etc/systemd/logind.conf.d/90-i3-fedora-lid.conf \
  /etc/systemd/logind.conf.d/90-i3-fedora-lid.conf
sudo reboot
```

Нюанс принудительного `Ctrl+Alt+S`: приложения и сетевые операции будут заморожены без запроса. Это именно запрошенное поведение «минуя приложения»; несохранённая память не удаляется, но suspend не заменяет сохранение файлов и не является hibernate.

### 3. Handy: toggle-запись и буфер обмена
Найдена установленная версия `handy-0.8.3-1.x86_64`, процесс `/usr/bin/handy` и конфиг `~/.local/share/com.pais.handy/settings_store.json`.

До исправления:
- `Ctrl+Space` уже был нативным global shortcut;
- `push_to_talk=false` уже давал требуемый toggle: первое нажатие начинает, второе останавливает запись;
- `clipboard_handling=dont_modify` запрещал класть результат в буфер;
- `paste_method=direct` пытался автоматически печатать через `ydotool`;
- Handy log многократно содержал `Failed to paste transcription: ydotool failed`.

По исходникам именно Handy v0.8.3 подтверждены допустимые значения `paste_method=none` и `clipboard_handling=copy_to_clipboard`. Активный конфиг изменён на них. Теперь после расшифровки Handy не эмулирует клавиатуру, а оставляет текст в clipboard для ручного `Ctrl+V`/физической клавиши `М` в русской раскладке.

Создан `.config/i3/scripts/configure-handy.sh`:
- сохраняет первый backup как `settings_store.json.before-i3-fedora`;
- меняет только binding, toggle mode, paste method и clipboard handling;
- сохраняет модель, язык, историю и API-параметры;
- останавливает Handy перед записью, чтобы старый процесс не вернул прежний config;
- после изменения перезапускает Handy скрытым, только если он был запущен;
- при неизвестной/изменённой JSON-схеме завершается до замены оригинала.

`install.sh` автоматически вызывает configurator, если Handy установлен и уже хотя бы раз запускался. Сам Handy не добавлен в autostart. В i3 намеренно нет binding для `Ctrl+Space`: hotkey регистрирует само Handy, поэтому после закрытия приложения сочетание освобождается, как и требовалось.

Старый `~/.config/hypr/scripts/handy-clipboard.sh` не используется: он бесконечно опрашивает SQLite и вызывает Wayland-команду `wl-copy`, тогда как текущая сессия — X11. Процесс этого скрипта не был запущен; файл вне i3-проекта не удалялся.

### 4. Greenclip и приватность диктовок
Handy/handy добавлены в `blacklisted_applications` Greenclip. Это не мешает обычному clipboard и `Ctrl+V`, но просит Greenclip не сохранять диктовки в историю. Активный cache изображений перенесён из общего `/tmp` в приватный `~/.cache/greenclip-images`, daemon перезапущен.

Ограничение: некоторые X11-приложения не сообщают владельцу clipboard своё имя. Поэтому blacklist является best effort; чувствительный текст всё равно не следует надолго оставлять в clipboard.

### 5. Проверка
- `bash -n`/`sh -n` для изменённых и всех отслеживаемых shell-скриптов — OK.
- `wifi-menu.sh --self-test` для проекта и активного файла — OK.
- Rofi 2.0.0 поддерживает `-no-click-to-exit` и `-kb-cancel` — OK.
- `i3 -C` для проекта и активного config — OK.
- `systemctl --help` подтверждает `-i = --check-inhibitors=no` — OK.
- Configurator Handy проверен сначала на копии JSON с assert по четырём полям — OK.
- Активный Handy перезапущен как `handy --start-hidden`; `autostart_enabled` остался `false` — OK.
- Активные значения: `ctrl+space`, `push_to_talk=false`, `paste_method=none`, `clipboard_handling=copy_to_clipboard` — OK.
- `xdotool` в системе отсутствует. Он больше не требуется Handy, потому что автоматическая эмуляция ввода отключена.
- Реальный suspend намеренно не запускался во время работы, чтобы не оборвать текущую сессию; проверены config, lid device, inhibitors и синтаксис команды.

## Видимое layout-меню, понятный lock screen и Chrome/KWallet (2026-08-01)

### 1. Видимый выбор layout
Старый скрытый i3 mode на физической клавише `Super+L`/`Super+Д` заменён на `.config/i3/scripts/layout-menu.sh`. Rofi прямо показывает варианты для текущего workspace: горизонтальный/вертикальный split, вкладки, стопка, обычный tiling и смена направления. Выбор преобразуется в одну команду `i3-msg`; `Esc` и `Super+Q` закрывают меню без изменения layout.

Почему используется `bindcode $mod+46`: X11 подтвердил, что keycode 46 — это одна физическая клавиша `L` в EN и `Д` в RU. Поэтому shortcut не зависит от текущей раскладки.

### 2. Lock screen вместо необъяснённого круга
Создан единый `.config/i3/scripts/lock-screen.sh`, который используется ручной блокировкой, автоматическим timeout и `xss-lock` перед suspend:
- основной backend — Fedora-пакет `xsecurelock`: отдельный безопасный auth-процесс, время/дата, username, раскладка, видимый ввод и сообщение об ошибочном пароле;
- Nord-цвета и JetBrainsMono Nerd Font согласованы с остальным desktop;
- из-за известной несовместимости Picom отключён только дополнительный `XSECURELOCK_COMPOSITE_OBSCURER`, а не основное защитное окно;
- если пакет ещё не установлен, ImageMagick создаёт 1920×1080 (или текущий размер XRandR) экран с размытым wallpaper, временем, датой, текстом «Сеанс заблокирован», инструкцией, подсказкой раскладки и `Esc`;
- fallback запускает `i3lock -n -e -f -k`: остаются PAM, видимый статус проверки/ошибки, число неудачных попыток и текущая раскладка.

`i3exit.sh` теперь просит уже работающий `xss-lock` заблокировать экран через `xset s activate`, ждёт появления `xsecurelock`/`i3lock` до 5 секунд и только затем выполняет suspend/hibernate. Если `xss-lock` не запущен, тот же launcher стартует напрямую. Это не допускает последовательность «сначала сон, потом попытка lock».

i3 устанавливает X11 screensaver timeout 10 минут и запускает ровно один `xss-lock --transfer-sleep-lock -- lock-screen.sh`. Дублирующий `xautolock` удалён из `.xinitrc`, потому что два независимых locker-процесса могут конфликтовать. Активный `xss-lock` перезапущен через i3 и снова зарегистрировал inhibitor `sleep / Lock screen first / delay`.

`xsecurelock` добавлен в `install.sh` вместе с ImageMagick. В текущей системе пакет пока не установлен, потому что `sudo` требует интерактивный пароль; поэтому сразу работает описанный полноценный fallback. После следующего запуска installer backend переключится автоматически.

### 3. Почему Chrome терял Google-сессии
Проверено без чтения cookies, паролей, токенов и содержимого сайтов:
- Chrome использует постоянный каталог `~/.config/google-chrome`, не временный профиль;
- настройки профилей не требуют очищать cookies при выходе;
- SDDM PAM уже запускает и разблокирует KWallet (`ksecretd --pam-login` активен);
- в Chrome `Local State` было `os_crypt.portal.prev_desktop=i3` и `prev_init_success=false`;
- вручную запущенный из i3 `gnome-keyring-daemon --start --components=secrets` не мог подключиться к `/run/user/1000/keyring/control`, а `~/.local/share/keyrings` был пуст.

Корень проблемы — не очистка Chrome, а неуспешная инициализация Secret portal, из-за которой после нового входа браузер не получал прежний ключ шифрования cookies.

Добавлен `.config/xdg-desktop-portal/i3-portals.conf`:
```ini
[preferred]
default=gtk
org.freedesktop.impl.portal.Secret=kwallet
```
Остальные desktop portals остаются на GTK, а только Secret направлен в существующий постоянный KWallet. Конфликтующий ручной запуск GNOME Keyring удалён из i3 и остановлен в текущей сессии. Небезопасный `--password-store=basic` намеренно не использован.

В `.xprofile` явно экспортируются `XDG_CURRENT_DESKTOP=i3` и `XDG_SESSION_DESKTOP=i3`, затем передаются в D-Bus/user-systemd. Это необходимо: при первой проверке shell знал текущий desktop, но окружение user-systemd не содержало этих переменных, и portal выбирал GTK лишь как last-resort fallback вместо чтения `i3-portals.conf`.

В `install.sh` явно добавлены `xdg-desktop-portal`, GTK/KDE backends и `kf6-kwallet`. Активный portal перезапущен; frontend и GTK backend находятся в `active`, KWallet экспортирует `org.freedesktop.impl.portal.Secret.RetrieveSecret`, а PAM-процесс KWallet продолжает работать.

Ожидаемое поведение: после следующего запуска Chrome и одного входа в Google новая cookie будет зашифрована ключом из KWallet и сохранится после следующих перезагрузок. Старые cookies, созданные при сломанном backend, могут потребовать однократный повторный вход; их принудительное преобразование или удаление не выполнялось.

### 4. Проверка и применение
- `lock-screen.sh --preview` создал приватный PNG 1920×1080; изображение визуально проверено: текст и контраст читаемы, центр оставлен под динамический PAM-индикатор.
- Для lock-изображения установлен `umask 077`, поэтому временный файл доступен только владельцу сессии.
- `bash -n`/`sh -n` для installer, `.xinitrc`, `.xprofile` и всех i3 shell-скриптов — OK.
- `layout-menu.sh --self-test` для проекта и активной копии — OK.
- `i3 -C` для проекта и активной конфигурации — OK; активный i3 успешно reload.
- Активные `lock-screen.sh`, `i3exit.sh`, `layout-menu.sh` и portal config побайтно совпадают с проектом; execute permissions установлены.
- X11 screensaver показывает `timeout: 600`, `cycle: 10` — OK.
- В текущей сессии работает ровно один новый `xss-lock`; systemd inhibitor подтверждает `Lock screen first / delay` — OK.
- После импорта desktop environment portal перезапущен без fallback warnings; user-systemd содержит обе i3-переменные — OK.
- `xdg-desktop-portal` и GTK backend активны, KWallet Secret interface доступен, конфликтующего `gnome-keyring-daemon` больше нет — OK.
- `ksecretd` одновременно владеет `org.freedesktop.impl.portal.desktop.kwallet` и стандартным `org.freedesktop.secrets`; коллекция последнего указывает на `/org/freedesktop/secrets/collection/kdewallet`. Значит, один KWallet обслуживает и portal-клиенты, и обычные приложения на libsecret — OK.
- Уже запущенный до исправления Chrome всё ещё показывает `os_crypt.portal.prev_init_success=false`; это ожидаемо до полного завершения всех фоновых процессов Chrome и нового запуска. Значение не подменялось вручную.
- `git diff --check` — OK.
- Реальные lock, suspend и reboot намеренно не запускались: preview и цепочка процессов проверены без прерывания работы; сохранение новой Google-cookie окончательно подтверждается только следующим входом в Chrome и последующей перезагрузкой.

## Авторазблокировка KWallet, Alt+Tab и понятное меню питания (2026-08-01)

### KWallet
Сообщение `Error code -9: Read error - possibly incorrect password` проверено без чтения значений сохранённых секретов. SDDM уже подключает `pam_kwallet5.so`/`pam_kwallet.so`, пакет `pam-kwallet` установлен, а журнал входа подтверждает успешные `pam_sm_authenticate` и `pam_sm_open_session`. PAM создал `/run/user/1000/kwallet5.socket` и процесс `ksecretd --pam-login`, то есть пароль входа был безопасно сохранён внутри процесса PAM, а не в файле.

Найдена недостающая часть цепочки: Plasma запускает hidden-autostart `/usr/libexec/pam_kwallet_init`, который соединяет desktop с PAM socket. i3 не запускает XDG autostart-файлы через `dex`, поэтому socket оставался неподключённым и `ksecretd`, запущенный позднее через D-Bus, спрашивал пароль отдельно. В i3 autostart добавлен штатный `pam_kwallet_init`; он только передаёт уже полученные PAM credentials через приватный socket и не хранит/не печатает пароль.

Существующий `~/.local/share/kwalletd/kdewallet.kwl` содержит используемые записи для браузеров, сетей, SSH и приложений, поэтому не удалялся и не пересоздавался. Пользователь подтвердил, что пароль wallet должен совпадать с паролем учётной записи. Окончательная проверка выполняется после свежего logout/login: если `Error code -9` повторится уже с ранним `pam_kwallet_init`, остаются два варианта — реальный password mismatch или повреждение wallet. Reset допустим только после явного согласия на потерю записей.

В `install.sh` добавлен явный пакет `pam-kwallet`, чтобы авторазблокировка воспроизводилась на новой установке.

Во время безопасной проверки метаданных обнаружена старая GitHub-запись, в имени которой credential был помещён прямо в URL. Само значение не переносилось в конфиги или этот лог. Такой token следует отозвать в GitHub и создать новый; после открытия wallet старую запись нужно удалить через KWalletManager.

### Alt+Tab для всех окон
Активная i3-конфигурация фактически не содержала ранее задокументированный `Alt+Tab`. Binding добавлен в проект и текущий `~/.config/i3/config`:
```text
rofi -show window -show-icons -window-thumbnail -window-format "{w}  {c}  {t}"
```
Режим `window`, в отличие от `windowcd`, получает окна со всех workspace. Список показывает workspace, класс, title, иконку и доступный thumbnail; выбор просит i3 сфокусировать окно, поэтому i3 автоматически переходит на другой workspace/monitor. Управление: стрелки/мышь, `Enter` — выбрать, `Esc` — отменить.

### Power menu
Пять английских неоднозначных пунктов заменены прямыми русскими действиями: «Заблокировать экран», «Выйти из сеанса», «Перейти в сон», «Перезагрузить», «Выключить». Произвольный ввод запрещён через `-no-custom`, `Esc` и `Super+Q` безопасно закрывают меню. Активный скрипт также синхронизирован с проектом: исправлен theme path и `echo -e` заменён на предсказуемый `printf`.

### Исправление Super+L / Super+Д
Причина нестабильного layout-переключения была в команде без criteria: `i3-msg split/layout` применял её к родителю случайно сфокусированного окна. При вложенных split-контейнерах это меняло разный уровень дерева, могло визуально ничего не сделать или создать ещё одну обёртку.

`layout-menu.sh` теперь читает текущий i3 tree, находит сфокусированный workspace и выбирает первый уровень, который реально содержит несколько tiled-окон. Команда отправляется адресно как `[con_id=<target>] split/layout`; выбор больше не зависит от окна, которое имело focus. Физический `bindcode 46` сохранён, поэтому одна клавиша работает как `Super+L` в EN и `Super+Д` в RU.

### Проверка
- Окружение текущего процесса i3 содержит `PAM_KWALLET5_LOGIN`, socket существует и принадлежит пользователю — штатный `pam_kwallet_init` сможет выполнить handoff при старте i3.
- Ручной запуск `pam_kwallet_init` перевёл владение `org.freedesktop.secrets` и KWallet portal от позднего D-Bus-процесса к PAM-процессу `ksecretd` — цепочка подключения работает.
- Текущий wallet оставлен locked до свежего logout/login: пароль не передавался через командную строку, а разрушительный reset не выполнялся.
- Алгоритм layout target проверен на текущем i3 tree; адресная команда `[con_id=...] split h` принята i3 с `success=true`.
- `layout-menu.sh --self-test`, `bash -n`, обе проверки `i3 -C`, обе Rofi-темы и `git diff --check` — OK.
- Активный i3 успешно reload; новый `Alt+Tab`, русское power menu и исправленный `Super+L` находятся в загруженной конфигурации.

## Гарнитура, тачпад/жесты и Telegram media (2026-08-01)

### Микрофон гарнитуры
Звуковая карта Intel HDA/Realtek ALC256 публикует один PipeWire source с портами `analog-input-headset-mic` и `analog-input-internal-mic`. Оба имеют `availability unknown`, поэтому стандартный selector не может надёжно переключить их, но аппаратный ALSA control `Headphone Jack` корректно сообщает `on/off`.

Старый `~/.config/wireplumber/main.lua.d/51-headset-mic.lua` не работал: WirePlumber 0.5/1.4 больше не поддерживает Lua-конфиги и писал об игнорировании файла в journal. Он удалён из активной системы. Installer теперь сначала сохраняет `~/.config/wireplumber` в backup, затем удаляет только этот известный устаревший файл.

Создан `.config/i3/scripts/audio-port-autoswitch.sh`. Он один раз синхронизирует port, затем ждёт аппаратные события через `alsactl monitor` без постоянного polling. При вставленном штекере выбирается headset mic, при извлечённом — internal mic; `flock` исключает дубликаты. Для другого hardware доступны `AUDIO_CARD`, `AUDIO_SOURCE`, `HEADSET_MIC_PORT`, `INTERNAL_MIC_PORT`. Скрипт, `alsa-utils` и `pulseaudio-utils` добавлены в проект/installer/i3 autostart.

Физический тест без pavucontrol пройден пользователем: извлечение вернуло микрофон ноутбука, повторное подключение выбрало микрофон гарнитуры.

### Тачпад и жесты
Kernel, udev, libinput и Xorg корректно видят `ELAN1200:00 04F3:303E Touchpad` на `/dev/input/event6`; XInput device был enabled, но `libinput Tapping Enabled=0`. Новый `.config/i3/scripts/touchpad.py` через `python3-xlib` на каждом входе включает устройство и tap-to-click независимо от динамического device id. В текущей сессии обе properties равны `1`, пользователь подтвердил работу курсора и tapping.

Жесты не запускались из-за рассинхронизации: активный config содержал неподдерживаемый `gesture tap 4`, и `libinput-gestures` завершался при parse. Строка удалена, активный config синхронизирован с проектом. Жесты: 3 пальца left/right — workspace, up — окно Rofi со всех workspace, down — scratchpad; pinch двумя пальцами — volume. Доступ к event6 есть через группу `input`; daemon запущен и держит `libinput-debug-events --device /dev/input/event6`.

Во время диагностики ключ `libinput-gestures -l` вызвал внешний setup status, который удалил standalone binary. Он сразу восстановлен из закреплённого commit `2e4cc4c` после проверки ожидаемого SHA-256; installer уже делает такую же проверенную установку и не вызывает setup helper.

### Telegram
Telegram установлен как Flatpak `org.telegram.desktop` 7.0.6. Симптом — mapped i3 container остаётся, но Qt-окно перестаёт перерисовываться после фото/видео. История coredump также содержит `SIGSEGV` `/app/bin/Telegram`; Picom использует GLX на Intel UHD 620. Это соответствует конфликту Qt XCB OpenGL/media surface с compositor, а не правилу opacity: `_NET_WM_WINDOW_OPACITY` у Telegram отсутствует.

Применён только для Telegram Flatpak override `QT_XCB_GL_INTEGRATION=none`. Основной интерфейс использует стабильный X11 raster path; Picom GLX и ускорение других приложений не отключаются. Та же условная команда добавлена в `install.sh`, если Telegram Flatpak установлен.

### Финализация
- В `libinput-gestures.conf` заданы `swipe_threshold 300` и `timeout 0.9` (дефолты 0 и 1.5): жест срабатывает быстрее без длинного движения.
- Важно: любой вызов `libinput-gestures-setup` (start/stop/status, а также `libinput-gestures -l`) удаляет `~/.local/bin/libinput-gestures` как «старую установку». Проверку состояния делать только через `pgrep -af libinput-gestures`.
- Daemon перезапущен после тюнинга: один `python3 libinput-gestures` + один `libinput-debug-events --device /dev/input/event6`.
- Активный `~/.config/i3/config` синхронизирован в проект целиком (включая захват i3-лога и поведение Super+Shift+bracket).
- `__pycache__` от py_compile удалён из проекта.
- `i3 -C`, `bash -n install.sh`, `git diff --check` — OK.

## План на будущее

### Безопасное извлечение всего, что вошло в порты / интеграции
Сейчас custom-скрипты глубоко вросли в систему: `audio-port-autoswitch.sh` слушает ALSA, `touchpad.py` правит XInput, `pam_kwallet_init` соединяется с KWallet socket, Telegram override висит в Flatpak, lid-suspend в `logind.conf.d`, `xss-lock` регистрирует inhibitor. Если пользователь переезжает на новую машину или хочет откатить — каждое звено нужно вспомнить отдельно.

Запланировать отдельный скрипт `scripts/safe-extract.sh` (или подкоманду `install.sh extract`/`install.sh snapshot`), который за один проход собирает:
- активный i3 config и diff против проектного;
- все скрипты из `~/.config/i3/scripts/`;
- KWallet-структуру (только названия коллекций и ключей, **без значений**);
- список active Flatpak overrides (`flatpak override --user --show`);
- `loginctl show-user`/`loginctl show-session` для lid-switch;
- версии пакетов (`rpm -q i3 polybar picom xsecurelock ...`).

Назначение:
1. `install.sh snapshot` — делает tar-архив всех правок пользователя, безопасный для хранения в незашифрованном виде.
2. `install.sh diff` — показывает только отклонения от проектной копии, чтобы понять, что именно «ушло в порты».
3. `install.sh restore <archive>` — применяет сохранённый snapshot на чистую Fedora.

Жёсткие требования:
- Никогда не сохранять значения KWallet, cookies, токены, пароли.
- Использовать `umask 077` для любых временных файлов.
- Не модифицировать секреты: только описывать структуру.

Приоритет низкий — делать после `xsecurelock` → `i3lock` переход и автоматической смены KWallet пароля, чтобы скрипт точно покрывал стабильное состояние.
