-- lsp
local function inspect_token()
    local token = vim.lsp.semantic_tokens.get_at_pos()[1]
    local LEVEL = vim.log.levels.INFO
    if token ~= nil then
        local msg = vim.inspect({
            token.type,
            token.modifiers,
        })
        vim.notify(msg, LEVEL)
    else
        vim.notify("No token under cursor", LEVEL)
    end
end


local rust_analyzer_settings = {
    cargo = {
        features = "all",
        buildScripts = {
            rebuildOnSave = true,
        },
    },
    diagnostics = {
        disabled = {
            "inactive-code",
            "unlinked-file",
        },
        experimental = {
            enable = true,
        },
    },
    rustfmt = {
        overrideCommand = {
            "leptosfmt",
            "--stdin",
            "--rustfmt",
            "--max-width=90",
            "--tab-spaces=2",
        },
    },
    check = {
        features = "all",
        command = "clippy",
    },
    completion = {
        fullFunctionSignatures = true,
        postfix = {
            enable = true,
        },
    },
    inlayHints = {
        bindingModeHints = { enable = true },
        closureCaptureHints = { enable = true },
        closureReturnTypes = { enable = true },
        implicitDrops = { enable = true },
        liftetimeElisionHints = { enable = "always" },
    },
}

return {
    { "wesleimp/stylua.nvim", ft = "lua" },

    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "VonHeikemen/lsp-zero.nvim" },
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
                    { name = "nvim_lsp" },
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
                formatting = require("lsp-zero").cmp_format(),
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
            require("lsp-zero").on_attach(function()
                require("lsp-zero").buffer_autoformat()
                local tele = require("telescope.builtin")

                vim.keymap.set("n", "<leader>e", inspect_token)
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
