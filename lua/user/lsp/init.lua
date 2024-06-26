return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cwd = vim.fn.getcwd() or "";
    if string.find(cwd, "nvim") ~= nil then
      require("lazydev").setup({ integrations = { cmp = false } })
    end
    require("user.lsp.servers")

    local config = {
      virtual_text = false,
      update_in_insert = true,
      underline = true,

      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.ERROR] = "",
        }
      }
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

    require("lspconfig.ui.windows").default_options.border = "rounded";

    -- lazy therefore start
    vim.cmd.LspStart();
  end,
}
