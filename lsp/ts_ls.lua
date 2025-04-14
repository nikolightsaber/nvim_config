-- TSSERVER
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
-- install
-- npm install -g typescript-language-server typescript
return {
  init_options = { hostInfo = 'neovim' },
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
}
