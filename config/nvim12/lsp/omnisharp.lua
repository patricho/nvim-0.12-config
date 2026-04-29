-- OmniSharp config (.NET / C#)
-- Install: winget install Microsoft.DotNet.SDK.9
-- Then: dotnet tool install --global csharp-ls
-- OR download OmniSharp release: https://github.com/OmniSharp/omnisharp-roslyn/releases
--
-- If using csharp-ls instead of omnisharp, change the server name in init.lua
-- to "csharp_ls" (which has a built-in 0.12 config).

return {
  cmd = { "OmniSharp" },
  filetypes = { "cs", "vb" },
  root_markers = { "*.sln", "*.csproj", "omnisharp.json", ".git" },
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport       = true,
      EnableImportCompletion       = true,
      AnalyzeOpenDocumentsOnly     = false,
    },
  },
}
