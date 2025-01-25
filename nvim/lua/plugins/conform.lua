---@module "lazy"
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
			htmldjango = { "prettier_pnp", lsp_format = "never" },
			rust = {
				"rustfmt",
				-- "leptosfmt"
			},
			toml = { "taplo" },
			sql = { "sqlfluff", lsp_format = "never" },
		},
		format_on_save = { timeout_ms = 5000, lsp_format = "fallback" },
		formatters = {
			sqlfluff = {
				command = "sqlfluff",
				args = {
					"format",
					"--dialect",
					"postgres",
					"--stdin-filename",
					"$FILENAME",
					"-",
				},
				stdin = true,
				require_cwd = false,
			},
			prettier_pnp = {
				command = "prettier-pnp",
				args = {
					"--quiet",
					"--pn",
					"jinja-template",
					"--stdin-filepath",
					"$FILENAME",
					"--parser",
					"jinja-template",
					"--single-attribute-per-line",
					"true",
				},
				stdin = true,
			},
		},
	},
}
