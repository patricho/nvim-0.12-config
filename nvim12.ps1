# nvim12.ps1 — Launch Neovim 0.12 with isolated config and data directories.

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Binary — extracted zip lives next to this script
$NvimBin = Join-Path $ScriptDir "bin\nvim-win64\bin\nvim.exe"

if (-not (Test-Path $NvimBin)) {
    Write-Error "nvim.exe not found at: $NvimBin"
    exit 1
}

# Config — NVIM_APPNAME is resolved relative to XDG_CONFIG_HOME
$env:XDG_CONFIG_HOME = Join-Path $ScriptDir "config"
$env:NVIM_APPNAME    = "nvim12"

# Data, state, cache — fully isolated under this project folder
$env:XDG_DATA_HOME   = Join-Path $ScriptDir "data"
$env:XDG_STATE_HOME  = Join-Path $ScriptDir "state"
$env:XDG_CACHE_HOME  = Join-Path $ScriptDir "cache"

& $NvimBin @args
