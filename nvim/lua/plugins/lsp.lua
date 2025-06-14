local set = vim.keymap.set

set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

local ra_config = {
	settings = {
		["rust-analyzer"] = {
			showDependenciesExplorer = false,
			completion = {
				postfix = { enable = false },
				limit = 10,
				autoIter = { enable = false },
				excludeTraits = { "std::iter::IntoIterator", "std::iter::Iterator" },
			},
			check = { command = "clippy" },
			diagnostics = {
				disabled = {
					"inactive-code",
					"unlinked-file",
					"macro-error",
					"proc-macro-disabled",
				},
			},
			procMacro = {
				ignored = {
					sqlx_macros = {
						"test",
					},
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
		},
	},
}

---@param client vim.lsp.Client
---@param bufnr integer
---@diagnostic disable-next-line:unused-local
local on_attach = function(client, bufnr)
	---@diagnostic disable: deprecated

	local function opts(desc)
		return { buffer = bufnr, desc = "LSP: " .. desc }
	end

	if client.name == "rust_analyzer" then
		set("n", "<leader>o", function()
			require("ferris.methods.open_parent_module")()
		end, opts("Ferris open parent"))
	end

	set("n", "<c-n>", function()
		vim.diagnostic.goto_next({ severity = { min = "WARN", max = "ERROR" } })
	end, opts("next ERROR diagnostic"))

	set("n", "<c-p>", function()
		vim.diagnostic.goto_prev({ severity = { min = "WARN", max = "ERROR" } })
	end, opts("prev ERROR diagnostic"))

	set("i", "<C-h>", vim.lsp.buf.signature_help, opts("signature help"))
	set("n", "<leader>r", vim.lsp.buf.rename, opts("rename"))
	set("n", "K", function()
		vim.lsp.buf.hover({ border = "single" })
	end, opts("hover"))
	set("n", "gd", vim.lsp.buf.definition, opts("definition"))
	set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action, opts("code action"))
	set({ "n", "v", "x" }, "<leader>a", vim.lsp.buf.code_action, opts("code action"))
end

---@module "lazy"
---@type LazyPluginSpec[]
return {
	{ "vxpm/ferris.nvim", opts = {} },

	{
		"j-hui/fidget.nvim",
		opts = {
			-- Per catpuccin theme docs
			notification = { window = { winblend = 0 } },
		},
	},

	{ "williamboman/mason.nvim", opts = {} },

	{ "saadparwaiz1/cmp_luasnip" },

	{ "hrsh7th/cmp-nvim-lsp" },

	{ "wesleimp/stylua.nvim" },

	{ "folke/lazydev.nvim", ft = "lua", opts = {} },

	{ "Bilal2453/luvit-meta", lazy = true },

	{ "neovim/nvim-lspconfig", lazy = false },

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
			local select = { behavior = cmp.SelectBehavior.Select }

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = "lazydev", group_index = 0 },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lua" },
				}),
				preselect = cmp.PreselectMode.None,
				mapping = {
					["<C-y>"] = cmp.mapping.complete({
						config = {
							sources = {
								{ name = "nvim_lsp" },
								{ name = "luasnip" },
							},
						},
					}),
					["<C-l>"] = cmp.mapping.confirm({ select = true }),
					["<C-j>"] = lsp_zero.cmp_action().luasnip_next_or_expand(select),
					["<C-k>"] = lsp_zero.cmp_action().luasnip_shift_supertab(select),
					["<C-;>"] = cmp.mapping.close(),
					["<C-x>"] = cmp.mapping.close(),

					-- ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					-- ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					-- ["<C-n>"] = lsp_zero.cmp_action().luasnip_jump_forward(),
					-- ["<C-p>"] = lsp_zero.cmp_action().luasnip_jump_backward(),
				},
				formatting = lsp_zero.cmp_format({ details = true, max_width = 40 }),
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
					rust_analyzer = function()
						lsp_config.rust_analyzer.setup(ra_config)
					end,
				},
			}
		end,
	},
}
