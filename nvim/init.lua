---@diagnostic disable-next-line: undefined-global
local vim = vim

vim.g.mapleader = ' '
vim.opt.path:append '**'
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80,100"
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.updatetime = 10

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
    'catppuccin/nvim',
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    'L3MON4D3/LuaSnip',
    'ThePrimeagen/git-worktree.nvim',
    'christoomey/vim-tmux-navigator',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'lewis6991/gitsigns.nvim',
    'lukas-reineke/indent-blankline.nvim',
    'mbbill/undotree',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/playground',
    'theprimeagen/harpoon',
    'tpope/vim-fugitive',
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    },
    'tpope/vim-surround',
    'williamboman/mason-lspconfig.nvim',
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            -- treesitter
            require 'nvim-treesitter.configs'.setup {
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end

    },
}

---@diagnostic disable-next-line: undefined-global
require("lazy").setup(plugins, opts)
