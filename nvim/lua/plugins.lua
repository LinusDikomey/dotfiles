-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer can manage itself
  
  use 'folke/tokyonight.nvim' -- Theme

  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/nvim-cmp'
  use 'simrat39/rust-tools.nvim'
end)
