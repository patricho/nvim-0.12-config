---@brief
---
--- https://phpantom-dev.github.io/phpantom_lsp/latest/editor-setup/#neovim
---
--- brew install phpantom-lsp

---@type vim.lsp.Config
return {
    cmd = { 'phpantom_lsp' },
    filetypes = { 'php' },
    workspace_required = true,
    root_dir = function(bufnr, on_dir)
        local uri = vim.uri_from_bufnr(bufnr)
        local scheme = uri:match("^(%a[%w+.-]*):")

        -- Prevent phpactor to attach to an unsupported buffer type (for example diffview)
        if scheme ~= 'file' and scheme ~= 'untitled' and scheme ~= 'phar' then return end

        local path = vim.uri_to_fname(uri)
        local root = vim.fs.root(path, { '.git', 'composer.json', '.phpantom.toml' })
        on_dir(root)
    end,
}
