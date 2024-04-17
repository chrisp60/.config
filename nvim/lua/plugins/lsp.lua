return {
    { "williamboman/mason.nvim",  opts = {} },
    { "L3MON4D3/LuaSnip", },
    { "saadparwaiz1/cmp_luasnip", },
    { "hrsh7th/cmp-nvim-lsp", },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            { "folke/neodev.nvim", opts = {} },
        },
    },
    {
        "wesleimp/stylua.nvim",
        ft = "lua",
        config = function()
            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                pattern = ".lua",
                callback = require("stylua").format,
            })
        end,
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
            return {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sources = {
                    {
                        name = "nvim_lsp",
                        priority_weight = 1,
                    },
                    {
                        name = "luasnip",
                        priority_weight = 1,
                    },
                    {
                        name = "nvim_lua",
                        priority_weight = 1
                    },
                },
                view = {
                    entries = {
                        selection_order = "near_cursor",
                    },
                },
                preselect = cmp.PreselectMode.None,
                mapping = {
                    ["<C-y>"] = cmp.mapping.complete({ config = { sources = { { name = "nvim_lsp" } } } }),
                    ["<C-p>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-n>"] = cmp.mapping.scroll_docs(4),
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ["<C-l>"] = cmp.mapping.confirm({ select = true }),
                },
                formatting = require("lsp-zero").cmp_format({ details = true }),
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
            lsp_zero.on_attach(function(client, _)
                if client.name == "html" then
                    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                        pattern = { "*.html" },
                        callback = function()
                            vim.cmd([[%!prettierd %]])
                        end,
                    })
                else
                    lsp_zero.buffer_autoformat()
                end
                vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
                vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)

                local tele = require("telescope.builtin")
                vim.keymap.set("n", "<leader>R", tele.lsp_references)
                vim.keymap.set("n", "<leader>S", tele.lsp_document_symbols)
                vim.keymap.set("n", "<leader>d", tele.diagnostics)
                vim.keymap.set("n", "<leader>s", tele.lsp_workspace_symbols)

                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
                vim.keymap.set("n", "K", vim.lsp.buf.hover)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition)

                vim.keymap.set({ "n", "v", "x" }, "<leader>i", function()
                    vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
                end)

                vim.keymap.set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action)
            end)
        end,
    },


    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "VonHeikemen/lsp-zero.nvim",
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            handlers = {
                lua_ls = function()
                    require("lspconfig").lua_ls.setup(require("lsp-zero").nvim_lua_ls({}))
                end,
                rust_analyzer = function()
                    require("lspconfig")["rust_analyzer"].setup({
                        settings = {
                            ["rust-analyzer"] = {
                                cargo = {
                                    features = "all",
                                },
                                diagnostics = {
                                    disabled = {
                                        "inactive-code",
                                        "unlinked-file",
                                    },
                                },
                                procMacro = {
                                    ignored = {
                                        tracing_attributes = {
                                            "instrument",
                                        },
                                    },
                                },
                                check = {
                                    features = "all",
                                    command = "clippy",
                                },
                                hover = {
                                    memoryLayout = {
                                        enable = true,
                                        alignment = "both",
                                        niches = true,
                                        offset = "both",
                                        size = "both",
                                    },
                                },
                            },
                        },
                    })
                end,
            },
        },
    },
}
