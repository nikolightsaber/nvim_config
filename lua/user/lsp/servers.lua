local base_opts = {
  on_attach = require("user.lsp").on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
}

local lspconfig = require("lspconfig")

--------------------------------------------------------------------------
-- SUMNEKO
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
-- install:
-- in ~/.local/share/nvim/lsp_servers/lua-language-server
-- git clone https://github.com/LuaLS/lua-language-server
-- in ~/.local/bin
-- ln -s ../share/nvim/lsp_servers/lua-language-server/bin/lua-language-server lua-language-server
local lua_ls_opts = {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    ---@diagnostic disable-next-line: undefined-field
    if not vim.uv.fs_stat(path .. "/.luarc.json") and not vim.uv.fs_stat(path .. "/.luarc.jsonc") then
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
        Lua = {
          runtime = {
            version = "LuaJIT"
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
  on_attach = require("user.lsp").on_attach_format,
}
lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", base_opts, lua_ls_opts))

--------------------------------------------------------------------------
-- PYRIGHT
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
-- install
-- pipx install pyright
local pyright_opts = {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off"
      }
    }
  },
}
lspconfig.pyright.setup(vim.tbl_deep_extend("force", base_opts, pyright_opts))

--------------------------------------------------------------------------
-- CSHARP_LS
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#csharp_ls
-- normal install
-- dotnet tool install --global csharp-ls
local cmd = nil
if #vim.fs.find("BR.Navigation.Linux.sln", {}) == 1 then
  cmd = { "csharp-ls", "--solution", "BR.Navigation.Linux.sln" }
end
local csharp_ls_opts = {
  cmd = cmd,
  AutomaticWorkspaceInit = true,
}

lspconfig.csharp_ls.setup(vim.tbl_deep_extend("force", base_opts, csharp_ls_opts))

--------------------------------------------------------------------------
-- TSSERVER
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#tsserver
-- install
-- npm install -g typescript-language-server typescript
local ts_ls_opts = {
}
lspconfig.ts_ls.setup(vim.tbl_deep_extend("force", base_opts, ts_ls_opts))

-- CLANGD
-- sudo apt install clangd-18
local clangd_opts = {
  cmd = { "clangd-18", "--enable-config", "--clang-tidy" }
}
lspconfig.clangd.setup(vim.tbl_deep_extend("force", base_opts, clangd_opts))

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
-- BASHLS
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- install
-- npm i -g bash-language-server
local bashls_opts = {}
lspconfig.bashls.setup(vim.tbl_deep_extend("force", base_opts, bashls_opts))

--------------------------------------------------------------------------
-- ESLINT
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
-- install
-- npm i -g vscode-langservers-extracted
local eslint_opts = {}
lspconfig.eslint.setup(vim.tbl_deep_extend("force", base_opts, eslint_opts))

--------------------------------------------------------------------------
-- HTML
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#html
-- install
-- npm i -g vscode-langservers-extracted
local html_opts = {}
lspconfig.html.setup(vim.tbl_deep_extend("force", base_opts, html_opts))
--------------------------------------------------------------------------
-- Anguarls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#angularls
-- install
-- npm install -g @angular/language-server
-- local node_modules need language server installed
--
local function get_angular_cmd(root_dir)
  local project_root = vim.fs.find("node_modules", { path = root_dir, upward = true })[1]

  local default_probe_dir = project_root and (project_root .. "/node_modules") or ""

  return {
    "npx",
    "ngserver",
    "--stdio",
    "--tsProbeLocations",
    default_probe_dir,
    "--ngProbeLocations",
    default_probe_dir,
  }
end

local angularls_opts = {
  cmd = get_angular_cmd(),
  on_new_config = function(new_config, _)
    new_config.cmd = get_angular_cmd()
  end,
}
lspconfig.angularls.setup(vim.tbl_deep_extend("force", base_opts, angularls_opts))
