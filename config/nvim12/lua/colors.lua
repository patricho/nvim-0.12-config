-- Highlight word under cursor
vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#a00000" })
vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#602020" })

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#f38ba8", underline = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { sp = "#f9e2af", underline = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { sp = "#89b4fa", underline = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { sp = "#a6e3a1", underline = true })

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticSignError" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn",  { link = "DiagnosticSignWarn" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo",  { link = "DiagnosticSignInfo" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint",  { link = "DiagnosticSignHint" })
