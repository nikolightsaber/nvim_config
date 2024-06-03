return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
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

    local status_ok, builtin = pcall(require, "telescope.builtin")
    if status_ok then
      vim.lsp.handlers["textDocument/references"] = function() builtin.lsp_references({ path_display = { "truncate" } }) end
      vim.lsp.handlers["textDocument/definition"] = function() builtin.lsp_definitions({ path_display = { "truncate" } }) end
    end
    -- lazy therefore start
    vim.cmd.LspStart();
  end,
}
