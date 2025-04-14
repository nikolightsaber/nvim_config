local base_opts = {
  on_attach = require("user.lsp").on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

local lspconfig = require("lspconfig")

--------------------------------------------------------------------------
-- RUST_ANALYZER
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- install
-- rustup component add rust-analyzer
local rust_analyzer_opts = {
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
  rust = {
    unstable_features = true,
    build_on_save = false,
    all_features = true,
  },
  on_attach = require("user.lsp").on_attach_format,
}
lspconfig.rust_analyzer.setup(vim.tbl_deep_extend("force", base_opts, rust_analyzer_opts))

--------------------------------------------------------------------------
-- HTML
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#html
-- install
-- npm i -g vscode-langservers-extracted
local html_opts = {}
lspconfig.html.setup(vim.tbl_deep_extend("force", base_opts, html_opts))
