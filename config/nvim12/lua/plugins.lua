-- vim.pack.add() clones a GitHub repo into the pack path and sources it.
-- Packages are stored under XDG_DATA_HOME.

local gh = function(p) return "https://github.com/" .. p end

-- Treesitter
vim.pack.add({ gh("nvim-treesitter/nvim-treesitter") })

-- Fzf pickers
vim.pack.add({ gh("ibhagwan/fzf-lua") })

-- WhichKey keymap help
vim.pack.add({ gh("folke/which-key.nvim") })

-- Dropbar breadcrumbs
vim.pack.add({ gh("Bekaboo/dropbar.nvim") })

-- Icons
vim.pack.add({ gh("nvim-tree/nvim-web-devicons") })

-- Git gutter signs
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })

-- Mini: Cursor word highlight
vim.pack.add({ gh("nvim-mini/mini.cursorword") })
require("mini.cursorword").setup({ delay = 50 })

-- Snacks pickers
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
                    preset = "telescope",
                    reverse = false,
                    preview = "preview",
                    layout = { height = 0.9 }
                }
            }
        }
    }
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_picker_input",
  callback = function()
    -- Disable native autocomplete in Snacks picker input so the results list updates live
    vim.opt_local.autocomplete = false
  end,
})

-- Catpuccin color scheme
vim.pack.add({ gh("catppuccin/nvim") })
vim.cmd("colorscheme catppuccin-mocha")

-- Lualine status line
vim.pack.add({ gh("nvim-lualine/lualine.nvim") })
require("lualine").setup({ options = { theme  = "onedark" }})

-- Bufferline
vim.pack.add({ gh("akinsho/bufferline.nvim") })
require("bufferline").setup()

