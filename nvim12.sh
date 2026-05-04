#!/usr/bin/env bash
# nvim12.sh — Launch Neovim 0.12 with isolated config and data directories.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Binary — extracted tarball lives next to this script
NVIM_BIN="$SCRIPT_DIR/bin/nvim-macos-arm64/bin/nvim"
# If you're on Intel Mac, change the above to:
# NVIM_BIN="$SCRIPT_DIR/bin/nvim-macos-x86_64/bin/nvim"

if [[ ! -x "$NVIM_BIN" ]]; then
    echo "error: nvim not found at: $NVIM_BIN" >&2
    exit 1
fi

# Config — NVIM_APPNAME is resolved relative to XDG_CONFIG_HOME
export XDG_CONFIG_HOME="$SCRIPT_DIR/config"
export NVIM_APPNAME="nvim12"

# Data, state, cache — fully isolated under this project folder
export XDG_DATA_HOME="$SCRIPT_DIR/data"
export XDG_STATE_HOME="$SCRIPT_DIR/state"
export XDG_CACHE_HOME="$SCRIPT_DIR/cache"

exec "$NVIM_BIN" "$@"
