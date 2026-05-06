-- 0.12 ships lsp/ configs for common servers. You can override/extend them
-- by placing files in config/lsp/<server-name>.lua.
--
-- Enable servers — vim.lsp.enable() reads from:
-- 1. $VIMRUNTIME/lsp/<name>.lua  (built-in defaults)
-- 2. config/lsp/<name>.lua       (your overrides, merged on top)

vim.lsp.enable({
    "gopls",
    "lua_ls",
    "omnisharp",
    "rust_analyzer",
    "ts_ls",
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        local buf = args.buf

        -- Enable LSP completions
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        end

        -- Format buffer on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = buf,
            callback = function()
                vim.lsp.buf.format({ bufnr = buf, async = false })
            end,
        })

        -- Highlight symbol references under the cursor
        if client:supports_method("textDocument/documentHighlight", buf) then
            local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. buf, { clear = true })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = group,
                buffer = buf,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = group,
                buffer = buf,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- ---------------------------------------------------------------------------
-- LSP debug helper — run :LspStatus
-- ---------------------------------------------------------------------------
function _G.LspStatus()
    local buf     = vim.api.nvim_get_current_buf()
    local ft      = vim.bo[buf].filetype
    local clients = vim.lsp.get_clients({ bufnr = buf })

    local lines   = {
        "=== LSP Status ===",
        "Buffer: " .. buf .. "  Filetype: " .. (ft == "" and "<empty>" or ft),
        "Clients attached: " .. #clients,
    }

    if #clients == 0 then
        table.insert(lines, "  (none — server probably not installed or not started)")
    else
        for _, c in ipairs(clients) do
            table.insert(lines, "  • " .. c.name .. " (id=" .. c.id .. ")")
        end
    end

    local diags = vim.diagnostic.get(buf)
    table.insert(lines, "Diagnostics in buffer: " .. #diags)
    if #diags > 0 then
        for _, d in ipairs(diags) do
            local sev = vim.diagnostic.severity[d.severity] or "?"
            table.insert(lines, string.format("  [%s] L%d: %s", sev, d.lnum + 1, d.message:gsub("\n", " ")))
        end
    end

    -- Print to :messages
    for _, l in ipairs(lines) do
        vim.notify(l, vim.log.levels.INFO)
    end
end

vim.api.nvim_create_user_command("LspStatus", function() _G.LspStatus() end, { desc = "Show LSP/diagnostic status" })
