-- Automatic session management:
--   - A session named after the current CWD is always saved on exit
--   - If a session with matching name exists on startup, it is automatically loaded

local function session_path()
    local name = vim.fn.getcwd():gsub("[/\\:]", "_")
    return vim.fn.stdpath("data") .. "/sessions/" .. name .. ".vim"
end

vim.api.nvim_create_autocmd("VimEnter", {
    nested = true,
    callback = function()
        if vim.fn.argc() > 0 then return end
        local path = session_path()
        if vim.fn.filereadable(path) == 1 then
            vim.cmd("silent! source " .. vim.fn.fnameescape(path))
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        local path = session_path()
        vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
        vim.cmd("mksession! " .. vim.fn.fnameescape(path))
    end,
})
