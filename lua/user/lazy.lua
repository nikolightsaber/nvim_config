local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = "all",
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  },
  {
    "folke/lazydev.nvim",
    lazy = true,
  },
  {
    "echasnovski/mini.completion",
    opts = {
      lsp_completion = {
        source_func = "omnifunc",
      },
    },
  },
  require("user.colors"),
  require("user.harpoon"),
  require("user.telescope"),
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      require("user.lsp").setup()
    end,
  },
  require("user.gitsigns"),
  require("user.lualine"),
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    lazy = true,
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = "light"
    end
  },
  require("user.formatting")
}, {
  ui = { border = "rounded", },
})
