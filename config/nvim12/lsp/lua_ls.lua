-- lua-language-server config
-- Install: winget install LuaLS.lua-language-server
-- or: https://github.com/LuaLS/lua-language-server/releases
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",  -- Neovim uses LuaJIT
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Include the pack path so lua_ls knows about installed plugins
          vim.fn.stdpath("data") .. "/site",
        },
      },
      diagnostics = {
        globals = { "vim" },
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,  -- inlay hints
      },
    },
  },
}
