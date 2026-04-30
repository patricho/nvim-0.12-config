# Neovim 0.12 Config

A self-contained Neovim 0.12 setup that runs fully isolated from any existing Neovim installation.
All XDG directories (config, data, state, cache) live inside this project folder.

## Requirements

- Neovim 0.12 binary (see below)
- [fzf](https://github.com/junegunn/fzf) on `PATH` (used by fzf-lua)
- [lazygit](https://github.com/jesseduffield/lazygit) on `PATH` (optional, used by Snacks)
- LSP servers installed separately — see [LSP](#lsp) below

## Installation

### 1. Get the Neovim binary

Download the Neovim 0.12 release for your platform from
https://github.com/neovim/neovim/releases/tag/v0.12.2 and extract it into the `bin/` folder:

| Platform     | Archive                    | Extract so that this path exists |
| ------------ | -------------------------- | -------------------------------- |
| Windows      | `nvim-win64.zip`           | `bin\nvim-win64\bin\nvim.exe`    |
| macOS arm64  | `nvim-macos-arm64.tar.gz`  | `bin/nvim-macos-arm64/bin/nvim`  |
| macOS x86_64 | `nvim-macos-x86_64.tar.gz` | `bin/nvim-macos-x86_64/bin/nvim` |

The binary is intentionally **not added to `PATH`**. It lives only inside this project folder and is
invoked exclusively through the launcher scripts below. Your system `nvim` (e.g. 0.10) remains
untouched.

### 2. How isolation works

Neovim uses four environment variables to locate all of its files:

| Variable          | Controls                   | Default (no override)                                  |
| ----------------- | -------------------------- | ------------------------------------------------------ |
| `XDG_CONFIG_HOME` | Config root                | `~/.config` (macOS/Linux) / `%LOCALAPPDATA%` (Windows) |
| `XDG_DATA_HOME`   | Plugins, parsers, sessions | `~/.local/share` / `%LOCALAPPDATA%`                    |
| `XDG_STATE_HOME`  | Undo history, logs         | `~/.local/state` / `%LOCALAPPDATA%`                    |
| `XDG_CACHE_HOME`  | Caches                     | `~/.cache` / `%TEMP%`                                  |

In addition, `NVIM_APPNAME` controls the **subdirectory name** used inside each of those roots. It
defaults to `nvim`.

Without any overrides, Neovim reads `$XDG_CONFIG_HOME/nvim/init.lua` — which is where your existing
0.10 config lives. The launcher scripts override all five variables to point entirely inside this
project folder:

```
XDG_CONFIG_HOME  →  <project>/config        config read from config/nvim12/
XDG_DATA_HOME    →  <project>/data          plugins stored in data/nvim12/
XDG_STATE_HOME   →  <project>/state
XDG_CACHE_HOME   →  <project>/cache
NVIM_APPNAME     →  nvim12                  subdirectory used in all of the above
```

The result: the 0.12 binary reads `config/nvim12/init.lua` and writes all data inside this project
folder. Nothing outside the project is read or written, and your existing 0.10 installation is
completely unaffected.

### 3. Launch

**Windows (PowerShell):**

```powershell
.\nvim12.ps1
```

**macOS / Linux (bash/zsh):**

```bash
./nvim12.sh
```

**Recommended:** add an alias to your shell profile so you can call it from anywhere without
navigating to the project folder:

```powershell
# PowerShell profile (~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1)
Set-Alias nvim12 "C:\path\to\neovim-0.12\nvim12.ps1"
```

```bash
# ~/.zshrc or ~/.bashrc
alias nvim12="$HOME/path/to/neovim-0.12/nvim12.sh"
```

Your existing `nvim` command continues to launch 0.10 as before. `nvim12` launches this isolated
0.12 environment.

Plugins are auto-installed on first launch via `vim.pack.add()` (Neovim 0.12's built-in package
manager).

## Project layout

```
neovim-0.12/
├── bin/                        Neovim binary (not in git)
├── config/
│   └── nvim12/                 Neovim config root (NVIM_APPNAME)
│       ├── init.lua
│       ├── lsp/                LSP server override configs
│       │   ├── gopls.lua
│       │   ├── lua_ls.lua
│       │   ├── omnisharp.lua
│       │   ├── rust_analyzer.lua
│       │   └── ts_ls.lua
│       └── lua/
│           ├── colors.lua      Highlight overrides
│           ├── keymaps.lua     All keymaps
│           ├── lsp.lua         LSP setup
│           ├── options.lua     Vim options
│           ├── plugins.lua     Plugin declarations and setup
│           ├── session.lua     Automatic session save/restore
│           └── treesitter.lua  Treesitter parser setup
├── data/                       Plugin and parser data (not in git)
├── nvim12.ps1                  Windows launcher
└── nvim12.sh                   macOS/Linux launcher
```

## Plugins

Managed by `vim.pack.add()` — Neovim 0.12's built-in package manager. No external plugin manager
needed.

| Plugin                                                                | Purpose                                            |
| --------------------------------------------------------------------- | -------------------------------------------------- |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parser management and highlighting                 |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua)                        | Fuzzy finder (used for a few pickers)              |
| [snacks.nvim](https://github.com/folke/snacks.nvim)                   | Primary picker, file explorer, lazygit integration |
| [which-key.nvim](https://github.com/folke/which-key.nvim)             | Keymap popup hints                                 |
| [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)               | Breadcrumb bar                                     |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)   | File type icons                                    |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)           | Git hunk signs and blame                           |
| [mini.cursorword](https://github.com/nvim-mini/mini.cursorword)       | Highlight word under cursor                        |
| [satellite.nvim](https://github.com/lewis6991/satellite.nvim)         | Scrollbar with diagnostics                         |
| [gruvbox-material](https://github.com/sainnhe/gruvbox-material)       | Color scheme                                       |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)          | Status line                                        |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)         | Buffer tab line                                    |

## Treesitter

Parsers are managed by nvim-treesitter and listed in `config/nvim12/lua/treesitter.lua`.

**To add a language**, add its name to the `parsers` table:

```lua
local parsers = {
    "go",
    "javascript",
    "lua",
    -- add your language here, e.g.:
    "python",
    "bash",
}
```

Neovim will download and compile the parser on the next startup.

**Finding parser names:** run `:TSInstallInfo` inside Neovim to list all available parsers and their
install status. The name used in the `parsers` table is the same name shown there (e.g. `"python"`,
`"bash"`, `"c"`, `"cpp"`).

Alternatively, browse the full list at
https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md

## LSP

LSP servers are installed **manually, outside of Neovim**. There is no mason.nvim or automatic
installer — you install binaries yourself using your system's package manager or language toolchain.

Servers are enabled in `config/nvim12/lua/lsp.lua`:

```lua
vim.lsp.enable({
    "gopls",
    "lua_ls",
    "omnisharp",
    "rust_analyzer",
    "ts_ls",
})
```

Each server has a config file under `config/nvim12/lsp/<name>.lua` that overrides the built-in
Neovim 0.12 defaults.

### Currently configured servers

| Server          | Language                | Install                                                                                                                            |
| --------------- | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `gopls`         | Go                      | `go install golang.org/x/tools/gopls@latest` (requires [Go](https://go.dev/dl/))                                                   |
| `lua_ls`        | Lua                     | `winget install LuaLS.lua-language-server` or [release download](https://github.com/LuaLS/lua-language-server/releases)            |
| `omnisharp`     | C# / .NET               | `winget install Microsoft.DotNet.SDK.9`, then download [OmniSharp release](https://github.com/OmniSharp/omnisharp-roslyn/releases) |
| `rust_analyzer` | Rust                    | `rustup component add rust-analyzer` (requires [rustup](https://rustup.rs))                                                        |
| `ts_ls`         | TypeScript / JavaScript | `npm install -g typescript typescript-language-server` (requires [Node.js](https://nodejs.org))                                    |

### Adding a new LSP server

1. **Install the server binary** so it is on your `PATH`.

2. **Check if Neovim 0.12 already has a built-in config** for it:

    ```
    :echo glob($VIMRUNTIME .. "/lsp/*.lua")
    ```

    or browse `$VIMRUNTIME/lsp/` in your file explorer. If a file exists for your server you may not
    need step 3 at all.

3. **Create an override config** (optional but recommended) at
   `config/nvim12/lsp/<server-name>.lua`. Minimal example:

    ```lua
    return {
        cmd = { "my-server", "--stdio" },
        filetypes = { "mylang" },
        root_markers = { "myproject.json", ".git" },
    }
    ```

4. **Enable the server** in `config/nvim12/lua/lsp.lua`:
    ```lua
    vim.lsp.enable({
        -- existing servers ...
        "my-server",   -- add here
    })
    ```

**Finding servers:**

https://microsoft.github.io/language-server-protocol/implementors/servers/ lists LSP server
implementations for most languages.

The Neovim community wiki at https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md is
also a useful reference for `cmd`, `filetypes`, and `root_markers` values (even though this config
does not use nvim-lspconfig).

### Debugging LSP

Run `:LspStatus` to see which servers are attached to the current buffer, their IDs, and all active
diagnostics.

## Native 0.12 features used

- **`vim.pack.add()`** — built-in package manager (replaces lazy.nvim/packer)
- **`vim.lsp.enable()`** — declarative LSP server activation
- **`vim.opt.autocomplete = true`** - native autocomplete, no completion plugin needed
- **`winborder = "rounded"`** — rounded borders on all floating windows globally
- **`vim.diagnostic.config` `current_line`** — show virtual text only for current line
- **`vim._core.ui2`** — new UI rendering layer opt-in
