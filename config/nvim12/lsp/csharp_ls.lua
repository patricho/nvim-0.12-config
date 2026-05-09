-- C# LSP Config (.NET)
--
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/csharp_ls.lua
--
-- Install:
--  - winget install Microsoft.DotNet.SDK.10
--  - dotnet tool install --global csharp-ls
--
-- OR download OmniSharp release: https://github.com/OmniSharp/omnisharp-roslyn/releases

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
