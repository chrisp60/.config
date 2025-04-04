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

			-- Git
			{ "Ts", b.git_status, "Git status" },
			{ "Tf", b.git_files, "Git files" },
			{ "Tc", b.git_commits, "Git commits" },
			{ "Tb", b.git_branches, "Git branches" },

			-- General
			{ ".", b.keymaps, "keymaps", { show_plug = false } },
			{ "/", b.current_buffer_fuzzy_find, "fuzzy search buffer" },
			{ ":", b.command_history, "Git branches" },
			{ "=", b.spell_suggest, "spelling" },
			{ "?", b.help_tags, "help tags" },
			{ "F", b.find_files, "files (all)", { hidden = true, no_ignore = true, no_ignore_parent = true } },
			{ "R", b.registers, "registers" },
			{ "f", b.find_files, "files" },
			{ "g", b.live_grep, "grep" },
			{ "h", b.highlights, "colors" },
			{ "m", b.man_pages, "man pages" },
			{ "o", b.vim_options, "vim options" },
			{ '"', b.marks, "marks" },

			-- Lsp
			{ "ld", b.lsp_definitions, "LSP definitions" },
			{ "lt", b.lsp_type_definitions, "LSP type definitions" },
			{ "li", b.lsp_implementations, "LSP implementations" },
			{ "lr", b.lsp_references, "LSP references" },
			{ "s", b.lsp_dynamic_workspace_symbols, "LSP workspace symbols", {} },
			{ "S", b.lsp_document_symbols, "LSP document symbols" },
			{ "D", b.diagnostics, "all diagnostics" },
			{ "d", b.diagnostics, "errors", { severity = vim.diagnostic.severity.ERROR } },
		}

		for _, command in ipairs(commands) do
			local key, action, desc, options = unpack(command)
			vim.keymap.set("n", "<leader>" .. key, function()
				action(options)
			end, { desc = "Telescope: " .. desc })
		end
	end,
}
