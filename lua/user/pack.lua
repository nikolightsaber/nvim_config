vim.pack.add({
  { name = 'tokyonight',        src = 'https://github.com/folke/tokyonight.nvim' },
  { name = 'telescope',         src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { name = 'plenary',           src = 'https://github.com/nvim-lua/plenary.nvim' },
  { name = 'nvim-web-devicons', src = 'https://github.com/nvim-web-devicons' },
  { name = 'lazydev',           src = 'https://github.com/folke/lazydev.nvim' },
}, { load = false })

vim.cmd.colorscheme('tokyonight-storm')
