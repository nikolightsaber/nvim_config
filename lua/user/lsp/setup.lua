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
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
-- install:
-- in ~/.local/share/nvim/lsp_servers/lua-language-server
-- git clone https://github.com/sumneko/lua-language-server
-- build instructions
-- https://github.com/sumneko/lua-language-server/wiki/Getting-Started#build
-- in ~/.local/bin
-- ln -s ../share/nvim/lsp_servers/lua-language-server/bin/lua-language-server lua-language-server
local sumneko_opts = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "use" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.api.nvim_get_runtime_file("", true),
          [vim.fn.expand("$HOME/.local/share/nvim/site/pack/packer")] = true,
          [vim.fn.expand("/usr/share/awesome/lib")] = true,
        },
      },
    },
  },
}
lspconfig.sumneko_lua.setup(vim.tbl_deep_extend("force", sumneko_opts, base_opts))

--------------------------------------------------------------------------
-- PYRIGHT
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
-- install
-- pip install pyright
local pyright_opts = {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off"
      }
    }
  },
}
lspconfig.pyright.setup(vim.tbl_deep_extend("force", pyright_opts, base_opts))

--------------------------------------------------------------------------
-- CSHARP_LS
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#csharp_ls
-- normal install
-- dotnet tool install --global csharp-ls
local csharp_ls_opts = {
  -- root_dir = function ()
  --   return "/home/nikolai/code/navigation/Apps/BR.Mower.Brain"
  -- end
}

lspconfig.csharp_ls.setup(vim.tbl_deep_extend("force", csharp_ls_opts, base_opts))

--------------------------------------------------------------------------
-- TSSERVER
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
-- install
-- sudo npm install -g typescript-language-server typescript
local tsserver_opts = {
}
lspconfig.tsserver.setup(vim.tbl_deep_extend("force", tsserver_opts, base_opts))

-- CLANGD
-- sudo apt install clangd-12
local clangd_opts = {
  cmd = { "clangd-12", "--enable-config", "--clang-tidy"}
}
lspconfig.clangd.setup(vim.tbl_deep_extend("force", clangd_opts, base_opts))

--------------------------------------------------------------------------
-- RUST_ANALYZER
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- install
-- rustup add component rust-analyzer
local rust_analyzer_opts = {
  cmd = { "rustup", "run", "stable", "rust-analyzer"},
  rust = {
    unstable_features = true,
    build_on_save = false,
    all_features = true,
  },
}
lspconfig.rust_analyzer.setup(vim.tbl_deep_extend("force", rust_analyzer_opts, base_opts))

--------------------------------------------------------------------------
-- BASHLS
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- install
-- sudo npm i -g bash-language-server
local bashls_opts = { }
lspconfig.bashls.setup(vim.tbl_deep_extend("force", bashls_opts, base_opts))
