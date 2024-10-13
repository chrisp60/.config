local set = vim.keymap.set

---@param client vim.lsp.Client
---@param bufnr integer
local on_attach = function(client, bufnr)
	local opts = { buffer = bufnr }

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

---@type LazyPluginSpec[]
return {
	{
		"vxpm/ferris.nvim",
		enabled = false,
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
		ft = "lua", -- only load on lua files
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
		opts = function()
			local cmp = require("cmp")
			local lsp_zero = require("lsp-zero")
			return {
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
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-l>"] = cmp.mapping.confirm({ select = true }),
				},
				formatting = lsp_zero.cmp_format({ details = true }),
				experimental = { ghost_text = false },
			}
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
						lsp_config.rust_analyzer.setup({
							settings = {
								["rust-analyzer"] = {
									semanticHighlighting = {
										punctuation = {
											specialization = {
												enable = true,
											},
											enable = true,
											separate = {
												macro = {
													bang = false,
												},
											},
										},
										doc = {
											comment = {
												inject = {
													enable = true,
												},
											},
										},
									},
									hover = {
										memoryLayout = {
											niches = true,
										},
										show = {
											traitAssocItems = 30,
										},
									},
									completion = {
										termSearch = {
											enable = true,
										},
										callable = {
											snippets = "add_parantheses",
										},
										fullFunctionSignatures = {
											enable = true,
										},
										postfix = {
											enable = false,
										},
									},
									diagnostics = {
										disabled = { "inactive-code", "unlinked-file", "macro-error" },
									},
									procMacro = {
										enabled = true,
										ignored = {
											tokio_macros = {
												"main",
												"test",
											},
											tracing_attributes = {
												"instrument",
											},
											serde_with_macros = {
												"serde_as",
											},
										},
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
									check = {
										command = "clippy",
									},
								},
							},
						})
					end,
				},
			}
		end,
	},
}
