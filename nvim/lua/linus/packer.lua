-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- LSP Support
    use {
        'neovim/nvim-lspconfig',
        requires = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- status updates for LSP
            'j-hui/fidget.nvim'
        }
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip'
        }
    }

    -- Treesitter for highlighting/editing
    use('nvim-treesitter/nvim-treesitter', { run = 'TSUpdate' })
    use 'nvim-treesitter/playground'

    -- Telescope for popus for navigation/fuzzy finding etc.
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Themes
    use {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    }
    use { "catppuccin/nvim", as = "catppuccin" }

    -- other useful plugins
    use 'theprimeagen/harpoon'
    use 'mbbill/undotree'

    -- git related
    use 'tpope/vim-fugitive'

--    use {
--        'VonHeikemen/lsp-zero.nvim',
--        requires = {
--            -- LSP Support
--            {'neovim/nvim-lspconfig'},
--
--            -- Autocompletion
--            {},
--            {'hrsh7th/cmp-path'},
--            {},
--            {'hrsh7th/cmp-nvim-lua'},
--
--            -- Snippets
--            {},
--            {'rafamadriz/friendly-snippets'},
--        }
--    }

    -- Visuals
    use {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
    }
    use 'lukas-reineke/indent-blankline.nvim'
    use 'lewis6991/gitsigns.nvim'

    -- Shows errors
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
    }

    -- Debugging
    use 'mfussenegger/nvim-dap'
    use 'rcarriga/nvim-dap-ui'

    ----------------------------------------
    --------   LANGUAGE SPECIFIC   ---------
    ----------------------------------------
    use 'tikhomirov/vim-glsl'
    use 'lervag/vimtex'
    -- use 'simrat39/rust-tools.nvim'

end)
