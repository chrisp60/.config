-- lsp

local rust_analyzer_settings = {
    cargo = {
        features = "all",
    },
    diagnostics = {
        disabled = {
            "inactive-code",
            "unlinked-file",
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
}

return {
    { "wesleimp/stylua.nvim", ft = "lua" },


    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "VonHeikemen/lsp-zero.nvim",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            -- nvim cmp
            local cmp = require("cmp")
            local select = { behavior = cmp.SelectBehavior.Select }
            local map = cmp.mapping
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = {
                    {
                        name = "nvim_lsp",
                    },
                    { name = "copilot" },
                    { name = "luasnip" },
                    { name = "nvim_lua" },
                },
                mapping = map.preset.insert({
                    -- select cmp options
                    ["<C-d>"] = map.scroll_docs(-4),
                    ["<C-f>"] = map.scroll_docs(4),
                    ["<C-k>"] = map.select_prev_item(select),
                    ["<C-j>"] = map.select_next_item(select),
                    ["<C-l>"] = map.confirm({ select = true }),
                }),
                formatting = require("lsp-zero").cmp_format({ details = true }),
                experimental = { ghost_text = false },
            })
        end,
    },

    {
        "VonHeikemen/lsp-zero.nvim",
        lazy = true,
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        branch = "v3.x",
        config = function()
            require("lsp-zero").on_attach(function(client, bufnr)
                if client.name == "html" then
                    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                        pattern = { "*.html" },
                        callback = function(ev)
                            -- vim.cmd([[%!prettierd %]])
                        end
                    })
                else
                    require("lsp-zero").buffer_autoformat()
                end

                -- the semantic tokens for decorators became ugly for some
                -- reason, so we're linking it to the function token
                -- (the superior pretty one).
                vim.api.nvim_set_hl(0, "@lsp.type.decorator.rust", {
                    link = "@lsp.type.function"
                })
                vim.api.nvim_set_hl_ns(0)

                vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
                vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)

                local tele = require("telescope.builtin")
                vim.keymap.set("n", "<leader>I", tele.lsp_incoming_calls)
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
        "neovim/nvim-lspconfig",
        lazy = false,
    },

    {
        "williamboman/mason.nvim",
        opts = {},
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "VonHeikemen/lsp-zero.nvim",
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {},
                handlers = {
                    require("lsp-zero").default_setup,
                    lua_ls = function()
                        require("lspconfig").lua_ls.setup(require("lsp-zero").nvim_lua_ls({}))
                    end,
                    rust_analyzer = function()
                        require("lspconfig")["rust_analyzer"].setup({
                            settings = {
                                ["rust-analyzer"] = rust_analyzer_settings,
                            },
                        })
                    end,
                },
            })
        end,
    },
}
