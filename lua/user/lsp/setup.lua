local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  print("lsp not ok")
  return
end

local base_opts = {
  on_attach = require("user.lsp.handlers").on_attach,
  capabilities = require("user.lsp.handlers").capabilities,
}

--------------------------------------------------------------------------
-- SUMNEKO
-- install:
local sumneko_opts = {
  settings = {

    Lua = {
      diagnostics = {
        globals = { "vim", "use" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$HOME/.local/share/nvim/site/pack/packer")] = true,
          [vim.fn.expand("/usr/share/awesome/lib")] = true,
        },
      },
    },
  },
}
lspconfig.sumneko_lua.setup(vim.tbl_deep_extend("force", sumneko_opts, base_opts))
--------------------------------------------------------------------------

  --[[ if server.name == "angularls" then
    local angularls_opts = require("user.lsp.settings.angularls")
    opts = vim.tbl_deep_extend("force", angularls_opts, opts)
  end

  if server.name == "pyright" then
    local pyright_opts = require("user.lsp.settings.pyright")
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server.name == "omnisharp" then
    local omnisharp_opts = require("user.lsp.settings.omnisharp")
    opts = vim.tbl_deep_extend("force", omnisharp_opts, opts)
  end

  if server.name == "csharp_ls" then
    local csharp_ls_opts = require("user.lsp.settings.csharp_ls")
    opts = vim.tbl_deep_extend("force", csharp_ls_opts, opts)
  end

  if server.name == "tsserver" then
    local tsserver_ls_opts = require("user.lsp.settings.tsserver")
    opts = vim.tbl_deep_extend("force", tsserver_ls_opts, opts)
  end

  if server.name == "clangd" then
    local clangd_ls_opts = require("user.lsp.settings.clangd")
    opts = vim.tbl_deep_extend("force", clangd_ls_opts, opts)
  end

  if server.name == "rust_analyzer" then
    local rust_analyzer_opts = require("user.lsp.settings.rls")
    opts = vim.tbl_deep_extend("force", rust_analyzer_opts, opts)
  end ]]
