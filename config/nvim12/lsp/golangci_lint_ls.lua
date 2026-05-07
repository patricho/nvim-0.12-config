---@brief
---
--- go install github.com/nametake/golangci-lint-langserver@latest

---@type vim.lsp.Config
return {
    cmd = { 'golangci-lint-langserver' },
    filetypes = { 'go', 'gomod' },
    root_markers = { '.git', 'go.mod' },
    init_options = {
        command = {
            'golangci-lint', 'run', '--out-format=json', '--show-stats=false', '--issues-exit-code=1'
        },
    },
}
