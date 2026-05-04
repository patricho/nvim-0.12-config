-- Highlight word under cursor
vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#702020" })
vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#502020" })

-- Indent guides
vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#444444" })
vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#999999" })

-- Diagnostics
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = "#db4b4b", undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = "#0d6987", undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = "#30ac8c", undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = "#ee8019", undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#db4b4b" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#0d6987" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#30ac8c" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#ee8019" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#db4b4b", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#0d6987", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#30ac8c", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ee8019", italic = true })

-- Selection
vim.api.nvim_set_hl(0, "Visual", { bg = "#662200" })

-- Bracket/parentheses pair matching
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#fe8019" })

-- Search
vim.api.nvim_set_hl(0, "Search", { fg = "#d73333" })
vim.api.nvim_set_hl(0, "CurSearch", { fg = "#e72323", bold = true })
vim.api.nvim_set_hl(0, "IncSearch", { fg = "#d73333", bg = "#444444", bold = true })
vim.api.nvim_set_hl(0, "Substitute", { fg = "#ffff00" })

-- Current symbol LSP highlight colors
vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#fe8019" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = "#fe8019" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = "#fe8019", bold = true, underline = true })
vim.api.nvim_set_hl(0, "IlluminatedWordText", { fg = "#fe8019" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { fg = "#fe8019" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { fg = "#fe8019", bold = true, underline = true })

-- Scrollbar
vim.api.nvim_set_hl(0, "SatelliteBar", { bg = "#4C4846" })
