return {
  {
    "rose-pine/neovim",
    lazy = false,
    name = "rose-pine",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("rose-pine-moon")
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    "luisiacc/gruvbox-baby",
    enabled = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme("gruvbox-baby")
    end,
  },
  {
    "Mofiqul/dracula.nvim",
    enabled = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd.colorscheme("dracula")
    end,
  },
}
