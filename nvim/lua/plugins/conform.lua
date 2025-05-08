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
			svelte = { "prettier_svelte", lsp_format = "fallback" },
			javascript = { "prettierd" },
			markdown = { "prettierd" },
			html = { "prettierd" },
			htmldjango = { "prettier_jinja" },
			json = { "jq" },
			rust = { "rustfmt" },
			toml = { "taplo" },
			sql = { "sqlfluff" },
			gitcommit = { "commitmsgfmt" },
			["*"] = { "trim_whitespace", "trim_newline" },
		},
		format_on_save = { timeout_ms = 5000 },
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
			prettier_jinja = prettier_pnp("jinja-template"),
			prettier_svelte = prettier_pnp("svelte"),
		},
	},
}
