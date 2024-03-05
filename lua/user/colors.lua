return {
  {
    "rose-pine/neovim",
    lazy = true,
    name = "rose-pine",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    "luisiacc/gruvbox-baby",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme("gruvbox-baby")
    end,
  },
}
