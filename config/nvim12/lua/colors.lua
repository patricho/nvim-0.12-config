local function extend_highlight(from, to, overrides)
    local ok, base = pcall(vim.api.nvim_get_hl, 0, { name = from, link = false })
    if not ok or vim.tbl_isempty(base) then
        return false
    end
    base.default = nil
    vim.api.nvim_set_hl(0, to, vim.tbl_extend("force", base, overrides))
    return true
end

-- Completion popup
vim.api.nvim_set_hl(0, "PmenuKind", { fg = "#666666" })

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

-- Yank
vim.api.nvim_set_hl(0, "YankHighlight", { fg = "#fe8019", bg = "#500f08" })

-- Bracket/parentheses pair matching
vim.api.nvim_set_hl(0, "MatchParenCur", { fg = "#fe8019", bg = "#500f08", bold = true })
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#fe8019", bg = "#500f08", bold = true })

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

-- Statuscolumn mark icon
vim.api.nvim_set_hl(0, "StatusColumnMark", { fg = "#fe8019" })

-- Scrollbar
vim.api.nvim_set_hl(0, "SatelliteBackground", { bg = "none" })
vim.api.nvim_set_hl(0, "SatelliteBar", { bg = "#333333" })
vim.api.nvim_set_hl(0, "SatelliteCursor", { fg = "#eeeeee" })
vim.api.nvim_set_hl(0, "SatelliteSearch", { link = "Search" })
vim.api.nvim_set_hl(0, "SatelliteMark", { fg = "#fe8019", bg = "#333333" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

-- Dropbar breadcrumbs
vim.api.nvim_set_hl(0, "WinBar", { fg = "#9D8761", bg = "#262624", bold = false })
vim.api.nvim_set_hl(0, "DropBarKindFile", { bold = true })

-- Bufferline/statusline default styling
vim.api.nvim_set_hl(0, "StatusLineMain", { bg = "#141413", fg = "#838C9C" })
vim.api.nvim_set_hl(0, "StatusLineDimmed", { bg = "#141413", fg = "#636C7C" })

-- Bufferline
-- extend_highlight("BufferLineFill", "BufferLineFill", { bg = "#222222" })
-- extend_highlight("BufferLineSeparator", "BufferLineSeparator", { fg = "#222222" })
-- extend_highlight("BufferLineSeparatorSelected", "BufferLineSeparatorSelected", { fg = "#222222" })

-- Git diff
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#0f4412" })
vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#962623" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#466570" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#25343c" })

-- Transparent background
extend_highlight("Normal", "Normal", { bg = "none" })
extend_highlight("LineNr", "LineNr", { bg = "none" })
