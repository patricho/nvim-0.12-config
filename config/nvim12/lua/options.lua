vim.g.mapleader        = " " -- Leader key
vim.g.maplocalleader   = "\\" -- Local leader key
vim.opt.autocomplete   = true -- Native autocomplete
vim.opt.breakindent    = true -- Wrapped-line indent
vim.opt.clipboard      = "unnamedplus" -- System clipboard
vim.opt.cmdheight      = 0 -- Command line height
vim.opt.complete       = "o,.,i" -- Completion sources
vim.opt.completeopt    = "menu,menuone,noinsert,noselect,popup" -- Completion menu
vim.opt.cursorline     = true -- Cursor line
vim.opt.expandtab      = true -- Spaces for tabs
vim.opt.guicursor      = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50" -- Cursor shape
vim.opt.hlsearch       = true -- Search highlights
vim.opt.ignorecase     = true -- Case-insensitive search
vim.opt.incsearch      = true -- Live search
vim.opt.list           = true -- Whitespace display
vim.opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" } -- Whitespace markers
vim.opt.mouse          = "a" -- Mouse support
vim.opt.number         = true -- Line numbers
vim.opt.relativenumber = true -- Relative numbers
vim.opt.scrolloff      = 8 -- Vertical padding
vim.opt.shiftwidth     = 4 -- Indent width
vim.opt.showmode       = false -- Mode text
vim.opt.sidescrolloff  = 8 -- Horizontal padding
vim.opt.signcolumn     = "yes" -- Sign gutter
vim.opt.smartcase      = true -- Uppercase-sensitive search
vim.opt.smartindent    = true -- Smart indent
vim.opt.splitbelow     = true -- Below splits
vim.opt.splitright     = true -- Right splits
vim.opt.swapfile       = false -- Swap files
vim.opt.tabstop        = 4 -- Tab width
vim.opt.termguicolors  = true -- True color
vim.opt.textwidth      = 80 -- Text width
vim.opt.timeoutlen     = 300 -- Mapping timeout
vim.opt.undofile       = true -- Persistent undo
vim.opt.updatetime     = 250 -- Idle update delay
vim.opt.winborder      = "rounded" -- Float borders
vim.opt.wrap           = false -- Line wrapping

require("vim._core.ui2").enable({}) -- New UI layer

vim.opt.inccommand = "split" -- Substitution preview

-- Diagnostics
vim.diagnostic.config({
    virtual_text = {
        source = "if_many",
        prefix = "●",
        spacing = 20,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●", --"",
            [vim.diagnostic.severity.WARN] = "●", --"",
            [vim.diagnostic.severity.INFO] = "●", --"",
            [vim.diagnostic.severity.HINT] = "●", --"",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
})
