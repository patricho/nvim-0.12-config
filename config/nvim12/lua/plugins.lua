local gh = function(p)
    return "https://github.com/" .. p
end

local ghv = function(p, v)
    return { src = gh(p), version = v }
end

-- Treesitter
vim.pack.add({ ghv("nvim-treesitter/nvim-treesitter", "4916d6592ede8c07973490d9322f187e07dfefac") })

-- Git diff view
vim.pack.add({ ghv("sindrets/diffview.nvim", "4516612fe98ff56ae0415a259ff6361a89419b0a") })

-- Fzf pickers
vim.pack.add({ ghv("ibhagwan/fzf-lua", "97376e364f51f1b5ae3efaa3eb2e929430ca8419") })

-- WhichKey keymap help
vim.pack.add({ ghv("folke/which-key.nvim", "3aab2147e74890957785941f0c1ad87d0a44c15a") })

-- Dropbar breadcrumbs
vim.pack.add({ ghv("Bekaboo/dropbar.nvim", "f0a42bd92aa647e44221397723453403f5e20f16") })

-- Custom marks commands
require("plugins/marks")

-- Icons
vim.pack.add({ ghv("nvim-tree/nvim-web-devicons", "2795c26c916bb3c57dde308b82be51971fa92747") })

-- Git gutter signs, statusline blame
vim.pack.add({ ghv("lewis6991/gitsigns.nvim", "dd3f588bacbeb041be6facf1742e42097f62165d") })
require("gitsigns").setup({
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 250,
        virt_text = false,
    },
})

-- Flash jump
vim.pack.add({ ghv("folke/flash.nvim", "fcea7ff883235d9024dc41e638f164a450c14ca2") })

-- Mini cursor word highlight
vim.pack.add({ ghv("nvim-mini/mini.cursorword", "52eacb10266b8ce07c052e3c80a706d29eb74006") })
require("mini.cursorword").setup({ delay = 50 })

-- Mini surround
vim.pack.add({ ghv("nvim-mini/mini.surround", "990ce30f724d08e79670107de6b915a3f1bb9a9b") })
require("mini.surround").setup()

-- Scrollbar
vim.pack.add({ ghv("lewis6991/satellite.nvim", "87843c9c8f28b54332497302de380a6d94c9e82b") })
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
vim.pack.add({ ghv("folke/snacks.nvim", "ad9ede6a9cddf16cedbd31b8932d6dcdee9b716e") })
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
                hidden = true,
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
vim.pack.add({ ghv("ThorstenRhau/token", "51f39cbbb7154e08741de07996b34baf98703bdf") })
vim.cmd.colorscheme("token")

-- vim.pack.add({ gh("vague-theme/vague.nvim") })
-- require('vague').setup({ transparent = true, italic = false })

-- vim.pack.add({ gh("sainnhe/gruvbox-material") })
-- vim.g.gruvbox_material_enable_italic = true
-- vim.g.gruvbox_material_background = "medium"
-- vim.cmd.colorscheme("gruvbox-material")

-- Lualine status line
vim.pack.add({ ghv("nvim-lualine/lualine.nvim", "131a558e13f9f28b15cd235557150ccb23f89286") })
require("plugins/lualine")

-- Bufferline
-- https://github.com/akinsho/bufferline.nvim/blob/main/doc/bufferline.txt#L827
vim.pack.add({ ghv("akinsho/bufferline.nvim", "655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3") })
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
vim.pack.add({ ghv("stevearc/conform.nvim", "dca1a190aa85f9065979ef35802fb77131911106") })
require("conform").setup({
    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        go = { "goimports", "golines", "gofumpt" },
        markdown = { "prettier" },
        php = { "prettier" },
        twig = { "prettier" },
        javascript = { "prettier" },
        -- https://github.com/stevearc/conform.nvim#formatters
    },
})

-- textwidth follows the project's .prettierrc printWidth
require("plugins/prettier-textwidth")

-- Override gq to bypass LSP-hijacked formatexpr
require("plugins/reflow")

-- LSP completions icons
vim.pack.add({ ghv("onsails/lspkind.nvim", "c7274c48137396526b59d86232eabcdc7fed8a32") })
require("lspkind").init({
    mode = "symbol_text",
    preset = "default",
})

-- Treesitter-highlighted completion labels. Wired into vim.lsp.completion in lsp.lua.
vim.pack.add({ ghv("xzbdmw/colorful-menu.nvim", "196ddf16d5f8fec09ba7f20e6b153aa5188e907b") })
require("colorful-menu").setup({})

-- Git linker
vim.pack.add({
    ghv("nvim-lua/plenary.nvim", "74b06c6c75e4eeb3108ec01852001636d85a932b"),
    ghv("ruifm/gitlinker.nvim", "cc59f732f3d043b626c8702cb725c82e54d35c25")
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
vim.pack.add({ ghv("folke/todo-comments.nvim", "31e3c38ce9b29781e4422fc0322eb0a21f4e8668") })
require("todo-comments").setup()

-- Easy align
vim.pack.add({ ghv("junegunn/vim-easy-align", "9815a55dbcd817784458df7a18acacc6f82b1241") })
vim.g.easy_align_ignore_groups = {} -- { 'Comment', 'String' }
