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


