---@diagnostic disable: undefined-global
vim.g.mapleader = ' '
vim.opt.backup = false
vim.opt.colorcolumn = "80,100"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.nu = true
vim.opt.path:append '**'
vim.opt.relativenumber = true
vim.opt.scrolloff = 999
vim.opt.shiftwidth = 4
vim.opt.showmode = true
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 10
vim.opt.wrap = false


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
        lazy = false,
    },
    {
        'nvim-telescope/telescope.nvim',
        lazy = false,
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    'L3MON4D3/LuaSnip',
    'christoomey/vim-tmux-navigator',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    {
        'lukas-reineke/indent-blankline.nvim',
        init = function()
            require('ibl').setup({ scope = { enabled = false } })
        end
    },
    'mbbill/undotree',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/playground',
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { "nvim-treesitter", "nvim-treesitter/nvim-treesitter" }
    },
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
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {},      -- Loads default behaviour
                    ["core.concealer"] = {},     -- Adds pretty icons to your documents
                    ["core.dirman"] = {          -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        cmf = 'TSUpdate',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                sync_install = true,
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
