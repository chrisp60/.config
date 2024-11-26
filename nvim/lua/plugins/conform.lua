---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	lazy = false,
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>F",
			function()
				require("conform").format()
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			query = { "format-queries" },
			lua = { "stylua" },
			htmldjango = { "djlint" },
			rust = { "rustfmt" },
			toml = { "taplo" },
			sql = { "pg_format" },
		},
		format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
		formatters = {
			pg_format = { prepend_args = { "--keyword-case=1", "--wrap-limit=80" } },
			djlint = {
				htmldjango = {
					args = { "--reformat" },
				},
			},
			-- Custom formatter definition for djhtml
			djhtml = {
				command = "djhtml",
				args = { "$FILENAME" },
			},
			leptosfmt = {
				prepend_args = {
					"--max-width=80",
					"--tab-spaces=2",
				},
			},
		},
	},
}
