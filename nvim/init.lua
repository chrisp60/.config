vim.g.mapleader = " "
require('colors')
require('set')

vim.cmd [[packadd packer.nvim]]
-- Only required if you have packer configured as `opt`

return require('packer').startup(function(use)
    use({
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("null-ls").setup()
        end,
        requires = { "nvim-lua/plenary.nvim" },
    })
    use('christoomey/vim-tmux-navigator')
    use('wbthomason/packer.nvim')
    use('tpope/vim-surround')
    use('lukas-reineke/indent-blankline.nvim')
    use('nvim-treesitter/playground')

    use { "vimwiki/vimwiki", setup = function()
        vim.g.vimwiki_list = { {
            ["path"] = "~/wiki/",
            ["syntax"] = "default",
            ["ext"] = ".wiki",
            ["auto_toc"] = 1,
        } }
        vim.g.vimwiki_global_ext = 0
    end }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'catppuccin/nvim', as = 'catppuccin' }
    -- -- Telescope related
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-telescope/telescope-file-browser.nvim' }

    -- -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
end)
