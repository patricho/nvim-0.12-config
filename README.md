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

## Option Reference

The main editor options live in `config/nvim12/lua/options.lua`. That file keeps comments short so
the active settings are easy to scan; this section explains the less obvious options in more detail.

### `clipboard`

`clipboard` controls whether normal yank, delete, change, and put operations use Neovim's unnamed
register only, or whether they are connected to the operating system clipboard.

This config uses:

```lua
vim.opt.clipboard = "unnamedplus"
```

Supported values are comma-separated flags:

| Value         | Meaning                                                                                      |
| ------------- | -------------------------------------------------------------------------------------------- |
| `unnamed`     | Use the `"*` selection register for operations that would normally use the unnamed register. |
| `unnamedplus` | Use the `"+` clipboard register for operations that would normally use the unnamed register. |

The `"+` register is the system clipboard on most desktop setups, so `unnamedplus` makes regular
operations like `y`, `d`, `c`, and `p` interact with the same clipboard used by other applications.
Explicit registers still win: if you type `"ayy`, Neovim yanks into register `a` regardless of this
setting.

If both `unnamed` and `unnamedplus` are set, yank and delete operations also copy to `"*`, while put
operations use `"+`.

### `inccommand`

`inccommand` previews the result of commands while they are still being typed. It applies to
`:substitute`, `:smagic`, `:snomagic`, and user commands created with the command-preview flag.

This config uses:

```lua
vim.opt.inccommand = "split"
```

Supported values:

| Value     | Meaning                                                                 |
| --------- | ----------------------------------------------------------------------- |
| `""`      | Disable live command previews.                                          |
| `nosplit` | Show the command effect incrementally in the current buffer.            |
| `split`   | Like `nosplit`, but also opens a preview window for off-screen results. |

Example: while typing `:%s/foo/bar/g`, matches update live before pressing Enter. With `split`,
Neovim can also show changes that would happen outside the visible part of the current window.

If the preview becomes too slow and exceeds `redrawtime`, Neovim disables the preview until command
line mode ends.

### `complete`

`complete` controls the sources used by insert-mode completion with `CTRL-N`, `CTRL-P`, whole-line
completion, and native `autocomplete`. It is a comma-separated list of source flags.

This config uses:

```lua
vim.o.complete = "o,.,i"
```

That means completion asks `omnifunc` first, then scans the current buffer, then scans included
files. For LSP-backed buffers, Neovim's LSP client sets `omnifunc`, so the `o` source provides LSP
completion.

Supported source flags:

| Flag      | Source                                                                |
| --------- | --------------------------------------------------------------------- |
| `.`       | Current buffer.                                                       |
| `w`       | Buffers visible in other windows.                                     |
| `b`       | Other loaded buffers in the buffer list.                              |
| `u`       | Unloaded buffers in the buffer list.                                  |
| `U`       | Buffers that are not in the buffer list.                              |
| `k`       | Files configured by the `dictionary` option.                          |
| `kspell`  | Spell suggestions from active spell checking.                         |
| `k{dict}` | A specific dictionary file or file pattern.                           |
| `s`       | Files configured by the `thesaurus` option.                           |
| `s{tsr}`  | A specific thesaurus file or file pattern.                            |
| `i`       | Current file and files included from it.                              |
| `d`       | Defined names or macros from the current file and included files.     |
| `]`       | Tags.                                                                 |
| `t`       | Tags, equivalent to `]`.                                              |
| `f`       | Buffer names, not buffer contents.                                    |
| `F`       | Function from the `completefunc` option.                              |
| `F{func}` | A specific custom completion function. Multiple `F{func}` flags work. |
| `o`       | Function from the `omnifunc` option.                                  |

A source can be limited by appending `^{count}`. For example, `.^9,t^5` limits current-buffer
matches to 9 and tag matches to 5. The limit only applies to forward completion with `CTRL-N`; it is
ignored for backward completion with `CTRL-P`.

Function sources (`F`, `F{func}`, and `o`) can complete non-keyword text and can choose a different
replacement start position than normal keyword-based sources. Slow custom functions should call
`complete_check()` periodically so autocomplete remains responsive.

### `guicursor`

`guicursor` configures cursor shape, blinking, and highlight groups per editor mode. Despite the
name, it also works in many terminal UIs.

This config uses:

```lua
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
```

Each comma-separated part has this shape:

```text
mode-list:argument-list
```

The mode list is dash-separated. Supported modes:

| Mode | Meaning                               |
| ---- | ------------------------------------- |
| `n`  | Normal mode.                          |
| `v`  | Visual mode.                          |
| `ve` | Visual mode with exclusive selection. |
| `o`  | Operator-pending mode.                |
| `i`  | Insert mode.                          |
| `r`  | Replace mode.                         |
| `c`  | Command-line Normal mode.             |
| `ci` | Command-line Insert mode.             |
| `cr` | Command-line Replace mode.            |
| `sm` | `showmatch` in Insert mode.           |
| `t`  | Terminal mode.                        |
| `a`  | All modes.                            |

The argument list is also dash-separated. Common arguments:

| Argument                    | Meaning                                                                 |
| --------------------------- | ----------------------------------------------------------------------- |
| `block`                     | Block cursor filling the full character cell.                           |
| `ver{N}`                    | Vertical bar cursor, `{N}` percent of the character width.              |
| `hor{N}`                    | Horizontal bar cursor, `{N}` percent of the character height.           |
| `blinkwait{N}`              | Delay before blinking starts, in milliseconds.                          |
| `blinkon{N}`                | Time the cursor is visible during blink, in milliseconds.               |
| `blinkoff{N}`               | Time the cursor is hidden during blink, in milliseconds.                |
| `{group-name}`              | Highlight group used for cursor appearance.                             |
| `{group-name}/{group-name}` | Highlight group for normal mappings, then for active language mappings. |

In this config, Normal/Visual/Command-line Normal use a block cursor, Insert and related modes use a
25% vertical bar, Replace modes use a 20% horizontal bar, and Operator-pending mode uses a 50%
horizontal bar.

Set `guicursor` to an empty string to disable cursor styling:

```vim
:set guicursor=
```

### `completeopt`

`completeopt` controls how insert-mode completion is displayed and inserted. It does not choose the
completion sources; that is `complete`.

This config uses:

```lua
vim.opt.completeopt = "menu,menuone,noinsert,popup,preview"
```

Supported values:

| Value       | Meaning                                                                                         |
| ----------- | ----------------------------------------------------------------------------------------------- |
| `fuzzy`     | Enable fuzzy matching for completion candidates.                                                |
| `longest`   | Insert the longest common prefix of matching items.                                             |
| `menu`      | Show the popup completion menu when there is more than one match.                               |
| `menuone`   | Show the popup completion menu even when there is only one match.                               |
| `nearest`   | Sort current-buffer matches by proximity to the cursor. Has no effect with `fuzzy`.             |
| `noinsert`  | Do not insert match text until an item is selected. Requires `menu` or `menuone`.               |
| `noselect`  | Like `noinsert`, but do not preselect any menu item. Takes precedence over `noinsert`.          |
| `nosort`    | Keep original candidate order when `fuzzy` is enabled instead of sorting by fuzzy score.        |
| `popup`     | Show extra information for the selected completion item in a popup window. Overrides `preview`. |
| `preinsert` | Insert the first candidate beyond the typed leader as highlighted preview text.                 |
| `preselect` | Select a completion item that has its `preselect` field set, for example by an LSP server.      |
| `preview`   | Show extra information for the selected completion item in the preview window.                  |

When native `autocomplete` is enabled, `noselect` is automatically enabled unless `preinsert` is also
enabled. Only `fuzzy`, `longest`, `popup`, `preinsert`, `preselect`, and `preview` have an effect
while `autocomplete` is active.

The configured value means: show a menu, show it even for a single item, do not insert text until a
selection is made, and show completion documentation/details in a popup window.

### `statusline`

`statusline` defines the content of each window's status line. This config uses `lualine.nvim`, so
the raw option is mostly managed by the plugin, but the format language is still useful when reading
or writing custom status lines.

A statusline is regular text mixed with `%` items:

```text
%-0{minwid}.{maxwid}{item}
```

Only `{item}` is required. The optional pieces control padding, alignment, and truncation:

| Part     | Meaning                                                                     |
| -------- | --------------------------------------------------------------------------- |
| `-`      | Left-align the item.                                                        |
| `0`      | Pad numeric items with leading zeroes.                                      |
| `minwid` | Minimum width.                                                              |
| `maxwid` | Maximum width before truncation.                                            |
| `item`   | One-letter statusline item, expression, highlight switch, or layout marker. |

Common statusline items:

| Item | Meaning                                                  |
| ---- | -------------------------------------------------------- |
| `%f` | File path as typed or relative to the current directory. |
| `%F` | Full file path.                                          |
| `%t` | File name only.                                          |
| `%m` | Modified flag, shown as `[+]`.                           |
| `%r` | Readonly flag, shown as `[RO]`.                          |
| `%h` | Help buffer flag.                                        |
| `%w` | Preview window flag.                                     |
| `%y` | Filetype.                                                |
| `%n` | Buffer number.                                           |
| `%l` | Current line number.                                     |
| `%L` | Total lines in buffer.                                   |
| `%c` | Current byte column.                                     |
| `%v` | Current virtual/screen column.                           |
| `%p` | Percentage through file by line.                         |
| `%P` | Percentage through the displayed window.                 |
| `%=` | Split left and right aligned sections.                   |
| `%<` | Mark where truncation should happen if space is limited. |
| `%%` | Literal percent sign.                                    |

Expressions are also supported:

| Form        | Meaning                                                                          |
| ----------- | -------------------------------------------------------------------------------- |
| `%!expr`    | Use the result of an expression as the full statusline format.                   |
| `%{expr}`   | Evaluate an expression and insert the result.                                    |
| `%{%expr%}` | Evaluate an expression, then re-evaluate the result as statusline format syntax. |

Highlight and click-related items exist too, for example `%#Group#` to switch highlight group and
`%*` to restore the default highlight. Custom statusline expressions run during redraw, so expensive
logic can make the UI feel slow.

### `statuscolumn`

`statuscolumn` defines the left-side column area of a window. That area normally contains line
numbers, signs, and folds. Its format is based on `statusline`, but it is evaluated for each drawn
screen line instead of once per window.

This config does not set `statuscolumn`, so Neovim uses its default number, sign, and fold columns.
If it is set later, these statuscolumn-specific items are the important ones:

| Item | Meaning                                   |
| ---- | ----------------------------------------- |
| `%l` | Line number for the currently drawn line. |
| `%s` | Sign column for the currently drawn line. |
| `%C` | Fold column for the currently drawn line. |

Useful variables while evaluating `statuscolumn`:

| Variable    | Meaning                                                                             |
| ----------- | ----------------------------------------------------------------------------------- |
| `v:lnum`    | Buffer line number being drawn.                                                     |
| `v:relnum`  | Relative line number being drawn.                                                   |
| `v:virtnum` | Negative for virtual lines, zero for real buffer lines, positive for wrapped parts. |

The width follows the normal column options such as `numberwidth`, `signcolumn`, and `foldcolumn`.
It can grow with the evaluated format, but shrinking usually happens only when the line count changes
or when `statuscolumn` is set again.

Click handlers with `%@Func@...%T` are supported, but the same function is used for each row in the
same column. Because `statuscolumn` is evaluated for every visible line, keep expressions cheap.

### `mouse`

`mouse` enables mouse support per mode. This config uses:

```lua
vim.opt.mouse = "a"
```

Supported mode flags:

| Flag | Meaning                                      |
| ---- | -------------------------------------------- |
| `n`  | Normal mode.                                 |
| `v`  | Visual mode.                                 |
| `i`  | Insert mode.                                 |
| `c`  | Command-line mode.                           |
| `h`  | All previous modes when editing a help file. |
| `a`  | All previous modes.                          |
| `r`  | Hit-enter and more-prompt prompts.           |

With mouse support enabled, left-click places the cursor, dragging a statusline or vertical separator
resizes windows, and Visual mode supports double-click word selection, triple-click line selection,
and quadruple-click block selection. Hold Shift while using the mouse to temporarily bypass Neovim's
mouse handling in many terminals.

When mouse support is enabled in a terminal, copy/paste may use the `"*` register if available, so it
interacts with `clipboard` behavior.

## Highlight Reference

Highlight overrides live in `config/nvim12/lua/colors.lua`. That file is loaded after the color
scheme, so its `vim.api.nvim_set_hl()` calls can override defaults from `gruvbox-material` and from
plugins.

Basic shape:

```lua
vim.api.nvim_set_hl(0, "GroupName", { fg = "#ffffff", bg = "#000000", bold = true })
```

Common attributes:

| Attribute       | Meaning                                                    |
| --------------- | ---------------------------------------------------------- |
| `fg`            | Foreground/text color.                                     |
| `bg`            | Background color.                                          |
| `sp`            | Special color used by undercurl/underline styles.          |
| `bold`          | Bold text.                                                 |
| `italic`        | Italic text.                                               |
| `underline`     | Straight underline.                                        |
| `undercurl`     | Curly underline, often used for diagnostics.               |
| `strikethrough` | Strikethrough text.                                        |
| `reverse`       | Swap foreground and background.                            |
| `link`          | Link this group to another highlight group.                |

Example link:

```lua
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
```

### Cursor And Lines

These groups control the cursor, current line, line numbers, and related editor chrome.

| Group              | What it affects                                                   |
| ------------------ | ----------------------------------------------------------------- |
| `Cursor`           | Normal cursor color when controlled by Neovim.                    |
| `lCursor`          | Cursor color when language mappings are active.                   |
| `CursorIM`         | Cursor color in Input Method mode.                                |
| `TermCursor`       | Cursor in terminal buffers.                                       |
| `TermCursorNC`     | Terminal cursor when the terminal window is not focused.          |
| `CursorLine`       | Background for the current screen line.                           |
| `CursorColumn`     | Background for the current screen column.                         |
| `LineNr`           | Line numbers.                                                     |
| `CursorLineNr`     | Line number for the current line.                                 |
| `SignColumn`       | Sign column background.                                           |
| `FoldColumn`       | Fold column.                                                      |
| `ColorColumn`      | Columns marked by `colorcolumn`.                                  |

Cursor shape is controlled by `guicursor`; these highlight groups only control cursor colors when the
terminal or UI supports it.

Example:

```lua
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2420" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#fabd2f", bold = true })
```

### Selection And Matching

These groups are useful for selections, matched brackets, and highlighted words.

| Group                   | What it affects                                      |
| ----------------------- | ---------------------------------------------------- |
| `Visual`                | Visual mode selection.                               |
| `VisualNOS`             | Visual selection when Neovim is not owning selection.|
| `MatchParen`            | Matching bracket, parenthesis, or brace.             |
| `MiniCursorword`        | Other occurrences of word under cursor.              |
| `MiniCursorwordCurrent` | Current word under cursor from `mini.cursorword`.    |
| `IlluminatedWordText`   | Text references from illumination-style plugins.     |
| `IlluminatedWordRead`   | Read references from illumination-style plugins.     |
| `IlluminatedWordWrite`  | Write references from illumination-style plugins.    |

This config currently customizes `Visual`, `MatchParen`, `MiniCursorword`,
`MiniCursorwordCurrent`, and the `IlluminatedWord*` groups.

### Search

Search highlighting is separate from LSP references and cursor-word highlighting.

| Group        | What it affects                                                |
| ------------ | -------------------------------------------------------------- |
| `Search`     | Search matches from `/`, `?`, and `hlsearch`.                  |
| `CurSearch`  | Current search match.                                          |
| `IncSearch`  | Incremental search match while typing a search.                |
| `Substitute` | Replacement preview during `:substitute` with `inccommand`.    |

Example:

```lua
vim.api.nvim_set_hl(0, "Search", { fg = "#1d2021", bg = "#fabd2f" })
vim.api.nvim_set_hl(0, "CurSearch", { fg = "#1d2021", bg = "#fe8019", bold = true })
```

### Diagnostics

Diagnostics use several groups per severity. The severity suffixes are `Error`, `Warn`, `Info`,
`Hint`, and sometimes `Ok`.

| Group pattern                 | What it affects                                            |
| ----------------------------- | ---------------------------------------------------------- |
| `DiagnosticError`             | Base diagnostic color for errors.                          |
| `DiagnosticWarn`              | Base diagnostic color for warnings.                        |
| `DiagnosticInfo`              | Base diagnostic color for informational diagnostics.        |
| `DiagnosticHint`              | Base diagnostic color for hints.                           |
| `DiagnosticOk`                | Base diagnostic color for OK/success diagnostics.          |
| `DiagnosticSign{Severity}`    | Sign column diagnostic marker.                             |
| `DiagnosticVirtualText{Severity}` | Inline virtual diagnostic text.                         |
| `DiagnosticUnderline{Severity}`   | Underline or undercurl beneath diagnostic ranges.       |
| `DiagnosticFloating{Severity}`    | Diagnostic text in floating windows.                    |

This config uses undercurls for diagnostic ranges, colored signs, and italic virtual text:

```lua
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#db4b4b", undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#db4b4b" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#db4b4b", italic = true })
```

### LSP

LSP highlight groups cover document references, semantic tokens, inlay hints, code lenses, and
signature help. Availability depends on the server and client features in use.

| Group                       | What it affects                                             |
| --------------------------- | ----------------------------------------------------------- |
| `LspReferenceText`          | Symbol reference under cursor for general text access.      |
| `LspReferenceRead`          | Symbol reference under cursor for read access.              |
| `LspReferenceWrite`         | Symbol reference under cursor for write access.             |
| `LspInlayHint`              | LSP inlay hint text.                                        |
| `LspCodeLens`               | Code lens virtual text.                                     |
| `LspCodeLensSeparator`      | Separator between code lens items.                          |
| `LspSignatureActiveParameter` | Active parameter in signature help.                       |
| `@lsp.type.*`               | Semantic token type groups, such as `@lsp.type.function`.   |
| `@lsp.mod.*`                | Semantic token modifier groups, such as `@lsp.mod.readonly`.|
| `@lsp.typemod.*`            | Combined semantic type/modifier groups.                     |

This config currently customizes the `LspReference*` groups to make the symbol under the cursor more
visible.

Semantic token examples:

```lua
vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "@lsp.mod.deprecated", { strikethrough = true })
```

### Git Diffs

Git-related groups are used by Neovim diff mode and by plugins such as `gitsigns.nvim`.

| Group              | What it affects                                         |
| ------------------ | ------------------------------------------------------- |
| `DiffAdd`          | Added lines in diff views.                              |
| `DiffChange`       | Changed lines in diff views.                            |
| `DiffDelete`       | Deleted lines in diff views.                            |
| `DiffText`         | Changed text inside changed lines.                      |
| `Added`            | Generic added text group.                               |
| `Changed`          | Generic changed text group.                             |
| `Removed`          | Generic removed text group.                             |
| `GitSignsAdd`      | Added-line sign from `gitsigns.nvim`.                   |
| `GitSignsChange`   | Changed-line sign from `gitsigns.nvim`.                 |
| `GitSignsDelete`   | Deleted-line sign from `gitsigns.nvim`.                 |
| `GitSignsAddNr`    | Line number highlight for added lines.                  |
| `GitSignsChangeNr` | Line number highlight for changed lines.                |
| `GitSignsDeleteNr` | Line number highlight for deleted lines.                |
| `GitSignsAddLn`    | Full-line highlight for added lines.                    |
| `GitSignsChangeLn` | Full-line highlight for changed lines.                  |
| `GitSignsDeleteLn` | Full-line highlight for deleted lines.                  |

Example:

```lua
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#a9b665" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#d8a657" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ea6962" })
```

### Completion And Popups

These groups are useful when tuning native completion, floating windows, and plugin popups.

| Group           | What it affects                                          |
| --------------- | -------------------------------------------------------- |
| `Pmenu`         | Popup menu body.                                         |
| `PmenuSel`      | Selected popup menu item.                                |
| `PmenuKind`     | Completion item kind column.                             |
| `PmenuKindSel`  | Selected completion item kind.                           |
| `PmenuExtra`    | Extra completion menu text.                              |
| `PmenuExtraSel` | Selected extra completion menu text.                     |
| `PmenuSbar`     | Popup menu scrollbar.                                    |
| `PmenuThumb`    | Popup menu scrollbar thumb.                              |
| `NormalFloat`   | Normal text in floating windows.                         |
| `FloatBorder`   | Floating window borders.                                 |
| `FloatTitle`    | Floating window title.                                   |
| `FloatFooter`   | Floating window footer.                                  |
| `PreInsert`     | Preview text inserted by `completeopt=preinsert`.        |

These groups affect more than completion: LSP hover, diagnostic floats, picker popups, and plugin
windows often link to `NormalFloat` and `FloatBorder`.

### Treesitter And Syntax

Treesitter highlight groups use capture names. They are useful for language-aware customization, but
exact captures vary by parser and query files.

| Group                  | What it affects                                  |
| ---------------------- | ------------------------------------------------ |
| `@variable`            | Variables.                                       |
| `@variable.parameter`  | Function parameters.                             |
| `@function`            | Functions.                                       |
| `@function.method`     | Methods.                                         |
| `@constructor`         | Constructors.                                    |
| `@keyword`             | Keywords.                                        |
| `@keyword.function`    | Function-like keywords.                          |
| `@string`              | Strings.                                         |
| `@number`              | Numbers.                                         |
| `@boolean`             | Booleans.                                        |
| `@comment`             | Comments.                                        |
| `@type`                | Types.                                           |
| `@property`            | Object properties or fields.                     |
| `@punctuation.delimiter` | Delimiters such as commas and semicolons.      |

Language-specific overrides append the language name:

```lua
vim.api.nvim_set_hl(0, "@function.lua", { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "@keyword.rust", { fg = "#fe8019", italic = true })
```

### Indent Guides And Scrollbar

Plugin highlight groups are plugin-specific. This config currently customizes Snacks indent guides
and Satellite's scrollbar.

| Group               | What it affects                                  |
| ------------------- | ------------------------------------------------ |
| `SnacksIndent`      | Normal indent guide from `snacks.nvim`.          |
| `SnacksIndentScope` | Active indent scope from `snacks.nvim`.          |
| `SatelliteBar`      | Scrollbar bar from `satellite.nvim`.             |

Example from this config:

```lua
vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#444444" })
vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#999999" })
vim.api.nvim_set_hl(0, "SatelliteBar", { bg = "#4C4846" })
```

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
