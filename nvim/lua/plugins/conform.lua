---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
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
			javascript = { "prettierd" },
			html = { "prettierd" },
			htmldjango = { "djlint" },
			rust = { "rustfmt" },
			toml = { "taplo" },
			sql = { "sleek" },
		},
		format_on_save = { timeout_ms = 3000, lsp_format = "fallback" },
		formatters = {
			sleek = { prepend_args = { "--uppercase", "false" } },
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
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
