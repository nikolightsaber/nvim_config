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
-- build instructions
-- https://github.com/LuaLS/lua-language-server/wiki/Getting-Started#build
-- in ~/.local/bin
-- ln -s ../share/nvim/lsp_servers/lua-language-server/bin/lua-language-server lua-language-server
local lua_ls_opts = {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
}
lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", lua_ls_opts, base_opts))

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
}
lspconfig.rust_analyzer.setup(vim.tbl_deep_extend("force", rust_analyzer_opts, base_opts))

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
