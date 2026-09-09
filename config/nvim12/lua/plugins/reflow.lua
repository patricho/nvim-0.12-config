-- gq that ignores any LSP-provided formatexpr, so comment prose always wraps
-- via Neovim's built-in formatter. Some servers (e.g. ts_ls) set formatexpr
-- on attach, which hijacks gq and skips comment reflow.
local M = {}

local function gq_ignoring_lsp(run)
    local buf = vim.api.nvim_get_current_buf()
    local saved = vim.bo[buf].formatexpr
    vim.bo[buf].formatexpr = ""
    run()
    vim.bo[buf].formatexpr = saved
end

-- Called via operatorfunc after a motion, e.g. <leader>gqip
function M.operator()
    gq_ignoring_lsp(function()
        vim.cmd("normal! `[gq`]")
    end)
end

-- Override gq/gqgq/gqq/gq{visual} outright: this replaces the built-in
-- formatter for good, not an alternate binding alongside it.
vim.keymap.set("n", "gq", function()
    vim.o.operatorfunc = "v:lua.require'plugins.reflow'.operator"
    return "g@"
end, { expr = true, desc = "Reflow (ignore LSP formatexpr)" })

-- "_" is the linewise "current line, [count] times" motion — the same trick
-- Vim's own doubled operators (dd, yy, gqgq/gqq) use under the hood.
vim.keymap.set("n", "gqq", function()
    vim.o.operatorfunc = "v:lua.require'plugins.reflow'.operator"
    return "g@_"
end, { expr = true, desc = "Reflow current line (ignore LSP formatexpr)" })

vim.keymap.set("n", "gqgq", function()
    vim.o.operatorfunc = "v:lua.require'plugins.reflow'.operator"
    return "g@_"
end, { expr = true, desc = "Reflow current line (ignore LSP formatexpr)" })

-- This callback runs while still in Visual mode (unlike a legacy :vnoremap
-- ...:<C-u>call), so the selection is already active — no need to reselect.
vim.keymap.set("x", "gq", function()
    gq_ignoring_lsp(function()
        vim.cmd("normal! gq")
    end)
end, { desc = "Reflow selection (ignore LSP formatexpr)" })

return M
