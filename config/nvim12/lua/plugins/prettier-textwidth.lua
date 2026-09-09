-- Match textwidth to the project's nearest .prettierrc printWidth, so gq
-- wraps comments at the same width Prettier wraps code.
local function prettier_print_width(filename)
    local config_path = vim.fs.find(
        { ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml" },
        { upward = true, path = vim.fs.dirname(filename) }
    )[1]
    if not config_path then
        return nil
    end

    local ok_read, lines = pcall(vim.fn.readfile, config_path)
    if not ok_read then
        return nil
    end
    local ok_json, config = pcall(vim.json.decode, table.concat(lines, "\n"))
    if not ok_json or type(config) ~= "table" then
        return nil
    end

    -- NOTE: matches by file extension only (e.g. ".php"), not full glob
    -- patterns, so a pattern like "*.html.twig" also matches "*.twig" files.
    local ext_suffix = "." .. vim.fn.fnamemodify(filename, ":e")
    for _, override in ipairs(config.overrides or {}) do
        for _, pattern in ipairs(override.files or {}) do
            if pattern:sub(-#ext_suffix) == ext_suffix and override.options and override.options.printWidth then
                return override.options.printWidth
            end
        end
    end

    return config.printWidth or 80 -- 80 is Prettier's own default when unset
end

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("prettier_textwidth", { clear = true }),
    callback = function(event)
        local filename = vim.api.nvim_buf_get_name(event.buf)
        if filename == "" then
            return
        end
        local width = prettier_print_width(filename)
        if width then
            vim.bo[event.buf].textwidth = width
        end
    end,
})
