local parsers = {
    "go",
    "javascript",
    "json",
    "lua",
    "php",
    "rust",
    "typescript",
    "yaml",
    "zig",
}

local ts = require("nvim-treesitter")
ts.setup({})
ts.install(parsers)

-- Not every tree-sitter parser is the same as the file type detected
-- So the patterns need to be registered more cleverly
local patterns = {}
for _, parser in ipairs(parsers) do
    local parser_patterns = vim.treesitter.language.get_filetypes(parser)
    for _, pp in pairs(parser_patterns) do
        table.insert(patterns, pp)
    end
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = patterns,
    callback = function(ev)
        vim.treesitter.start(ev.buf)
    end,
})
