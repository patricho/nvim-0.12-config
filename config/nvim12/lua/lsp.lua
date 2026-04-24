-- =============================================================================
-- LSP configuration
-- =============================================================================
-- 0.12 ships lsp/ configs for common servers. You can override/extend them
-- by placing files in config/lsp/<server-name>.lua (this config folder).
--
-- Enable servers — vim.lsp.enable() reads from:
--   1. $VIMRUNTIME/lsp/<name>.lua  (built-in defaults)
--   2. config/lsp/<name>.lua       (your overrides, merged on top)
--
vim.lsp.enable({
  "lua_ls",
  "ts_ls",       -- typescript-language-server (tsserver successor)
  "gopls",
  "omnisharp",
  "rust_analyzer",
})

-- Keymaps (in addition to 0.12 defaults: grn, gra, grr, gri, grt, grx)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    local buf = args.buf
    local bmap = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
    end

    bmap("n", "K",          vim.lsp.buf.hover,           "Hover docs")
    bmap("n", "gd",         vim.lsp.buf.definition,      "Go to definition")
    bmap("n", "gD",         vim.lsp.buf.declaration,     "Go to declaration")
    bmap("n", "<leader>rn", vim.lsp.buf.rename,          "Rename symbol")
    bmap("n", "<leader>ca", vim.lsp.buf.code_action,     "Code action")
    bmap("n", "<leader>f",  function() vim.lsp.buf.format({ async = true }) end, "Format")

    --if client:supports_method("textDocument/inlayHint") then
    --  vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    --end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end
  end,
})

-- ---------------------------------------------------------------------------
-- LSP debug helper — run :LspStatus
-- ---------------------------------------------------------------------------
function _G.LspStatus()
  local buf = vim.api.nvim_get_current_buf()
  local ft  = vim.bo[buf].filetype
  local clients = vim.lsp.get_clients({ bufnr = buf })

  local lines = {
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
