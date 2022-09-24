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
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
-- install
-- download https://github.com/clangd/clangd/releases/
-- unzip to ~/.local/bin
local clangd_opts = {
  -- cmd = { "clangd", "--enable-config", "--clang-tidy"}
}
lspconfig.clangd.setup(vim.tbl_deep_extend("force", clangd_opts, base_opts))

-- RUST_ANALYZER
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- install
-- https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
-- curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer
-- chmod +x ~/.local/bin/rust-analyzer
local rust_analyzer_opts = {
  rust = {
    unstable_features = true,
    build_on_save = false,
    all_features = true,
  },
}
lspconfig.rust_analyzer.setup(vim.tbl_deep_extend("force", rust_analyzer_opts, base_opts))
