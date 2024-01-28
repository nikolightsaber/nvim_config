local fn = vim.fn
-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
local group = vim.api.nvim_create_augroup("packer_user_config", { clear=true })
vim.api.nvim_create_autocmd("BufWritePost", { group=group, pattern="plugins.lua", command="source <afile> | PackerSync" })

-- Use a protected call so we don"t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  print("Error no packer")
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}
packer.startup(function()
  -- Packer can manage itself
  use "wbthomason/packer.nvim"
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "kyazdani42/nvim-web-devicons"

  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use "nvim-treesitter/playground"
  use "nvim-treesitter/nvim-treesitter-context"

  use "Mofiqul/dracula.nvim"
  use "luisiacc/gruvbox-baby"
  use "folke/tokyonight.nvim"
  use "tiagovla/tokyodark.nvim"
  use { "rose-pine/neovim", as = "rose-pine" }

  use "hrsh7th/nvim-cmp"  -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  use "hrsh7th/cmp-nvim-lsp-signature-help"

  use "L3MON4D3/LuaSnip"
  use "rafamadriz/friendly-snippets"

  use "neovim/nvim-lspconfig"

  use "nvim-telescope/telescope.nvim"
  use "debugloop/telescope-undo.nvim"

  use "AckslD/nvim-neoclip.lua" -- Save old yanks

  use { "ThePrimeagen/harpoon", branch = "harpoon2" }

  use "mhartington/formatter.nvim" -- save in rust

  use "kyazdani42/nvim-tree.lua"

  use "nvim-lualine/lualine.nvim"

  use "mfussenegger/nvim-dap"

  use "m4xshen/hardtime.nvim"

  use "lewis6991/gitsigns.nvim"

  use "iamcco/markdown-preview.nvim"

  use "numToStr/Comment.nvim"

  use "folke/which-key.nvim"

  use "ThePrimeagen/vim-be-good"

  use "eandrju/cellular-automaton.nvim" -- make it rain

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
