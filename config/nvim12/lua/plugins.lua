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
require("satellite").setup()

-- Snacks
vim.pack.add({ gh("folke/snacks.nvim") })
require("snacks").setup({
    explorer = {},
    lazygit = {},
    picker = {
        sources = {
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
    statuscolumn = {},
    indent = {
        indent = { char = "│", },
        animate = { enabled = false, }
    }
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "snacks_picker_input",
    callback = function()
        -- Disable native autocomplete in Snacks picker input so the results list updates live
        vim.opt_local.autocomplete = false
    end,
})

-- Color schemes
vim.pack.add({ gh("vague-theme/vague.nvim") })
require('vague').setup({
    transparent = true,
    italic = false,
})
vim.cmd.colorscheme("vague")
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
require("bufferline").setup()

-- Conform formatter
vim.pack.add({ gh("stevearc/conform.nvim") })
require("conform").setup({
    format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        go = { "goimports", "gofumpt" },
        php = { "prettier" },
        -- https://github.com/stevearc/conform.nvim#formatters
    },
})
