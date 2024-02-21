return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "nvim-telescope/telescope.nvim",
    {
      "folke/neodev.nvim",
      opts = {},
      enabled = function()
        local cwd = vim.fn.getcwd()
        if (cwd == nil) then
          return false
        end
        return string.find(cwd, "nvim") ~= nil
      end,
    },
  },
  config = function()
    require("user.lsp.servers")

    local signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn", text = "" },
      { name = "DiagnosticSignHint", text = "" },
      { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
      virtual_text = false,
      signs = {
        active = signs,
      },
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
