local prettierd = { "prettierd" }

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
			just = { "just" },

			css = prettierd,
			typescript = prettierd,
			svelte = prettierd,
			javascript = prettierd,
			markdown = prettierd,
			html = prettierd,
			-- htmldjango = { "prettier_jinja" },
			c = { lsp_format = "prefer" },
			json = { "jq" },
			zig = { "zigfmt" },
			rust = {
				-- last so that trim_whitespace can remove any trailing spaces that can choke up rustfmt
				lsp_format = "last",
			},
			toml = { "taplo" },
			sql = {
				"trim_whitespace",
				"trim_newlines",
				"pg_format",
				"sqlfluff",
				timeout_ms = 2000,
			},
			["*"] = { "trim_whitespace", "trim_newlines" },
		},
		format_after_save = { timeout_ms = 500 },
		formatters = {
			pg_format = {
				command = "pg_format",
				append_args = {
					"--keyword-case=1",
					"--no-space-function",
				},
			},
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
			prettier_jinja = {
				command = "prettier-pnp",
				args = {
					"--quiet",
					"--pn",
					"jinja-template",
					"--stdin-filepath",
					"$FILENAME",
					"--parser",
					"jinja-template",
				},
				stdin = true,
			},
		},
	},
}
