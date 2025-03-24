---@module "lazy"
---@type LazyPluginSpec[]
return {
	{
		"gregorias/coerce.nvim",
		tag = "v4.1.0",
		config = true,
	},
	{ "L3MON4D3/LuaSnip" },
	{
		"hat0uma/csvview.nvim",
		---@module "csvview"
		---@type CsvView.Options
		opts = {
			parser = { comments = { "#", "//" } },
			keymaps = {
				-- Text objects for selecting fields
				textobject_field_inner = { "if", mode = { "o", "x" } },
				textobject_field_outer = { "af", mode = { "o", "x" } },
				-- Excel-like navigation:
				-- Use <Tab> and <S-Tab> to move horizontally between fields.

				-- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
				-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
				jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
				jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
				jump_next_row = { "<Enter>", mode = { "n", "v" } },
				jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			},
		},
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
	},

	-- using coerce now { "tpope/vim-abolish" },
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
