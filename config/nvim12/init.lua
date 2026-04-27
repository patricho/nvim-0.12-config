require("options")
require("lsp")
require("plugins")

-- ---------------------------------------------------------------------------
-- Treesitter
-- ---------------------------------------------------------------------------
-- 0.12 ships treesitter parsers for many languages and enables highlighting
-- automatically via ftplugin for: lua, markdown, help, query. For other
-- languages, start it manually in a FileType autocmd.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "go", "rust", "c", "cpp", "python", "json", "yaml", "toml" },
    callback = function(ev)
        vim.treesitter.start(ev.buf)
    end,
})

-- ---------------------------------------------------------------------------
-- LSP
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------------------
-- Keymaps
-- ---------------------------------------------------------------------------

local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

local feed = function(keys)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", false)
end

-- Editing
map("n", "U", "<cmd>redo<cr>", "Redo")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Window left")
map("n", "<C-j>", "<C-w>j", "Window down")
map("n", "<C-k>", "<C-w>k", "Window up")
map("n", "<C-l>", "<C-w>l", "Window right")

-- Buffer navigation
map("n", "<s-tab>", "<cmd>bprev<cr>", "Prev buffer")
map("n", "<tab>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>c", "<cmd>bdelete<cr>", "[C]lose buffer")
map("n", "<leader>w", "<cmd>write<cr>", "[W]rite buffer")

-- Pickers and search
map("n", "<leader>e", function() Snacks.explorer.reveal() end, "Snacks [E]xplorer")
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", "[F]ind [f]iles")
map("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", "[F]ind [w]ords")
map("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", "[F]ind document [s]ymbols")
map("n", "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", "[F]ind workspace [S]ymbols")
map("n", "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", "[F]ind document [d]iagnostics")
map("n", "<leader>fD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", "[F]ind workspace [D]iagnostics")
map("n", "<esc>", "<cmd>nohlsearch<CR>", "Clear search highlights")

-- Quickfix
map("n", "]q", "<cmd>cnext<cr>", "Next quickfix")
map("n", "[q", "<cmd>cprev<cr>", "Prev quickfix")

-- Diagnostics
map("n", "<leader>d", function() vim.diagnostic.open_float({ scope = "line" }) end, "Diagnostic float (current line)")
map("n", "<leader>D", vim.diagnostic.setqflist, "All diagnostics (quickfix)")
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")

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
        bmap("n", "gi", vim.lsp.buf.definition, "Go to implementation")
        bmap("n", "gd", vim.lsp.buf.declaration, "[G]o to [D]eclaration")
        bmap("n", "<leader>r", vim.lsp.buf.rename, "[R]ename symbol")
        bmap("n", "<leader>a", vim.lsp.buf.code_action, "Code [A]ction")
        bmap("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "[L]SP [F]ormat")
    end,
})

-- Highlights and colors
vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#a00000" })
vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#602020" })

