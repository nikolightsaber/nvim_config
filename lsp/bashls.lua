-- BASHLS
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- install
-- npm i -g bash-language-server
return {
  cmd = { 'bash-language-server', 'start' },
  settings = {
    bashIde = {
      globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
    },
  },
  filetypes = { 'bash', 'sh' },
  root_markers = { '.git' },
}
