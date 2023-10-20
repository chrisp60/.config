vim.g.mapleader = " "
vim.opt.backup = false
vim.opt.colorcolumn = "80,100"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.path:append("**")
vim.opt.nu = true
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
    "wesleimp/stylua.nvim",
    {
        "catppuccin/nvim",
        lazy = false,
    },
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "folke/twilight.nvim",
        opts = {
            dimming = {
                alpha = 0.25, -- amount of dimming
                color = { "Normal", "#ffffff" },
                term_bg = "#000000",
                inactive = false,
            },
            context = 25,      -- amount of lines we will try to show around the current line
            treesitter = true, -- use treesitter when available for the filetype
            -- treesitter is used to automatically expand the visible text,
            -- but you can further control the types of nodes that should always be fully expanded
            expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
                "function",
                "method",
                "table",
                "if_statement",
            },
            exclude = {}, -- exclude these filetypes
        },
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
                -- height and width can be:
                -- * an absolute number of cells when > 1
                -- * a percentage of the width / height of the editor when <= 1
                -- * a function that returns the width or the height
                width = 120, -- width of the Zen window
                height = 1,  -- height of the Zen window
                -- by default, no options are changed for the Zen window
                -- uncomment any of the options below, or add other vim.wo options you want to apply
                options = {
                    signcolumn = "yes",    -- disable signcolumn
                    number = true,         -- disable number column
                    relativenumber = true, -- disable relative numbers
                    cursorline = false,    -- disable cursorline
                    cursorcolumn = false,  -- disable cursor column
                },
            },
            plugins = {
                options = {
                    enabled = true,
                    ruler = false,         -- disables the ruler text in the cmd line area
                    showcmd = false,       -- disables the command in the last line of the screen
                    laststatus = 0,        -- turn off the statusline in zen mode
                },
                tmux = { enabled = true }, -- disables the tmux statusline
                wezterm = {
                    enabled = true,
                    font = "+12", -- (10% increase per step)
                },
            },
        },
    },
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "christoomey/vim-tmux-navigator",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    {
        "lukas-reineke/indent-blankline.nvim",
        init = function()
            require("ibl").setup({ scope = { enabled = false } })
        end,
    },
    "mbbill/undotree",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/playground",
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter", "nvim-treesitter/nvim-treesitter" },
    },
    "lukas-reineke/lsp-format.nvim",
    "theprimeagen/harpoon",
    "tpope/vim-fugitive",
    "williamboman/mason.nvim",
    "tpope/vim-surround",
    "williamboman/mason-lspconfig.nvim",
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup({
                load = {
                    ["core.summary"] = { config = { stragegy = "default" } },
                    ["core.completion"] = { config = { engine = "nvim-cmp" } },
                    ["core.concealer"] = {},
                    ["core.ui.calendar"] = {},
                    ["core.export"] = {
                        config = {
                            export_dir = "exports/<export-dir>/<language>",
                        },
                    },
                    ["core.export.markdown"] = {},
                    ["core.defaults"] = {},
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/notes",
                            },
                        },
                    },
                },
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
    -- Plugin development help.
    "folke/neodev.nvim",
}

require("lazy").setup(plugins)
