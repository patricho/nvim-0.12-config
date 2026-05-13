local function lsp_client_name()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        return ""
    end

    local client_names = {}

    for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
    end

    return table.concat(client_names, " ")
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

local function showcmd()
    return vim.api.nvim_eval_statusline("%S", {}).str
end

local function has_cmd_info()
    return vim.o.cmdheight == 0
end

require("lualine").setup({
    options = {
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
            "filename",
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
                showcmd,
                cond = has_cmd_info,
                icon = "",
                color = { fg = "#ffffff" },
            },
        },
        lualine_x = {
            {
                current_line_blame,
                icon = "",
                color = { fg = "#777777" },
            },
            {
                lsp_client_name,
                icon = "",
                color = { fg = "#7daea3" },
            },
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
