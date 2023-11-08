local utils = require("util")
require("lsp-format").setup({})

local prettier_ft = {}
prettier_ft["css"] = {}
prettier_ft["html"] = {}
prettier_ft["json"] = {}
prettier_ft["json-stringify"] = {}
prettier_ft["json5"] = {}
prettier_ft["markdown"] = {}
prettier_ft["scss"] = {}
prettier_ft["typescript"] = {}
prettier_ft["yaml"] = {}

local handle_formatting = function()
    local filetype = vim.filetype.match({ buf = 0 })

    for supp_prettier, _ in pairs(prettier_ft) do
        if filetype == supp_prettier then
            vim.cmd.write()
            local command = "%! npx prettier --parser " .. supp_prettier
            vim.cmd(command)
            vim.notify("using prettier" .. supp_prettier, vim.log.levels.INFO)
            return
        end
    end

    if filetype == "rust" and utils.buf_has_str(0, "leptos") then
        vim.cmd.write()
        vim.cmd([[silent !leptosfmt % -t 2 -m 80]])
        vim.notify("using leptos", vim.log.levels.INFO)
    elseif filetype == "lua" then
        require("stylua").format()
    else
        vim.lsp.buf.format()
    end
end

--- @diagnostic disable:unused-local
local WARN = vim.diagnostic.severity.WARN
local ERROR = vim.diagnostic.severity.ERROR
local INFO = vim.diagnostic.severity.INFO
local HINT = vim.diagnostic.severity.HINT

local on_attach = function(client, bufnr)
    vim.keymap.set("n", "gn", function()
        vim.diagnostic.goto_next()
    end, { desc = "goto_next" })
    vim.keymap.set("n", "gp", function()
        vim.diagnostic.goto_prev()
    end, { desc = "goto_prev" })

    vim.keymap.set("n", "<leader>o", handle_formatting, { desc = "handle formatting" })
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "rename" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "hover" })
    vim.keymap.set("n", "<leader>D", function()
        vim.diagnostic.setqflist({ open = true, title = "big dumb" })
    end, { desc = "definition" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "definition" })
    vim.keymap.set({ "n", "v", "x" }, "ga", vim.lsp.buf.code_action, { desc = "code_action" })

    -- https://github.com/lukas-reineke/lsp-format.nvim#wq-will-not-format-when-not-using-sync
    require("lsp-format").on_attach(client, bufnr)

    -- Reduce noise from lsp diagnostics
    vim.diagnostic.config({
        update_in_insert = true,
        virtual_text = {
            severity = {
                WARN,
                ERROR,
            },
        },
        signs = true,
        float = true,
        underline = false,
    })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
mason.setup()
mason_lspconfig.setup()
mason_lspconfig.setup_handlers({
    function(server_name)
        require("lspconfig")[server_name].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end,
    ["lua_ls"] = function()
        require("lspconfig").lua_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = {
                            "vim",
                            "require",
                        },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                },
            },
        })
    end,
    ["rust_analyzer"] = function()
        require("lspconfig")["rust_analyzer"].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                ["rust-analyzer"] = {
                    imports = {
                        granularity = {
                            group = "crate",
                            enforce = true,
                        },
                        group = {
                            enable = true,
                        },
                        merge = {
                            glob = false,
                        },
                        prefix = "crate",
                    },
                    completion = {
                        postfix = {
                            enable = false,
                        },
                    },
                    cargo = {
                        buildScripts = {
                            enable = true,
                        },
                        features = "all",
                    },
                    check = {
                        command = "clippy",
                    },
                    references = {
                        excludeImports = {
                            enable = true,
                        },
                    },
                    diagnostics = {
                        disabled = { "inactive-code" },
                    },
                    hover = {
                        links = {
                            enable = false,
                        },
                    },
                    procMacro = {
                        ignored = {
                            leptos_macro = {
                                "component",
                            },
                        },
                        enable = true,
                        attributes = {
                            enable = true,
                        },
                    },
                },
            },
        })
    end,
})
