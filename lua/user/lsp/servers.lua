local base_opts = {
  on_attach = require("user.lsp.base").on_attach,
  capabilities = require("user.lsp.base").capabilities,
}

local lspconfig = require("lspconfig")

--------------------------------------------------------------------------
-- SUMNEKO
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
-- install:
-- in ~/.local/share/nvim/lsp_servers/lua-language-server
-- git clone https://github.com/sumneko/lua-language-server
-- in ~/.local/bin
-- ln -s ../share/nvim/lsp_servers/lua-language-server/bin/lua-language-server lua-language-server
local lua_ls_opts = {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            version = 'LuaJIT'
          },
          workspace = {
            checkThirdParty = false,
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end,
  on_attach = require("user.lsp.base").on_attach_format,
}
lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", base_opts, lua_ls_opts))

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
  cmd = { "clangd-12", "--enable-config", "--clang-tidy" }
}
lspconfig.clangd.setup(vim.tbl_deep_extend("force", clangd_opts, base_opts))

--------------------------------------------------------------------------
-- RUST_ANALYZER
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- install
-- rustup add component rust-analyzer
local rust_analyzer_opts = {
  cmd = { "rustup", "run", "stable", "rust-analyzer" },
  rust = {
    unstable_features = true,
    build_on_save = false,
    all_features = true,
  },
  on_attach = require("user.lsp.base").on_attach_format,
}
lspconfig.rust_analyzer.setup(vim.tbl_deep_extend("force", base_opts, rust_analyzer_opts))

--------------------------------------------------------------------------
-- BASHLS
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- install
-- sudo npm i -g bash-language-server
local bashls_opts = {}
lspconfig.bashls.setup(vim.tbl_deep_extend("force", bashls_opts, base_opts))

--------------------------------------------------------------------------
-- ESLINT
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
-- install
-- sudo npm i -g vscode-langservers-extracted
local eslint_opts = {}
lspconfig.eslint.setup(vim.tbl_deep_extend("force", eslint_opts, base_opts))

--------------------------------------------------------------------------
-- HTML
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#html
-- install
-- sudo npm i -g vscode-langservers-extracted
local html_opts = {}
lspconfig.html.setup(vim.tbl_deep_extend("force", html_opts, base_opts))
--------------------------------------------------------------------------
-- Anguarls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#angularls
-- install
-- npm install -g @angular/language-server
local project_library_path = "/usr/local/lib/node_modules/@angular/language-server/"
local cmd = { "ngserver", "--stdio", "--tsProbeLocations", project_library_path, "--ngProbeLocations",
  project_library_path }
local angularls_opts = {
  cmd = cmd,
  on_new_config = function(new_config, _)
    new_config.cmd = cmd
  end,
}
lspconfig.angularls.setup(vim.tbl_deep_extend("force", angularls_opts, base_opts))
-- gopls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
-- install
-- npm install -g @angular/language-server
local project_library_path = "/usr/local/lib/node_modules/@angular/language-server/"
local cmd = { "/home/nikolai/go/bin/gopls" }
local gopls_opts = {
  cmd = cmd,
}
lspconfig.gopls.setup(vim.tbl_deep_extend("force", gopls_opts, base_opts))
