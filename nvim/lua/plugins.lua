---@module "lazy"
---@type LazyPluginSpec[]
return {
	{ "andymass/vim-matchup" },
	{ "j-hui/fidget.nvim", opts = {} },
	{ "tpope/vim-surround" },
	{ "christoomey/vim-tmux-navigator" },
	{ "tpope/vim-repeat" },

	{
		"lifepillar/pgsql.vim",
		init = function()
			vim.g.sql_type_default = "pgsql"
		end,
	},

	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree Toggle" })
		end,
	},

	{
		"tpope/vim-fugitive",
		lazy = false,
		keys = {
			{ "<leader>t", "<cmd>:vertical :Git<cr>" },
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function(_, _)
			require("nvim-treesitter.configs").setup({
				matchup = { enable = true },
				modules = {},
				ignore_install = {},
				auto_install = true,
				ensure_installed = {},
				sync_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	{
		"stevearc/oil.nvim",
		opts = {},
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
		},
	},
}
