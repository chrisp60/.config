---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			query = { "format-queries" },
			lua = { "stylua" },
			javascript = { "prettierd" },
			markdown = { "prettierd" },
			html = { "prettierd" },
			htmldjango = { "djlint" },
			rust = { "rustfmt", "leptosfmt" },
			toml = { "taplo" },
			sql = { "sqlfluff" },
		},
		format_on_save = { timeout_ms = 3000, lsp_format = "fallback" },
		formatters = {
			sqlfluff = { command = "sqlfluff", args = { "format", "--dialect=postgres", "-" }, stdin = true },
			leptosfmt = { prepend_args = { "--tab-spaces=2", "--max-width=80" } },
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
		},
	},
}
