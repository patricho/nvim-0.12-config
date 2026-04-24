-- rust-analyzer config
-- Install: rustup component add rust-analyzer
-- (requires Rust: winget install Rustlang.Rustup  /  brew install rustup)
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      inlayHints = {
        bindingModeHints            = { enable = true },
        chainingHints               = { enable = true },
        closingBraceHints           = { enable = true, minLines = 25 },
        closureReturnTypeHints      = { enable = "with_block" },
        lifetimeElisionHints        = { enable = "skip_trivial" },
        parameterHints              = { enable = true },
        typeHints                   = { enable = true },
      },
    },
  },
}
