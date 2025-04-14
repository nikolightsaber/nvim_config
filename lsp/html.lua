-- HTML
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#html
-- install
-- npm i -g vscode-langservers-extracted
return {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ' },
  root_markers = { 'package.json', '.git' },
  settings = {},
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
}
