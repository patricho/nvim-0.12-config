-- C# LSP Config (.NET)
--
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/csharp_ls.lua
--
-- Install:
--  - winget install Microsoft.DotNet.SDK.10
--  - dotnet tool install --global csharp-ls
--
-- OR download OmniSharp release: https://github.com/OmniSharp/omnisharp-roslyn/releases

-- Default to static completion for SQL, and disable default keymaps
-- https://github.com/neovim/neovim/issues/14433#issuecomment-1183682651
-- https://www.reddit.com/r/vim/comments/2om1ib/comment/cmop4zh/
vim.g.omni_sql_default_compl_type = "syntax"
vim.g.omni_sql_no_default_maps = 1

return {
    cmd = function(dispatchers, config)
        return vim.lsp.rpc.start({ 'csharp-ls' }, dispatchers, {
            -- csharp-ls attempt to locate sln, slnx or csproj files from cwd, so set cwd to root directory.
            -- If cmd_cwd is provided, use it instead.
            cwd = config.cmd_cwd or config.root_dir,
            env = config.cmd_env,
            detached = config.detached,
        })
    end,
    filetypes = { "cs", "vb" },
    root_markers = { "*.sln", "*.csproj", "omnisharp.json", ".git" },
    init_options = {
        AutomaticWorkspaceInit = true,
    },
    get_language_id = function(_, ft)
        if ft == 'cs' then
            return 'csharp'
        end
        return ft
    end,
}
