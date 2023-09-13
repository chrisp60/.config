local lsp_config = require('lspconfig')
local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local M = {}

function M.diagnostics()
    vim.diagnostic.config({
        update_in_insert = true,
        virtual_text = true,
        signs = false,
        float = true,
        underline = false,
    })
end

function M.keybinds()
    vim.keymap.set('n', '<leader>o', vim.lsp.buf.format)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
    vim.keymap.set('n', '<C-n>', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<C-p>', vim.diagnostic.goto_prev)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
    vim.keymap.set({ 'n', 'v', 'x' }, 'ga', vim.lsp.buf.code_action)
end

function M.formatting()
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            vim.lsp.buf.format()
        end
    })
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function()
        M.keybinds()
        M.formatting()
        M.diagnostics()
    end
})

local cmp_mappings = {
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
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


lsp_config.lua_ls.setup({
    capabilities = cmp_nvim_lsp.default_capabilities(),
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})
lsp_config.rust_analyzer.setup({
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
                    enable = false,
                },
            },
            references = {
                excludeImports = {
                    enable = true,
                }
            },
            hover = {
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
            },
            procMacro = {
                enable = true,
                attributes = {
                    enable = true,
                }
            },
        }
    }
})

return M
