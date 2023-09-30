local lsp = function(args)
    vim.keymap.set('n', '<leader>o', vim.lsp.buf.format, { desc = 'format [LSP]' })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'hover [LSP]' })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'definition [LSP]' })
    vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next, { desc = 'next diagnostic [LSP]' })
    vim.keymap.set('n', '<C-p>', vim.diagnostic.goto_prev, { desc = 'next diagnostic [LSP]' })
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'rename [LSP]' })
    vim.keymap.set({ 'n', 'v', 'x' }, 'ga', vim.lsp.buf.code_action, { desc = 'code action [LSP]' })
    vim.keymap.set('n', '<leader>O', function() vim.cmd([[silent%! leptosfmt -t 2 -s]]) end)
    vim.keymap.set('n', '<leader>X', vim.diagnostic.hide, { desc = 'hide diagnostic [LSP]' })
    vim.keymap.set('n', '<leader>x', vim.diagnostic.show, { desc = 'show diagnostic [LSP]' })
    vim.keymap.set('n', '<leader>I', function() vim.lsp.inlay_hint(0) end, { desc = 'toggle inlay hints [LSP]' })
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(args)
        lsp(args)
        vim.diagnostic.config({
            update_in_insert = true,
            virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
            signs = true,
            float = true,
            underline = false,
        })
    end
})

local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local cmp_mappings = {
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
}

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    preselect = 'none',
    completion = { completeopt = 'menu,menuone,noselectpreview' },
    mapping = cmp_mappings,
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip', },
        { name = 'buffer' },
        { name = 'path' },
    },
    experimental = { ghost_text = true },
})


require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
            capabilities = cmp_nvim_lsp.default_capabilities(),
        }
    end,
    ["rust_analyzer"] = function()
        require("lspconfig")["rust_analyzer"].setup({
            capabilities = cmp_nvim_lsp.default_capabilities(),
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
                    interpret = {
                        tests = true,
                    },
                    cargo = {
                        buildScripts = {
                            enable = true,
                        },
                        features = "all",
                    },
                    check = {
                        command = "clippy"
                    },
                    completion = {
                        callable = {
                            snippets = "fill_arguments",
                        },
                        postfix = {
                            enable = true,
                        },
                    },
                    references = {
                        excludeImports = {
                            enable = true,
                        }
                    },
                    hover = {
                        actions = {
                            enable = true,
                            run = {
                                enable = true
                            },
                            debug = {
                                enable = true,
                            },
                        },
                        links = {
                            enable = true,
                        },
                        memoryLayout = {
                            size = 'both',
                            enable = true,
                            niches = true,
                        },
                    },
                    diagnostics = {
                        disabled = { "inactive-code" },
                        experimental = {
                            enable = true,
                        }
                    },
                    procMacro = {
                        ignored = {
                            leptos_macro = {
                                "server",
                                "component",
                            },
                        },
                        enable = true,
                        attributes = {
                            enable = true,
                        }
                    },
                    semanticHighlighting = {
                        punctuation = {
                            enable = true,
                            separate = {
                                macro = {
                                    bang = true
                                }
                            },
                        },
                    }
                }
            }
        })
    end
}
