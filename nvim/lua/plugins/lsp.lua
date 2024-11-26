local set = vim.keymap.set

---@type lsp_zero.config.ClientConfig
local ra = {
	settings = {
		["rust-analyzer"] = {
			procMacro = {
				enabled = true,
			},
			imports = {
				merge = {
					glob = false,
				},
				prefix = "crate",
				granularity = {
					enforce = true,
					group = "crate",
				},
			},
			completion = {
				-- callable = { snippets = "none" },
				fullFunctionSignature = { enable = true },
			},
			check = {
				command = "clippy",
			},
		},
	},
}

---@param _client vim.lsp.Client
---@param bufnr integer
---@diagnostic disable-next-line:unused-local
local on_attach = function(_client, bufnr)
	local opts = { buffer = bufnr }

	for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
		local default_diagnostic_handler = vim.lsp.handlers[method]
		vim.lsp.handlers[method] = function(err, result, context, config)
			if err ~= nil and err.code == -32802 then
				return
			end
			return default_diagnostic_handler(err, result, context, config)
		end
	end

	set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
	set("n", "<leader>r", vim.lsp.buf.rename, opts)
	set("n", "K", vim.lsp.buf.hover, opts)
	set("n", "gd", vim.lsp.buf.definition, opts)
	set("n", "gn", vim.diagnostic.goto_next, opts)
	set("n", "gp", vim.diagnostic.goto_prev, opts)
	set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action, opts)

	vim.api.nvim_set_hl(0, "@lsp.type.function.rust", {})
	vim.api.nvim_set_hl(0, "@lsp.type.method.rust", {})
end

---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{
		"vxpm/ferris.nvim",
		opts = {},
	},
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
	{
		"rayliwell/tree-sitter-rstml",
		enabled = false,
		dependencies = { "nvim-treesitter" },
		ft = "rust",
		build = ":TSUpdate",
		name = "tree-sitter-rstml",
		opts = {},
	},
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{ "saadparwaiz1/cmp_luasnip" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "wesleimp/stylua.nvim" },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {},
	},

	-- lsp stuff for config
	{ "Bilal2453/luvit-meta", lazy = true },

	{
		"neovim/nvim-lspconfig",
		lazy = false,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"VonHeikemen/lsp-zero.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			local cmp = require("cmp")
			local lsp_zero = require("lsp-zero")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "lazydev", group_index = 0 },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lua" },
				},
				preselect = cmp.PreselectMode.None,
				mapping = {
					["<C-y>"] = cmp.mapping.complete({
						config = {
							sources = {
								{ name = "nvim_lsp" },
							},
						},
					}),
					["<C-k>"] = lsp_zero.cmp_action().luasnip_shift_supertab(),
					["<C-j>"] = lsp_zero.cmp_action().luasnip_supertab(),
					["<C-l>"] = cmp.mapping.confirm(),
				},
				experimental = { ghost_text = false },
			})
		end,
	},

	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		branch = "v3.x",
		config = function()
			require("lsp-zero").on_attach(on_attach)
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"VonHeikemen/lsp-zero.nvim",
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = function()
			local lsp_zero = require("lsp-zero")
			local lsp_config = require("lspconfig")
			return {
				handlers = {
					-- Handlers for everything else
					lsp_zero.default_setup,
					html = function()
						lsp_config.html.setup({
							filetypes = { "html", "templ", "htmldjango" },
							settings = {
								html = {
									format = {
										wrapLineLength = 80,
										templating = true,
										indentHandlebars = true,
									},
								},
							},
						})
					end,
					lua_ls = function()
						lsp_config.lua_ls.setup({
							settings = {
								Lua = {
									completion = {
										callSnippet = "Replace",
										displayContext = 4,
										keywordSnippet = "Both",
									},
								},
							},
						})
					end,
					rust_analyzer = function()
						lsp_config.rust_analyzer.setup(ra)
					end,
				},
			}
		end,
	},
}
