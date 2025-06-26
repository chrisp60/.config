--- constructs a table for conforms custom formatters using prettier-pnp
---@param extension string
---@return conform.FormatterConfigOverride
local function prettier_pnp(extension)
	return {
		command = "prettier-pnp",
		args = {
			"--quiet",
			"--pn",
			extension,
			"--stdin-filepath",
			"$FILENAME",
			"--parser",
			extension,
		},
		stdin = true,
	}
end

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
			css = { "prettierd" },
			query = { "format-queries" },
			lua = { "stylua" },
			-- Why are there 3 different javascripts?
			typescriptreact = { "prettierd", lsp_format = "fallback" },
			typescript = { "prettierd" },
			just = { "just" },
			svelte = { "prettierd", lsp_format = "fallback" },
			javascript = { "prettierd" },
			markdown = { "prettierd" },
			html = { "prettierd" },
			htmldjango = { "prettier_jinja" },
			c = { lsp_format = "prefer" },
			json = { "jq" },
			rust = { "rustfmt" },
			toml = { "taplo" },
			sql = {
				"pg_format",
				-- Can take an aggresively long time
				timeout_ms = 5000,
			},
			["*"] = { "trim_whitespace", "trim_newlines" },
		},
		format_after_save = { timeout_ms = 500 },
		formatters = {
			pg_format = { command = "pg_format", append_args = { "--keyword-case=1" } },
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
			prettier_jinja = prettier_pnp("jinja-template"),
			prettier_svelte = prettier_pnp("svelte"),
		},
	},
}
