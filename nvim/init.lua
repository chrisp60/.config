vim.g.mapleader = " "
vim.opt.backup = false
vim.opt.colorcolumn = "80,100"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.nu = true
vim.opt.path:append("**")
vim.opt.relativenumber = true
vim.opt.scrolloff = 999
vim.opt.shiftwidth = 4
vim.opt.showmode = true
vim.opt.showtabline = 1
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
        "catppuccin/nvim",
        lazy = false,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        init = function()
            require("ibl").setup({
                scope = { enabled = true, char = "╎", show_start = true },
                indent = { char = "╎" },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        cmd = "TSUpdate",
        config = function()
            ---@diagnostic disable-next-line missing-fields
            require("nvim-treesitter.configs").setup({
                sync_install = true,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },

    { "hrsh7th/cmp-nvim-lsp",     lazy = false },
    { "hrsh7th/cmp-path",         lazy = false },
    { "hrsh7th/nvim-cmp",         lazy = false },
    { "saadparwaiz1/cmp_luasnip", lazy = false },

    "L3MON4D3/LuaSnip",
    "brenoprata10/nvim-highlight-colors",
    "christoomey/vim-tmux-navigator",
    "folke/neodev.nvim",
    "lukas-reineke/lsp-format.nvim",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/playground",
    "theprimeagen/harpoon",
    "tpope/vim-fugitive",
    "tpope/vim-surround",
    "wesleimp/stylua.nvim",
    "williamboman/mason-lspconfig.nvim",
    "williamboman/mason.nvim",
}

require("lazy").setup(plugins)
