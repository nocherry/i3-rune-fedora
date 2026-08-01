<div align="center">

# 🪟 i3wm — Fedora Adaptation

**Воспроизводимый Nord-i3/X11 десктоп для Fedora: RU/EN-безопасные keycodes, ощущение Hyprland.**

<p>
  <a href="./README.md"><img alt="English" src="https://img.shields.io/badge/README-English-blue?style=for-the-badge"></a>
  <a href="./README.ru.md"><img alt="Русский" src="https://img.shields.io/badge/README-Русский-red?style=for-the-badge"></a>
</p>

<p>
  <img alt="i3" src="https://img.shields.io/badge/i3-gaps-2e3440?style=for-the-badge&logo=i3&logoColor=eceff4">
  <img alt="Fedora" src="https://img.shields.io/badge/Fedora-43-294172?style=for-the-badge&logo=fedora&logoColor=eceff4">
  <img alt="Nord" src="https://img.shields.io/badge/theme-Nord-88c0d0?style=for-the-badge">
  <img alt="PipeWire" src="https://img.shields.io/badge/audio-PipeWire-5e81ac?style=for-the-badge">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge">
</p>

<sub>Закреплено: Greenclip <code>v4.2</code>, libinput-gestures <code>2e4cc4c</code>, JetBrainsMono Nerd Font <code>v3.4.0</code> — все бинари и ассеты проверены по SHA-256 при установке.</sub>

</div>

---

## 📚 Содержание

- [🎯 Зачем этот проект](#-зачем-этот-проект)
- [✨ Возможности](#-возможности)
- [📸 Скриншоты](#-скриншоты)
- [⚡ Быстрый старт](#-быстрый-старт)
- [🧰 Что устанавливается](#-что-устанавливается)
- [🖱️ Горячие клавиши](#️-горячие-клавиши)
- [🎨 Что вы увидите](#-что-вы-увидите)
- [⚙️ Как это работает](#️-как-это-работает)
- [🛠️ Повседневное использование](#️-повседневное-использование)
- [🐞 Решение проблем](#-решение-проблем)
- [🤝 Благодарности](#-благодарности)

---

<a id="-зачем-этот-проект"></a>

## 🎯 Зачем этот проект

Если вы пробовали перенести Arch-i3 в Fedora, то знакомы с этими проблемами:

- 🔠 **Буквенные шорткаты умирают при смене раскладки.** `Super+Q` в английской закрывает окно, а в русской делает что-то совсем другое. Здесь каждое буквенное сочетание привязано через физический keycode — одна и та же клавиша запускает одно и то же действие независимо от `us`/`ru` или любой другой XKB-раскладки.
- 🪟 **Голый i3lock — чёрная дыра.** Кофе-пауза не должна требовать туториала. `lock-screen.sh` показывает время, дату, подсказку раскладки и инструкции, а если установлен `xsecurelock` — использует его.
- 🎙️ **Распознавание гарнитуры ненадёжно.** Стандартный PipeWire не понимает, что вы только что вставили штекер. `audio-port-autoswitch.sh` следит за реальным ALSA-сигналом jack и переключает input в реальном времени.
- 💤 **Закрытие крышки иногда оставляет экран включённым, иногда усыпляет ноутбук.** Один drop-in в `logind.conf.d` делает сон на крышке одинаковым от батареи, от розетки и в док-станции.
- 🌐 **Chrome забывает Google-сессии после перезагрузки.** Маленький `xdg-desktop-portal/i3-portals.conf` направляет Secret в KWallet, и ключ шифрования сохраняется.
- 🖐️ **Тачпад выглядит мёртвым.** `libinput Tapping Enabled` выключен по умолчанию на многих ноутбуках. `touchpad.py` через `python3-xlib` включает его при каждом входе — пакет `xinput` не нужен.
- 🟣 **Telegram становится невидимым после медиа в Picom GLX.** Per-Flatpak override `QT_XCB_GL_INTEGRATION=none` чинит Qt OpenGL, не трогая остальной desktop.
- 🔄 **i3 config расходится между проектом и активной копией.** Перед reload всегда вызывается `i3 -C`; проектная копия — единственный источник истины.

Все правки и решения упакованы в один `install.sh` — **идемпотентный**, **безопасный** (каждый шаг с `--skip-unavailable` или guard), и **закреплённый по SHA-256** для всех сторонних бинарей.

---

<a id="-возможности"></a>

## ✨ Возможности

| Область | Что получаете |
|---|---|
| 🪟 **Оконный менеджер** | i3-gaps с Nord-цветами, 2px границы, умные внутренние/внешние gaps, скруглённые углы 10px |
| 🔤 **Клавиатура** | Каждое буквенное сочетание — `bindcode`, работает на US, RU и любой XKB-раскладке |
| 📊 **Polybar** | Workspaces, трей приложений, громкость, яркость (клик открывает eye-care), CPU, RAM, батарея с авто-детектом `BAT0`/`AC0`, Wi-Fi (кликабельно), дата |
| 🚀 **Rofi** | Nord launcher с apps, run, window, filebrowser, clipboard, keybindings, powermenu, control center, eye-care |
| 🌫️ **Picom** | GLX backend с тенями, fade, blur (dual-kawase), скруглёнными углами, анимацией смены фокуса |
| 🔔 **Dunst** | Nord-цвета, `follow = mouse`, height-clamped |
| 🖥️ **Терминал** | Kitty с Catppuccin Mocha, padding, прозрачность, вкладки |
| 🔐 **Lock screen** | `xsecurelock` (предпочтительно) с датой, временем, именем пользователя, раскладкой и PAM-обратной связью; fallback на `ImageMagick` + `i3lock` если пакет не установлен |
| 🎙️ **Аудио** | Автоматическое переключение headset/internal mic по ALSA-событиям jack; PipeWire/WirePlumber стек |
| 🛌 **Suspend** | Закрытие крышки и ручной `Ctrl+Alt+S` идут через `xss-lock`, экран блокируется **до** systemd-suspend |
| 🖐️ **Тачпад** | Tap-to-click на каждом входе; трёхпальцевые жесты — workspace/window switcher/scratchpad; pinch — громкость |
| 💼 **Chrome-сессии** | XDG Secret portal направлен в KWallet; `pam_kwallet_init` разблокирует кошелёк при входе без сохранения пароля |
| 🟣 **Telegram** | Flatpak override отключает Qt OpenGL XCB — окно остаётся видимым под Picom |
| 🪟 **Window switcher** | `Alt+Tab` показывает окна со всех workspace с иконкой, номером workspace, классом и заголовком |
| ⚡ **Power menu** | Русские, явные действия: Заблокировать экран / Выйти из сеанса / Перейти в сон / Перезагрузить / Выключить |
| 🔌 **Clipboard** | Greenclip daemon, изображения кешируются в `~/.cache/greenclip-images` (приватно), автоматический blacklist для диктовок Handy |
| 🛡️ **Polkit** | Авто-детект `lxqt-policykit-agent` (уже установлен) с fallback на `polkit-gnome` |
| 🎨 **Темы** | Nord для GTK3/Qt5/Qt6/Kvantum/Sweet/Adwaita, иконки Papirus |
| 🖼️ **Обои** | Клонирует [harilvfs/wallpapers](https://github.com/harilvfs/wallpapers), выбирает случайную на каждую сессию с бандлованным fallback |

---

<a id="-скриншоты"></a>

## 📸 Скриншоты

Все скриншоты сделаны на живом desktop с реальной Fedora 43 — без мокапов.

### 🖥️ Рабочий стол

> Polybar со всеми модулями (workspaces, трей, яркость, eye-care 3500K, громкость, Wi-Fi, CPU 4%, батарея 37%), Nord-тема, японский пейзаж из <code>harilvfs/wallpapers</code>.

<p align="center">
  <img src="docs/screenshots/01-desktop.png" alt="Чистый i3 desktop с полным Polybar" width="100%">
</p>

### 🚀 Встроенные меню и диалоги

> Все Rofi-меню используют Nord-тему проекта с иконками Papirus. Клик по картинке открывает её в полном размере.

<table>
  <tr>
    <td align="center" width="50%"><b>🚀 Лаунчер — <code>Super + D</code></b><br><img src="docs/screenshots/02-launcher.png" alt="Rofi-лаунчер"></td>
    <td align="center" width="50%"><b>🔐 Меню питания — <code>Ctrl + Alt + P</code></b><br><img src="docs/screenshots/03-power-menu.png" alt="Русское меню питания"></td>
  </tr>
  <tr>
    <td align="center" width="50%"><b>⚙️ Control center — <code>Super + \`</code></b><br><img src="docs/screenshots/04-control-center.png" alt="Быстрые переключатели"></td>
    <td align="center" width="50%"><b>🪟 Меню тайлинга — <code>Super + L</code> / <code>Super + Д</code></b><br><img src="docs/screenshots/05-layout-menu.png" alt="Выбор тайлинга для workspace"></td>
  </tr>
  <tr>
    <td align="center" width="50%"><b>↔️ Window switcher — <code>Alt + Tab</code></b><br><img src="docs/screenshots/06-window-switcher.png" alt="Window switcher по всем workspace"></td>
    <td align="center" width="50%"><b>🔒 Экран блокировки — <code>Ctrl + Alt + L</code></b><br><img src="docs/screenshots/07-lock-screen.png" alt="Nord-экран блокировки"></td>
  </tr>
</table>

---

<a id="-быстрый-старт"></a>

## ⚡ Быстрый старт

```bash
git clone https://github.com/nocherry/i3-rune-fedora.git
cd i3-rune-fedora
./install.sh
# выйдите из сессии, выберите «i3» в SDDM (или LightDM), войдите.
```

Готово. Installer делает backup вашего `~/.config`, ставит все зависимости через `dnf`, скачивает pinned JetBrainsMono Nerd Font с SHA-256 проверкой, копирует все конфиги, ставит `logind` drop-in для крышки и валидирует `i3 -C`.

> **Нужен passwordless sudo** для шага `dnf install`. Если sudo не настроен, выполните `su -` и запустите `./install.sh` под root в домашней директории пользователя (или поставьте пакеты заранее).

---

<a id="-что-устанавливается"></a>

## 🧰 Что устанавливается

Installer ставит эти Fedora-пакеты (плюс `--skip-unavailable` для отсутствующих):

<details>
<summary><b>Развернуть полный список пакетов</b></summary>

```
i3 polybar rofi picom dunst kitty thunar feh nitrogen
network-manager-applet blueman pavucontrol pulseaudio-utils alsa-utils
brightnessctl redshift maim flameshot playerctl
xorg-x11-server-Xorg xorg-x11-xinit xrandr xset xsetroot
gnome-keyring gnome-settings-daemon lxqt-policykit
xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde
kf6-kwallet pam-kwallet
neovim btop fastfetch fish zoxide eza starship yad xclip xss-lock
xsecurelock i3lock ImageMagick trash-cli libinput-utils
nwg-look qt5ct qt6ct kvantum
jetbrains-mono-fonts-all google-noto-emoji-fonts google-noto-color-emoji-fonts
fontawesome-fonts papirus-icon-theme
python3 python3-xlib unzip curl git
```

Плюс `logind.conf.d` drop-in для крышки, и эти user-level установки:

- `~/.local/bin/greenclip` — pinned v4.2 (SHA-256 проверен)
- `~/.local/bin/libinput-gestures` — pinned commit `2e4cc4c` (SHA-256 проверен)
- `~/.local/share/fonts/JetBrainsMonoNerd/` — JetBrainsMono Nerd Font v3.4.0

</details>

### Структура проекта

```
i3-fedora-ready/
├── install.sh                          # одноразовый installer
├── README.md                           # English (база)
├── README.ru.md                        # этот файл
├── PRODUCT.md                          # продуктовый register
├── LOG.md                              # каждое решение с доказательствами
├── etc/
│   └── systemd/logind.conf.d/
│       └── 90-i3-fedora-lid.conf       # крышка → сон
└── .config/
    ├── i3/
    │   ├── config                      # основной i3 config
    │   └── scripts/                    # 20+ shell + python помощников
    │       ├── i3exit.sh               # lock/logout/suspend/reboot/shutdown
    │       ├── lock-screen.sh          # xsecurelock + ImageMagick fallback
    │       ├── audio-port-autoswitch.sh# ALSA jack → mic source
    │       ├── touchpad.py             # python3-xlib enable tap
    │       ├── powermenu.sh            # Ctrl+Alt+P
    │       ├── control-center.sh       # быстрые переключатели
    │       ├── layout-menu.sh          # выбор тайлинга для workspace
    │       ├── eye-care.sh             # цветовая температура
    │       ├── theme-toggle.sh         # dark/light
    │       ├── wallpaper.sh            # случайные обои
    │       ├── wifi-menu.sh            # постоянное rofi-меню
    │       ├── configure-handy.sh      # настройка voice-to-text
    │       └── …
    ├── polybar/                        # Nord-панель
    ├── rofi/                           # Nord-темы и per-mode темы
    ├── picom/                          # GLX скруглённый blur
    ├── dunst/                          # Nord-уведомления
    ├── kitty/                          # Catppuccin Mocha
    ├── xdg-desktop-portal/
    │   └── i3-portals.conf             # маршрут Secret → KWallet
    ├── nvim tmux zellij fastfetch
    ├── gtk-3.0 Kvantum qt5ct qt6ct xsettingsd
    ├── fish starship
    └── libinput-gestures.conf          # 3 пальца workspace + pinch volume
```

---

<a id="-️-горячие-клавиши"></a>

## 🖱️ Горячие клавиши

> Каждая буквенная клавиша привязана через физический **keycode**, поэтому один и тот же шорткат работает на US, RU и любой другой XKB-раскладке. `Super+Q` всегда `Super+Q`.

### 🚀 Приложения и лаунчер

| Шорткат | Действие |
|---|---|
| `Super + D` | App launcher (Rofi с иконками) |
| `Super + Shift + D` | Переключить тёмную/светлую тему |
| `Super + Shift + N` | Переключить тёплый/нейтральный eye-care цвет |
| `Super + Shift + \`` | История clipboard (Greenclip + Rofi) |
| `Super + Enter` | Терминал (Kitty) |
| `Super + E` | Файловый менеджер (Thunar) |
| `Super + B` | Браузер |
| `Super + \`` | Control center (яркость, сеть, аудио, eye-care) |

### 🪟 Управление окнами

| Шорткат | Действие |
|---|---|
| `Super + Q` | Закрыть активное окно |
| `Super + Shift + Q` | Закрыть активное окно (дополнительный) |
| `Super + F` | Полноэкранный |
| `Super + Shift + F` | Полноэкранный глобально |
| `Super + Space` | Переключить floating |
| `Super + Shift + Space` | Включить floating для активного |
| `Super + L` / `Super + Д` | Per-workspace меню тайлинга (горизонтальный/вертикальный/вкладки/стопка/обычный) |
| `Super + R` | Resize mode |
| `Super + Shift + G` | Gaps mode |
| `Alt + Tab` | Window switcher по **всем** workspace |
| `Super + U` / `Super + Shift + U` | Scratchpad show / move |
| `Super + стрелки` | Фокус |
| `Super + Shift + стрелки` | Переместить окно |

### 🗂️ Workspace'ы

| Шорткат | Действие |
|---|---|
| `Super + 1..0` | Переключиться на workspace 1-10 |
| `Super + Shift + 1..0` | Переместить окно в workspace |
| `Super + Tab` / `Super + Shift + Tab` | Следующий / предыдущий workspace |
| `Super + ,` / `Super + .` | Предыдущий / следующий workspace |
| `Super + Shift + [` / `Super + Shift + ]` | Переключиться на предыдущий/следующий workspace |

### 🔐 Система и сессия

| Шорткат | Действие |
|---|---|
| `Ctrl + Alt + L` | Заблокировать экран |
| `Ctrl + Alt + S` | Заблокировать и сразу в сон |
| `Ctrl + Alt + Delete` | Выйти из сеанса (с подтверждением) |
| `Ctrl + Alt + P` | Меню питания |
| `Super + Shift + C` | Reload i3 config (сначала валидирует через `i3 -C`) |
| `Super + Shift + R` | Перезапустить i3 |

### 🎵 Медиа и железо

| Шорткат | Действие |
|---|---|
| `XF86 Volume Up/Down` | Громкость ±5% |
| `XF86 Mute` / `XF86 Mic Mute` | Mute audio / mic |
| `XF86 Brightness Up/Down` | Яркость ±5% |
| `XF86 Play / Next / Prev` | Управление медиа через `playerctl` |
| `Print` | Скриншот всего экрана |
| `Super + Print` | Скриншот области |
| `Super + Shift + Print` | Скриншот области |
| `Super + Ctrl + Print` | Скриншот через 5 с |
| `F6` | Скриншот всего экрана (ноутбуки без Print) |
| `Super + W` | Выбрать обои |
| `Ctrl + Space` | Handy voice-to-text toggle (пока Handy запущен) |

### 🖐️ Жесты тачпада (`libinput-gestures`)

| Жест | Действие |
|---|---|
| 3 пальца ← / → | Предыдущий / следующий workspace |
| 3 пальца ↑ | Window switcher по всем workspace |
| 3 пальца ↓ | Переключить scratchpad |
| 2 пальца pinch in / out | Громкость −/+ 5% |

---

<a id="-что-вы-увидите"></a>

## 🎨 Что вы увидите

| | |
|---|---|
| **Верхняя панель** | Кнопки workspaces, трей приложений, кликабельное имя Wi-Fi, лампочка яркости, индикатор eye-care, громкость, CPU/RAM, батарея, дата |
| **Лаунчер** | `Super + D` открывает Rofi с Nord-темой, иконками приложений, историей поиска, быстрым вводом с клавиатуры |
| **Lock screen** | Время + дата + «Сеанс заблокирован» + поле ввода с индикатором `i3lock`, либо запрос `xsecurelock` с PAM-обратной связью |
| **Power menu** | Пять русских подписей с понятными последствиями, `Esc`/`Super+Q` отменяют |
| **Window switcher** | Список со всех workspace с иконкой, номером workspace, классом и заголовком |

---

<a id="-️-как-это-работает"></a>

## ⚙️ Как это работает

### 🔐 Lock screen

`i3exit.sh` не запускает `i3lock` напрямую — он просит работающий daemon `xss-lock` заблокировать экран через `xset s activate`, затем ждёт до 5 секунд появления `xsecurelock` (предпочтительно) или `i3lock` (fallback). Только после того, как экран защищён, выполняется `systemctl suspend -i` или `systemctl hibernate -i`. Флаг `-i` (`--check-inhibitors=no`) гарантирует, что приложения не могут отменить сон.

`xss-lock` запускается в i3 autostart:

```
exec --no-startup-id xset s 600 10
exec --no-startup-id xss-lock --transfer-sleep-lock -- $HOME/.config/i3/scripts/lock-screen.sh
```

`lock-screen.sh` сначала пробует `xsecurelock` (Nord-цвета, JetBrainsMono Nerd Font, PAM-обратная связь, дата, раскладка). Если `xsecurelock` ещё не установлен, скрипт генерирует ImageMagick-изображение 1920×1080 (или текущее XRandR-разрешение) Nord-темы со временем, датой, подсказкой раскладки и инструкциями, и передаёт его в `i3lock`. Изображение создаётся с `umask 077` — только ваш пользователь может его прочитать.

### 🎙️ Автопереключение микрофона

Звуковая карта (Intel HDA / Realtek ALC256) публикует один PipeWire source с двумя портами, но `WirePlumber` помечает оба как `availability unknown` и не переключает автоматически. Реальное состояние — в ALSA control `Headphone Jack`.

`audio-port-autoswitch.sh` опрашивает этот control, выбирает `analog-input-headset-mic` при вставленном штекере и `analog-input-internal-mic` при извлечённом, затем ждёт событий `alsactl monitor hw:0` — без polling, без DBus, без Python. Калибровочные переменные:

| Переменная | По умолчанию | Назначение |
|---|---|---|
| `AUDIO_CARD` | `0` | индекс ALSA-карты |
| `AUDIO_SOURCE` | `alsa_input.pci-0000_00_1f.3.analog-stereo` | имя PipeWire source |
| `HEADSET_MIC_PORT` | `analog-input-headset-mic` | порт при вставленном штекере |
| `INTERNAL_MIC_PORT` | `analog-input-internal-mic` | порт при извлечённом штекере |

### 🖐️ Tap и жесты тачпада

`libinput Tapping Enabled` и `Device Enabled` сбрасываются в `1` на каждом входе i3 через `touchpad.py` (использует `python3-xlib`, без CLI `xinput`). Для жестов pinned-daemon `libinput-gestures 2e4cc4c` читает `libinput-debug-events --device /dev/input/event6` и исполняет жесты из `~/.config/libinput-gestures.conf`. Вашему аккаунту нужен read-доступ к `/dev/input/event6` — по умолчанию Fedora даёт его членам группы `input`. Перелогиньтесь после `sudo gpasswd -a $USER input`, чтобы изменение подействовало.

> ⚠️ **Заметка про `libinput-gestures -l`**: флаг `-l/--list` в этой версии вызывает внешний setup helper, который удаляет standalone binary как часть cleanup. Проверяйте daemon через `pgrep -af libinput-gestures`.

### 💼 Chrome / авторазблокировка KWallet

Plasma-стиль `pam_kwallet_init` обычно стартует как скрытый XDG autostart, но i3 их не запускает. В i3 config добавлено:

```
exec --no-startup-id sh -c "[ -x /usr/libexec/pam_kwallet_init ] && exec /usr/libexec/pam_kwallet_init || true"
```

Он передаёт пароль, который SDDM/PAM уже получил (через `/run/user/1000/kwallet5.socket`), в работающий процесс `ksecretd` — ничего не пишется на диск. Парный `xdg-desktop-portal/i3-portals.conf` маршрутизирует `org.freedesktop.impl.portal.Secret` в KWallet, оставляя остальные portal'ы на GTK.

Чтобы wallet действительно разблокировался, **пароль wallet должен совпадать с паролем Fedora**. Если Chrome продолжает забывать сессии после logout/login, откройте `kwalletmanager5`, выберите `kdewallet` → Сменить пароль и установите пароль Fedora.

### 🟣 Telegram под Picom

`QT_XCB_GL_INTEGRATION=none` применяется как per-app Flatpak override:

```
flatpak override --user --env=QT_XCB_GL_INTEGRATION=none org.telegram.desktop
```

Telegram использует software rendering для своего X11-surface, а Picom GLX остаётся включённым для всех остальных приложений.

### 🛌 Крышка и сон

Drop-in `etc/systemd/logind.conf.d/90-i3-fedora-lid.conf`:

```ini
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
HandleLidSwitchDocked=suspend
LidSwitchIgnoreInhibited=yes
```

Сон на батарее, розетке и в док-станции. Вместе с `xss-lock --transfer-sleep-lock` экран **всегда** блокируется до suspend.

---

<a id="-️-повседневное-использование"></a>

## 🛠️ Повседневное использование

### Первые 5 минут

1. **Lock screen** через `Ctrl+Alt+L` — увидите время/дату и инструкции вместо чёрного круга.
2. **Разблокируйте** и откройте лаунчер через `Super+D`.
3. **Window switcher** через `Alt+Tab` — выберите окно с любого workspace.
4. **Лампочка яркости** в Polybar — левый клик откроет меню eye-care температуры.
5. **Имя Wi-Fi** в Polybar — левый клик открывает Wi-Fi-меню (постоянное, закрывается только `Esc`/`Super+Q`).
6. **Power menu** через `Ctrl+Alt+P` — пять русских действий, подтверждение для logout/reboot/shutdown.

### Жесты тремя пальцами

| ← / → | Переключение workspace |
|---|---|
| ↑ | Window switcher по всем workspace |
| ↓ | Scratchpad |

### Восстановление из прошлой установки

Если после ручного редактирования что-то сломалось:

```bash
cp -a ~/.config/i3-fedora-backup-<TIMESTAMP>/.config/. ~/.config/
cp -a ~/.config/i3-fedora-backup-<TIMESTAMP>/home/. ~/
```

### Безопасный reload i3

`Super+Shift+C` запускает `reload-safe.sh`, который сначала делает `i3 -C` и отказывается reload'ить при синтаксических ошибках. Полный restart: `Super+Shift+R`.

### Добавить новый шорткат

Откройте `~/.config/i3/config`, добавьте `bindcode $mod+NN <команда>`, затем `Super+Shift+C`. Активная копия живёт в `~/.config/i3/config`; источник истины — проектный `.config/i3/config`. Сверяйте через `cmp`.

---

<a id="-решение-проблем"></a>

## 🐞 Решение проблем

### «i3: syntax error» после редактирования

`Super+Shift+C` уже валидирует через `i3 -C` — если отказывается reload'ить, активный config сломан. Запустите `i3 -C -c ~/.config/i3/config`, чтобы увидеть ошибку. Либо исправьте синтаксис, либо восстановите проектную копию:

```bash
cp i3-fedora-ready/.config/i3/config ~/.config/i3/config
i3-msg reload
```

### Тачпад не реагирует

Проверьте, видит ли его ядро:

```bash
cat /proc/bus/input/devices | grep -A 3 ELAN
ls -l /dev/input/event*
```

Если виден, но курсор не двигается:

```bash
python3 ~/.config/i3/scripts/touchpad.py
```

Это повторно включит `Device Enabled` и `libinput Tapping Enabled`. Если daemon жестов умер:

```bash
i3-msg 'exec --no-startup-id /home/fedora/.local/bin/libinput-gestures'
pgrep -af libinput-gestures
```

### Chrome забывает Google-сессии после перезагрузки

1. Проверьте, что `pam-kwallet` установлен: `rpm -q pam-kwallet`.
2. Убедитесь, что кошелёк существует и разблокирован: `busctl --user introspect org.freedesktop.secrets /org/freedesktop/secrets org.freedesktop.Secret.Service`.
3. Если `kwalletmanager5` запрашивает пароль при каждом входе — откройте его, смените пароль кошелька на **тот же, что пароль входа в Fedora**.
4. Полностью завершите Chrome (трей → Выйти) и один раз войдите в Google. Новая cookie переживёт следующую перезагрузку.

### Микрофон гарнитуры не переключается

Запустите `audio-port-autoswitch.sh --self-test`, чтобы проверить, что source и control найдены. Калибровка под железо:

```bash
AUDIO_CARD=1 HEADSET_MIC_PORT="your-port-name" ~/.config/i3/scripts/audio-port-autoswitch.sh --once
pactl set-source-port "$AUDIO_SOURCE" "$HEADSET_MIC_PORT"
```

### `xss-lock` не заблокировал экран перед сном

`systemd-inhibit --list` должен показывать ваш процесс `xss-lock`. Если нет:

```bash
i3-msg 'exec --no-startup-id xss-lock --transfer-sleep-lock -- $HOME/.config/i3/scripts/lock-screen.sh'
```

### Permission denied при `sudo ./install.sh`

Installer требует `dnf`-доступа. Либо поставьте пакеты заранее, либо запустите от пользователя с NOPASSWD sudo. Остальные шаги (копирование конфигов, скрипты, KWallet override) работают и без sudo.

### Picom глючит на Intel UHD 620 + NVIDIA MX130

Переключите backend на `xrender` в `~/.config/picom/picom.conf` и отключите `dual_kawase` blur. Fallback задокументирован в комментариях.

---

<a id="-благодарности"></a>

## 🤝 Благодарности

- Оригинальные dotfiles: [harilvfs/i3wmdotfiles](https://github.com/harilvfs/i3wmdotfiles) — Arch-база, портированная этим репозиторием.
- Nord theme: [nordtheme.com](https://www.nordtheme.com/) — цвета для i3, Rofi, Polybar, Dunst, Kitty.
- Обои: [harilvfs/wallpapers](https://github.com/harilvfs/wallpapers) — автоматически клонируются в `~/Pictures/wallpapers`.
- Темы: [harilvfs/themes](https://github.com/harilvfs/themes), [harilvfs/icons](https://github.com/harilvfs/icons) — опциональные GTK и иконочные наборы.
- JetBrainsMono Nerd Font: [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts) — pinned v3.4.0.
- Greenclip: [erebe/greenclip](https://github.com/erebe/greenclip) — pinned v4.2.
- libinput-gestures: [bulletmark/libinput-gestures](https://github.com/bulletmark/libinput-gestures) — pinned commit `2e4cc4c`.

---

<div align="center">

<sub>Сделано с 🐧 для Fedora 43+ — каждый шорткат проверен на реальном ASUS VivoBook S15 X530UF.</sub>

</div>