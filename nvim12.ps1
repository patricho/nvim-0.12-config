# nvim12.ps1 — Launch Neovim 0.12 with isolated config and data directories.
# Usage: .\nvim12.ps1 [nvim args...]
# Or add a shell alias: Set-Alias nvim12 "C:\...\nvim12.ps1"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Binary — extracted zip lives next to this script
$NvimBin = Join-Path $ScriptDir "bin\nvim-win64\bin\nvim.exe"

if (-not (Test-Path $NvimBin)) {
    Write-Error "nvim.exe not found at: $NvimBin"
    Write-Error "Download nvim-win64.zip from https://github.com/neovim/neovim/releases/tag/v0.12.2"
    Write-Error "and extract it so that bin\nvim-win64\bin\nvim.exe exists."
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
