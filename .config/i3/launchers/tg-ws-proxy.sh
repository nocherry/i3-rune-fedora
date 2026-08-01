#!/usr/bin/env bash
# Override TG_WS_PROXY_BIN when the binary is installed elsewhere.
exec ~/.config/i3/scripts/run-bg.sh tg-ws-proxy "${TG_WS_PROXY_BIN:-$HOME/.local/bin/tg-ws-proxy}"
