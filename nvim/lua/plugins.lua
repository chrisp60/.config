---@module "lazy"
---@type LazyPluginSpec[]
return {
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
	{ "andymass/vim-matchup" },
	{ "j-hui/fidget.nvim", opts = {} },
	{ "tpope/vim-surround" },
	{ "christoomey/vim-tmux-navigator" },
	{ "tpope/vim-repeat" },
	{
		"tpope/vim-fugitive",
		lazy = false,
		keys = {
			{ "<leader>t", "<cmd>:vertical :Git<cr>" },
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			defaults = {
				border = true,
				layout_strategy = "horizontal",
				wrap_results = false,
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						height = 0.9,
						preview_cutoff = 120,
						prompt_position = "top",
						width = 0.9,
					},
				},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			local builtin = require("telescope.builtin")
			local commands = {
				{ "/", builtin.current_buffer_fuzzy_find, "fuzzy search buffer" },
				{ "?", builtin.help_tags, "help tags" },
				{ ".", builtin.keymaps, "keymaps", { show_plug = false } },
				{ "T", builtin.treesitter, "treesitter" },
				{ "f", builtin.find_files, "files" },
				{ "g", builtin.live_grep, "grep" },
				{ "m", builtin.man_pages, "man pages" },
				{ "o", builtin.vim_options, "vim options" },
				{ '"', builtin.marks, "marks" },
				{ "R", builtin.registers, "registers" },
				{ "=", builtin.spell_suggest, "spelling" },
				{ "h", builtin.highlights, "colors" },

				{ "ld", builtin.lsp_definitions, "LSP definitions" },
				{ "lt", builtin.lsp_type_definitions, "LSP type definitions" },
				{ "li", builtin.lsp_implementations, "LSP implementations" },
				{ "lr", builtin.lsp_references, "LSP references" },
				{
					"s",
					builtin.lsp_dynamic_workspace_symbols,
					"LSP workspace symbols",
				},
				{ "S", builtin.lsp_document_symbols, "LSP document symbols" },
				{ "D", builtin.diagnostics, "all diagnostics" },
				{ "d", builtin.diagnostics, "errors", { severity = vim.diagnostic.severity.ERROR } },
				{
					"F",
					builtin.find_files,
					"files (all)",
					{
						hidden = true,
						no_ignore = true,
						no_ignore_parent = true,
					},
				},
			}

			for _, command in ipairs(commands) do
				local key, action, desc, options = unpack(command)
				vim.inspect(options)
				vim.keymap.set("n", "<leader>" .. key, function()
					action(options)
				end, { desc = "Telescope: " .. desc })
			end
		end,
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
