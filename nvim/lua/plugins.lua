---@module "lazy"
---@type LazyPluginSpec[]
return {

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {},
	},
	{
		"nvim-mini/mini.hipatterns",
		version = false,
		opts = {
			highlighters = {
				section = { pattern = "@section", group = "MiniHipatternsNote" },
				todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
				note = { pattern = "NOTE", group = "MiniHipatternsNote" },
			},
		},
	},

	{
		"gregorias/coerce.nvim",
		tag = "v4.1.0",
		config = true,
	},

	{ "andymass/vim-matchup" },

	{ "theHamsta/nvim-treesitter-pairs" },

	{ "tpope/vim-surround" },

	{ "christoomey/vim-tmux-navigator" },

	{ "tpope/vim-repeat" },

	{
		"lifepillar/pgsql.vim",
		init = function()
			vim.g.sql_type_default = "pgsql"
		end,
		enabled = false,
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
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				-- copy pasted from https://github.com/theHamsta/nvim-treesitter-pairs
				pairs = {
					enable = true,
					disable = {},
					highlight_pair_events = {},
					highlight_self = false,
					goto_right_end = false,
					fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')",
					keymaps = {
						goto_partner = "<leader>%",
						delete_balanced = "X",
					},
				},
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
		opts = { columns = { "icon", "permissions", "size" } },
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
			{
				"_",
				function()
					require("oil").open_float()
				end,
				desc = "floating",
			},
		},
	},
}
