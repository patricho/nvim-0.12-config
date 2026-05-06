local function lsp_client_name()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        return ""
    end

    return clients[1].name
end

local function truncate_commit_summary(summary)
    if #summary <= 50 then
        return summary
    end

    return summary:sub(1, 50) .. "..."
end

local function author_initials(author)
    local initials = {}

    for part in author:gmatch("%S+") do
        table.insert(initials, part:sub(1, 1):upper())
    end

    return table.concat(initials, "")
end

local function current_line_blame()
    local blame = vim.b.gitsigns_blame_line_dict
    if not blame or blame.author == "Not Committed Yet" then
        return ""
    end

    local author = author_initials(blame.author or "Unknown")
    local summary = truncate_commit_summary(blame.summary or "")
    local date = blame.author_time and os.date("%y%m%d", blame.author_time) or ""

    if date == "" then
        return string.format("%s [%s]", summary, author)
    end

    return string.format("%s [%s %s]", summary, author, date)
end

local function recording_register()
    local reg = vim.fn.reg_recording()
    if reg == "" then
        return ""
    end

    return "@" .. reg
end

local function has_cmd_info()
    return vim.o.cmdheight == 0
end

require("lualine").setup({
    options = {
        theme = "gruvbox",
        component_separators = { left = '', right = '', color = { fg = 'green' } },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
            {
                "filename",
            },
            {
                "searchcount",
                cond = has_cmd_info,
                icon = "",
                color = { fg = "#f75353" },
                fmt = function(str)
                    return str:gsub("^%[", ""):gsub("%]$", "")
                end,
            },
            {
                recording_register,
                cond = has_cmd_info,
                icon = "",
                color = { fg = "#fe8019" },
            },
            {
                "showcmd",
                cond = has_cmd_info,
                icon = "",
                color = { fg = "#d4be98", bg = "#3c3836" },
            },
        },
        lualine_x = {
            {
                current_line_blame,
                icon = "",
            },
            {
                lsp_client_name,
                icon = "",
                color = { fg = "#7daea3" },
            },
            -- "encoding",
            "fileformat",
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
