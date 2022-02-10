-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'neovim/nvim-lspconfig'

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    use 'Mofiqul/dracula.nvim'
end)
