require("options")
require("lsp")
require("plugins")
require("treesitter")

-- ---------------------------------------------------------------------------
-- Keymaps
-- ---------------------------------------------------------------------------

local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

local feed = function(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", false)
end

-- Which Key groups
require("which-key").add({
    { "<leader>f", group = "Find/search" },
    { "<leader>g", group = "Git" },
    { "<leader>l", group = "LSP" },
    { "<leader>W", group = "Windows" },
})

-- Editing
map("n", "U", "<cmd>redo<cr>", "Redo")
map("n", "c", '"_c', "Change without yank")
map("n", "C", '"_C', "Change without yank")
map("n", "s", '"_s', "Change without yank")
map("n", "S", '"_S', "Change without yank")
map("n", "x", '"_x', "Delete without yank")
map("n", "X", '"_X', "Delete without yank")
map("n", "r", '"_ciw', "Change inner word")
map("n", "R", '"_ciW', "Change inner Word")
map("n", "§", "yiw", "Yank inner word")
map("n", "°", '"_diwP', "Paste inner word")
map("n", "½", '"_diwP', "Paste inner word")
map("n", "ö", '"_dd', "Delete row")
map("n", "Ö", 'ma"8yy"8p`a', "Duplicate line")
map("n", "Ä", "maO<Esc>`a", "Insert empty line above")
map("n", "ä", "mao<Esc>`a", "Insert empty line below")
map("v", "Ö", '"8y"8P', "Duplicate selected lines")
map("v", "p", '"_dP', "Paste over selection without yanking")
map("v", "c", '"_c', "Change without yank")
map("v", "C", '"_C', "Change without yank")

-- Windows
map("n", "<C-h>", "<C-w>h", "Window go left")
map("n", "<C-j>", "<C-w>j", "Window go down")
map("n", "<C-k>", "<C-w>k", "Window go up")
map("n", "<C-l>", "<C-w>l", "Window go right")
map("n", "<leader>Wh", "<C-w>v<C-w>h", "[W]indow [s]plit left")
map("n", "<leader>Wl", "<C-w>v", "[W]indow [s]plit right")
map("n", "<leader>Wk", "<C-w>s<C-w>k", "[W]indow [s]plit up")
map("n", "<leader>Wj", "<C-w>s", "Window split down")
map("n", "<leader>Wc", "<C-w>q", "Window close")

-- Buffer navigation
map("n", "<s-tab>", "<cmd>bprev<cr>", "Prev buffer")
map("n", "<tab>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>c", "<cmd>bdelete<cr>", "[C]lose buffer")
map("n", "<leader>w", "<cmd>write<cr>", "[W]rite buffer")

-- Pickers and search
map("n", "<leader>e", function() Snacks.explorer.reveal() end, "Snacks [E]xplorer")
map("n", "<leader>ff", function() Snacks.picker('git_files') end, "[F]ind [f]iles")
map("n", "<leader>fF", function() Snacks.picker('files') end, "[F]ind all [F]iles")
map("n", "<leader>fw", function() Snacks.picker('git_grep') end, "[F]ind [w]ords")
map("n", "<leader>fW", function() Snacks.picker('grep') end, "[F]ind [W]ords in all files")
map("n", "<leader>fs", function() Snacks.picker('lsp_symbols') end, "[F]ind buffer [s]ymbols")
map("n", "<leader>fS", function() Snacks.picker('lsp_workspace_symbols') end, "[F]ind workspace [S]ymbols")
map("n", "<leader>fd", function() Snacks.picker('diagnostics_buffer') end, "[F]ind buffer [d]iagnostics")
map("n", "<leader>fD", function() Snacks.picker('diagnostics') end, "[F]ind workspace [D]iagnostics")
map("n", "<leader>fc", function() Snacks.picker('grep_word') end, "[F]ind word under [c]ursor")
map("v", "<leader>fc", function() Snacks.picker('grep_word') end, "[F]ind selected words under [c]ursor")
map("n", "<leader>fC", "<cmd>FzfLua grep_cWORD<cr>", "[F]ind WORD under [C]ursor")
map("n", "<leader>fh", "<cmd>FzfLua history<cr>", "[F]ind buffer [H]istory")
map("n", "<esc>", "<cmd>nohlsearch<CR>", "Clear search highlights")
-- ["-"] = { function() require("flash").jump() end, desc = "Flash jump" },

-- Quickfix
map("n", "]q", "<cmd>cnext<cr>", "Next quickfix")
map("n", "[q", "<cmd>cprev<cr>", "Prev quickfix")

-- Diagnostics
map("n", "<leader>d", function() vim.diagnostic.open_float({ scope = "line" }) end, "Diagnostic float (current line)")
map("n", "<leader>D", vim.diagnostic.setqflist, "All diagnostics (quickfix)")
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")

-- Git
local gitsigns = require('gitsigns')
map('n', '<leader>gs', gitsigns.stage_hunk, 'GitSigns: Stage hunk')
map('n', '<leader>gr', gitsigns.reset_hunk, 'GitSigns: Reset hunk')
map('v', '<leader>gs', function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'GitSigns: Stage hunk')
map('v', '<leader>gr', function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, 'GitSigns: Reset hunk')
map('n', '<leader>gS', gitsigns.stage_buffer, 'GitSigns: Stage buffer')
map('n', '<leader>gR', gitsigns.reset_buffer, 'GitSigns: Reset buffer')
map('n', '<leader>gbl', gitsigns.blame_line, 'GitSigns: Blame (line)')
map('n', '<leader>gbb', gitsigns.blame, 'GitSigns: Blame (buffer)')
map('n', '<leader>gg', function() Snacks.lazygit.open() end, '[G]it open Lazy[G]it')
map("n", "<leader>gG", "<cmd>FzfLua git_status<cr>", "[G]it open FzfLua [G]it status")

-- Native autocomplete popup navigation
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

-- LSP buffer-local keymaps (0.12 native defaults: grn=rename, gra=code action, grr=references, gri=impl)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        local bmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
        end

        bmap("n", "K", vim.lsp.buf.hover, "Hover docs")
        bmap("n", "gh", vim.lsp.buf.hover, "Hover docs")
        bmap("n", "<leader>h", vim.lsp.buf.hover, "Hover docs")
        bmap("n", "gr", vim.lsp.buf.rename, "[G]o [R]ename symbol")
        bmap("n", "<leader>r", vim.lsp.buf.rename, "[R]ename symbol")
        bmap("n", "ga", vim.lsp.buf.code_action, "[G]o code [A]ction")
        bmap("n", "<leader>a", vim.lsp.buf.code_action, "Code [A]ction")
        bmap("n", "gi", vim.lsp.buf.definition, "Go to implementation")
        bmap("n", "gd", vim.lsp.buf.declaration, "[G]o to [D]eclaration")
        bmap("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "[L]SP [F]ormat buffer")
    end,
})

-- Highlights and colors
vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#a00000" })
vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#602020" })
