local gh = function(p)
    return "https://github.com/" .. p
end

-- Treesitter
vim.pack.add({ gh("nvim-treesitter/nvim-treesitter") })

-- Git diff view
vim.pack.add({ gh("sindrets/diffview.nvim") })

-- Fzf pickers
vim.pack.add({ gh("ibhagwan/fzf-lua") })

-- WhichKey keymap help
vim.pack.add({ gh("folke/which-key.nvim") })

-- Dropbar breadcrumbs
vim.pack.add({ gh("Bekaboo/dropbar.nvim") })

-- Custom marks commands
require("plugins/marks")

-- Icons
vim.pack.add({ gh("nvim-tree/nvim-web-devicons") })

-- Git gutter signs, statusline blame
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
require("gitsigns").setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 250,
        virt_text = false,
    },
})

-- Flash jump
vim.pack.add({ gh("folke/flash.nvim") })

-- Mini cursor word highlight
vim.pack.add({ gh("nvim-mini/mini.cursorword") })
require("mini.cursorword").setup({ delay = 50 })

-- Mini surround
vim.pack.add({ gh("nvim-mini/mini.surround") })
require("mini.surround").setup()

-- Scrollbar
vim.pack.add({ gh("lewis6991/satellite.nvim") })
require("satellite").setup({
    winblend = 0, -- Transparency
    handlers = {
        cursor = {
            symbols = { "" }
        },
    },
})
local handlers = require("satellite.handlers")
-- init() is normally called lazily on first render; call it now so the
-- builtin handlers (including "marks") are registered before we patch.
handlers.init()
for _, h in ipairs(handlers.handlers) do
    if h.name == "marks" then
        local orig = h.update
        h.update = function(bufnr, winid)
            local marks = orig(bufnr, winid)
            for _, m in ipairs(marks) do
                m.symbol = ""
            end
            return marks
        end
        break
    end
end

-- Snacks
vim.pack.add({ gh("folke/snacks.nvim") })
require("snacks").setup({
    explorer = {},
    lazygit = {},
    notifier = {},
    picker = {
        sources = {
            git_grep = {
                ignorecase = true,
            },
            explorer = {
                auto_close = true,
                jump = { close = true },
                layout = {
                    -- https://github.com/folke/snacks.nvim/blob/ad9ede6a9cddf16cedbd31b8932d6dcdee9b716e/doc/snacks.nvim-picker.txt#L93
                    preset = "default",
                    reverse = false,
                    preview = "preview",
                    layout = { height = 0.9 }
                }
            }
        }
    },
    indent = {
        indent = { char = "│" },
        animate = { enabled = false }
    },
})

-- Custom statuscolumn
vim.o.statuscolumn = [[%!v:lua.require'plugins.statuscolumn'.get()]]

vim.api.nvim_create_autocmd("FileType", {
    pattern = "snacks_picker_input",
    callback = function()
        -- Disable native autocomplete in Snacks picker input so the results list updates live
        vim.opt_local.autocomplete = false
    end,
})

-- Color schemes
vim.pack.add({ gh("ThorstenRhau/token") })
vim.cmd.colorscheme("token")

-- vim.pack.add({ gh("vague-theme/vague.nvim") })
-- require('vague').setup({ transparent = true, italic = false })

-- vim.pack.add({ gh("sainnhe/gruvbox-material") })
-- vim.g.gruvbox_material_enable_italic = true
-- vim.g.gruvbox_material_background = "medium"
-- vim.cmd.colorscheme("gruvbox-material")

-- Lualine status line
vim.pack.add({ gh("nvim-lualine/lualine.nvim") })
require("plugins/lualine")

-- Bufferline
-- https://github.com/akinsho/bufferline.nvim/blob/main/doc/bufferline.txt#L827
vim.pack.add({ gh("akinsho/bufferline.nvim") })
local bl = require("bufferline")
bl.setup({
    options = {
        color_icons = true,
        separator_style = "slant",
        style_preset = {
            bl.style_preset.no_italic,
        },
    },
})

-- Conform formatter
vim.pack.add({ gh("stevearc/conform.nvim") })
require("conform").setup({
    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        markdown = { "prettier" },
        php = { "prettier" },
        twig = { "prettier" },
        -- https://github.com/stevearc/conform.nvim#formatters
    },
})

-- LSP completions icons
vim.pack.add({ gh("onsails/lspkind.nvim") })
require("lspkind").init({
    mode = "symbol_text",
    preset = "default",
})

-- Git linker
vim.pack.add({
    gh("nvim-lua/plenary.nvim"),
    gh("ruifm/gitlinker.nvim")
})
require("gitlinker").setup({
    mappings = nil,
    callbacks = {
        ["github.com"] = require("gitlinker.hosts").get_github_type_url,
        ["bitbucket.org"] = require("gitlinker.hosts").get_bitbucket_type_url,
        ["patrik_bauhn"] = function(url_data)
            local url = "https://bitbucket.org/" .. url_data.repo .. "/src/" .. url_data.rev .. "/" .. url_data.file
            if url_data.lstart then
                url = url .. "#lines-" .. url_data.lstart
                if url_data.lend then url = url .. ":" .. url_data.lend end
            end
            return url
        end,
    },
})

-- Todo comments
vim.pack.add({ gh("folke/todo-comments.nvim") })
require("todo-comments").setup()
