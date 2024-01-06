-- lsp
return {
    { "wesleimp/stylua.nvim", ft = "lua" },

    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    {
        "VonHeikemen/lsp-zero.nvim",
        lazy = true,
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        branch = "v3.x",
        config = function()
            require('lsp-zero').on_attach(function()
                require("lsp-zero").buffer_autoformat()
                local tele = require("telescope.builtin")

                vim.keymap.set("n", "<leader>R", tele.lsp_references)
                vim.keymap.set("n", "<leader>S", tele.lsp_document_symbols)
                vim.keymap.set("n", "<leader>d", tele.diagnostics)
                vim.keymap.set("n", "<leader>s", tele.lsp_dynamic_workspace_symbols)

                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
                vim.keymap.set("n", "K", vim.lsp.buf.hover)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition)

                vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
                vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)

                vim.keymap.set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action)

                vim.keymap.set({ "n", "v", "x" }, "<leader>i", function()
                    local current = vim.lsp.inlay_hint.is_enabled(0)
                    vim.lsp.inlay_hint.enable(0, not current)
                end)
            end)
        end,
    },

    {
        "neovim/nvim-lspconfig",
        lazy = false,
    },

    {
        "williamboman/mason.nvim",
        opts = {}
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
                    require('lsp-zero').default_setup,
                    lua_ls = function()
                        require("lspconfig").lua_ls.setup(require('lsp-zero').nvim_lua_ls({}))
                    end,
                    rust_analyzer = function()
                        require("lspconfig")["rust_analyzer"].setup({
                            settings = {
                                ["rust-analyzer"] = {
                                    cargo = {
                                        features = "all"
                                    },
                                    diagnostics = {
                                        disabled = {
                                            "inactive-code",
                                            "unlinked-file"
                                        },
                                    },
                                    check = {
                                        features = "all",
                                        command = "clippy",
                                    },
                                    -- completion = { postfix = { enable = false } },
                                },
                            }
                        })
                    end,
                },
            })
        end,

    },
}
