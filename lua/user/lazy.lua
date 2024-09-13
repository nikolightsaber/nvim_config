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
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-storm")
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { "<leader>a", "<C-h>", "<C-j>", "<C-k>", "<C-l>", "<C-;>", "<C-'>", "<C-\\>" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({ settings = { save_on_toggle = true, } })

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)
      vim.keymap.set("n", "<C-'>", function() harpoon:list():select(5) end)
      vim.keymap.set("n", "<C-\\>", function() harpoon:list():select(6) end)
    end,
  },
  require("user.telescope"),
  require("user.gitsigns"),
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      require("user.lsp").setup()
    end,
  },
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
}, {
  ui = { border = "rounded", },
})
