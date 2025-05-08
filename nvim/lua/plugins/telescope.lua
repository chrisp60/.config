return {
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
		local b = require("telescope.builtin")
		local commands = {

			-- General
			{ ".", b.keymaps, "keymaps", { show_plug = false } },
			{ "/", b.current_buffer_fuzzy_find, "fuzzy search buffer" },
			{ "?", b.help_tags, "help tags" },
			{
				"F",
				b.find_files,
				"files (all)",
				{
					hidden = true,
					no_ignore = true,
					no_ignore_parent = true,
				},
			},
			{ "f", b.find_files, "files" },
			{ "g", b.live_grep, "grep" },
			{ "o", b.vim_options, "vim options" },
			{ '"', b.marks, "marks" },
			{ "b", b.jumplist, "vim options" },

			-- Lsp
			{ "ld", b.lsp_definitions, "LSP definitions" },
			{ "lt", b.lsp_type_definitions, "LSP type definitions" },
			{ "li", b.lsp_implementations, "LSP implementations" },
			{ "R", b.lsp_references, "LSP references" },
			{ "s", b.lsp_workspace_symbols, "LSP workspace symbols", {} },
			{ "S", b.lsp_document_symbols, "LSP document symbols" },
			{ "D", b.diagnostics, "all diagnostics" },
			{
				"d",
				b.diagnostics,
				"errors",
				{
					severity = vim.diagnostic.severity.ERROR,
					no_sign = true,
				},
			},
		}

		for _, command in ipairs(commands) do
			local key, action, desc, options = unpack(command)
			vim.keymap.set("n", "<leader>" .. key, function()
				action(options)
			end, { desc = "Telescope: " .. desc })
		end

		vim.keymap.set("n", "<leader>c", b.git_commits, { desc = "Telescope: git commits" })
		vim.keymap.set("n", "<leader>b", b.git_branches, { desc = "Telescope: git branches" })
	end,
}
