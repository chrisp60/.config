---@diagnostic disable: undefined-global
---
require('set')

-- Bootstrap Lazy
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
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    },
    'NvChad/nvim-colorizer.lua',
    'theprimeagen/harpoon',
    'jose-elias-alvarez/null-ls.nvim',
    'christoomey/vim-tmux-navigator',
    'tpope/vim-surround',
    'lukas-reineke/indent-blankline.nvim',
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter',
}

require("lazy").setup(plugins, opts)
