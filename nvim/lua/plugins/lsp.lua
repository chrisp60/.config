local util = require("util")

---@param client vim.lsp.Client
---@param bufnr integer
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }
    local toks = vim.lsp.semantic_tokens
    local toks_supp = client.server_capabilities.semanticTokensProvider ~= nil
    local toks_on = toks_supp

    util.leader("S", function()
        if not toks_supp then
            vim.notify(client.name .. " does not support semantic tokens")
        elseif toks_on then
            vim.notify("disabling tokens")
            toks.stop(bufnr, client.id)
        else
            vim.notify("enabling tokens")
            toks.start(bufnr, client.id)
        end
        toks_on = not toks_on
    end)

    util.leader("i", function()
        if client.server_capabilities.inlayHintProvider ~= nil then
            local hints_on = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            if hints_on then
                vim.notify("hiding inlay hints")
            else
                vim.notify("showing inlay hints")
            end
            vim.lsp.inlay_hint.enable(not hints_on)
        else
            vim.notify(client.name .. " lsp does not support inlay hints")
        end
    end)
    util.leader("r", vim.lsp.buf.rename)

    vim.keymap.set("n", "gn", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action, opts)
end

return {

    { "williamboman/mason.nvim", opts = {} },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "wesleimp/stylua.nvim" },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "folke/neodev.nvim", opts = {} },
        },
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
            local just_lsp = { config = { sources = { { name = "nvim_lsp" } } } }
            return {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "nvim_lua" },
                },
                preselect = cmp.PreselectMode.None,
                mapping = {
                    ["<C-y>"] = cmp.mapping.complete(just_lsp),
                    ["<C-n>"] = lsp_zero.cmp_action().luasnip_jump_forward(),
                    ["<C-p>"] = lsp_zero.cmp_action().luasnip_jump_backward(),
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
            local lsp_zero = require("lsp-zero")
            lsp_zero.format_on_save({
                servers = {
                    ["taplo"] = { "toml" },
                    ["rust_analyzer"] = { "rust" },
                    ["lua_ls"] = { "lua" },
                },
            })
            lsp_zero.on_attach(on_attach)
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
                                    cargo = {},
                                    diagnostics = {},
                                    rustfmt = {},
                                    procMacro = {
                                        ignored = {
                                            tracing_attributes = {
                                                "instrument",
                                            },
                                            serde_with_macros = {
                                                "serde_as",
                                            }
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
