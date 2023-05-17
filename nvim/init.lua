vim.g.mapleader = " "

-- Bootstrap Laxy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false,
        config = function()
            require('colors')
        end,
    },
    'folke/trouble.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'nvim-treesitter/nvim-treesitter-context',
    'christoomey/vim-tmux-navigator',
    'wbthomason/packer.nvim',
    'wbthomason/packer.nvim',
    'ThePrimeagen/harpoon',
    'tpope/vim-surround',
    'lukas-reineke/indent-blankline.nvim',
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter',
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        },
    },
}

require("lazy").setup(plugins, opts)
require('set')
