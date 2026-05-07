---@brief
---
--- https://github.com/phpactor/phpactor
---
--- Installation: https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation
---
--- curl -Lo phpactor.phar https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
--- chmod a+x phpactor.phar
--- mv phpactor.phar ~/.local/bin/phpactor

---@type vim.lsp.Config
return {
    cmd = { 'phpactor', 'language-server' },
    filetypes = { 'php' },
    workspace_required = true,
    root_dir = function(bufnr, on_dir)
        local uri = vim.uri_from_bufnr(bufnr)
        local scheme = uri:match("^(%a[%w+.-]*):")

        -- Prevent phpactor to attach to an unsupported buffer type (for example diffview)
        if scheme ~= 'file' and scheme ~= 'untitled' and scheme ~= 'phar' then return end

        local path = vim.uri_to_fname(uri)
        local root = vim.fs.root(path, { '.git', 'composer.json', '.phpactor.json', '.phpactor.yml' })
        on_dir(root)
    end,
}
