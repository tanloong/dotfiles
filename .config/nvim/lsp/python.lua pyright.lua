return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  -- 广度优先, see :h lsp-root_markers
  root_markers = { { 'README.md', 'pyproject.toml', "uv.lock", '.gitignore', 'requirements.txt', 'Makefile' } },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}

