vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.signcolumn     = "yes"
vim.opt.cursorline     = true
vim.opt.wrap           = false
vim.opt.scrolloff      = 8
vim.opt.sidescrolloff  = 8
vim.opt.cmdheight      = 1
vim.opt.mouse          = "a"
vim.opt.showmode       = false
vim.opt.breakindent    = true
vim.opt.updatetime     = 250
vim.opt.timeoutlen     = 300
vim.opt.list           = true
vim.opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.textwidth      = 80

vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true

vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.hlsearch       = true
vim.opt.incsearch      = true

vim.opt.splitright     = true
vim.opt.splitbelow     = true

vim.opt.undofile       = true
vim.opt.swapfile       = false

vim.opt.termguicolors  = true
vim.opt.guicursor      = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.winborder      = "rounded" -- 0.12: native rounded borders everywhere
vim.opt.completeopt    = "menu,menuone,noinsert,popup"
vim.opt.autocomplete   = true      -- 0.12: native auto-completion
vim.o.complete         = "o,.,i"   -- o: Omnifunc (LSP), .: Current buffer, i: Included files

-- Use system clipboard
vim.opt.clipboard      = "unnamedplus"

-- Leader
vim.g.mapleader        = " "
vim.g.maplocalleader   = "\\"

-- New UI opt-in
require("vim._core.ui2").enable({})

-- Preview substitutions live, as you type
vim.opt.inccommand = "split"

-- Diagnostics
vim.diagnostic.config({
    virtual_text = {
        current_line = true,
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
