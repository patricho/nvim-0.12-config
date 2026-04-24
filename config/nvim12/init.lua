-- =============================================================================
-- Neovim 0.12 configuration
-- Uses only native 0.12 features: vim.pack, vim.lsp, built-in treesitter
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Options
-- ---------------------------------------------------------------------------
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.signcolumn     = "yes"
vim.opt.cursorline     = true
vim.opt.wrap           = false
vim.opt.scrolloff      = 8
vim.opt.sidescrolloff  = 8
vim.opt.cmdheight      = 0

vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true

vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.hlsearch       = false
vim.opt.incsearch      = true

vim.opt.splitright     = true
vim.opt.splitbelow     = true

vim.opt.undofile       = true
vim.opt.swapfile       = false

vim.opt.termguicolors  = true
vim.opt.winborder      = "rounded"   -- 0.12: native rounded borders everywhere
vim.opt.completeopt    = "menu,menuone,noinsert,popup"
vim.opt.autocomplete   = true        -- 0.12: native auto-completion

-- Use system clipboard
vim.opt.clipboard      = "unnamedplus"

-- Leader
vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

-- New UI opt-in
require('vim._core.ui2').enable({})

-- preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- show which line your cursor is on
vim.opt.cursorline = true

-- set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- clear search highlights with <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- ---------------------------------------------------------------------------
-- Diagnostics (configure early so they're always active)
-- ---------------------------------------------------------------------------
-- virtual_text shows diagnostics inline, after each line's actual contents.
-- This requires an LSP (or other diagnostic source) to be running.
vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    prefix = "●",
    spacing = 20,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
  underline     = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- ---------------------------------------------------------------------------
-- Keymaps
-- ---------------------------------------------------------------------------
local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Navigation
map("n", "<C-h>", "<C-w>h", "Window left")
map("n", "<C-j>", "<C-w>j", "Window down")
map("n", "<C-k>", "<C-w>k", "Window up")
map("n", "<C-l>", "<C-w>l", "Window right")

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprev<cr>", "Prev buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete buffer")

-- File picker (Snacks)
map("n", "<leader>e", function() Snacks.picker.files() end, "Find files")
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", "Find files")
map("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", "Find files")

-- Quickfix
map("n", "]q", "<cmd>cnext<cr>", "Next quickfix")
map("n", "[q", "<cmd>cprev<cr>", "Prev quickfix")

-- LSP (0.12 native defaults: grn=rename, gra=code action, grr=references, gri=impl)
-- Additional bindings:
--
-- Show diagnostics for the current line in a floating window.
-- This only opens if there are diagnostics on the current line.
map("n", "<leader>d", function()
  vim.diagnostic.open_float({ scope = "line" })
end, "Diagnostic float (current line)")

-- Show ALL buffer diagnostics in the quickfix list
map("n", "<leader>D", vim.diagnostic.setqflist, "All diagnostics (quickfix)")

map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")

-- Native autocomplete popup navigation (0.12 built-in LSP completion)
local feed = function(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", false)
end

vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    feed("<C-n>")
  else
    feed("<Tab>")
  end
end, { silent = true, desc = "Completion next / Tab" })

vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    feed("<C-p>")
  else
    feed("<S-Tab>")
  end
end, { silent = true, desc = "Completion prev / Shift-Tab" })

vim.keymap.set("i", "<C-j>", function()
  if vim.fn.pumvisible() == 1 then
    feed("<C-n>")
  else
    feed("<C-j>")
  end
end, { silent = true, desc = "Completion next (Ctrl-j)" })

vim.keymap.set("i", "<C-k>", function()
  if vim.fn.pumvisible() == 1 then
    feed("<C-p>")
  else
    feed("<C-k>")
  end
end, { silent = true, desc = "Completion prev (Ctrl-k)" })

-- ---------------------------------------------------------------------------
-- Plugins (vim.pack — native package manager, new in 0.12)
-- ---------------------------------------------------------------------------
-- vim.pack.add() clones a GitHub repo into the pack path and sources it.
-- Packages are stored under XDG_DATA_HOME (set in the launcher script),
-- so nothing touches AppData\Local or ~/.local/share/nvim.
--
-- To add more plugins:
--   vim.pack.add("author/repo")                          -- latest
--   vim.pack.add("author/repo", { version = "v1.2.3" }) -- pinned

local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({ gh("ibhagwan/fzf-lua") })
vim.pack.add({ gh("folke/which-key.nvim") })
vim.pack.add({ gh("Bekaboo/dropbar.nvim") })

vim.pack.add({ gh("folke/snacks.nvim") })
require("snacks").setup({picker = {} })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_picker_input",
  callback = function()
    -- Disable native autocomplete in Snacks picker input so the results list updates live
    vim.opt_local.autocomplete = false
  end,
})

vim.pack.add({ gh("catppuccin/nvim") })
vim.cmd('colorscheme catppuccin-mocha')

vim.pack.add({
    gh("nvim-tree/nvim-web-devicons"),
    gh("nvim-lualine/lualine.nvim")
})
require('lualine').setup({ options = { theme  = 'onedark' }})

vim.pack.add({ gh("akinsho/bufferline.nvim") })
require("bufferline").setup()

-- ---------------------------------------------------------------------------
-- Treesitter — enable native highlighting for common languages
-- ---------------------------------------------------------------------------
-- 0.12 ships treesitter parsers for many languages and enables highlighting
-- automatically via ftplugin for: lua, markdown, help, query.
-- For other languages, start it manually in a FileType autocmd.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "go", "rust", "c", "cpp", "python", "json", "yaml", "toml" },
  callback = function(ev)
    vim.treesitter.start(ev.buf)
  end,
})

-- ---------------------------------------------------------------------------
-- LSP
-- ---------------------------------------------------------------------------
require("lsp")
