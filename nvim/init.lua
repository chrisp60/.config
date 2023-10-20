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
