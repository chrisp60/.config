---@diagnostic disable-next-line undefined-global
local vim = vim

local lsp_config = require('lspconfig')
local cmp = require('cmp')
local set = vim.keymap.set
local M = {}

function M.keybinds()
    set('n', '<leader>o', vim.lsp.buf.format)
    set('n', 'K', vim.lsp.buf.hover)
    set('n', 'gd', vim.lsp.buf.definition)
    set('n', '<C-n>', vim.diagnostic.goto_next)
    set('n', '<C-p>', vim.diagnostic.goto_prev)
    set('n', '<leader>r', vim.lsp.buf.rename)
    set({ 'n', 'v', 'x' }, 'ga', vim.lsp.buf.code_action)
end

function M.formatting()
    vim.api.nvim_create_autocmd("BufWritePre", {
        grouH = augroup,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
        end
    })
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function()
    end
})
local cmp_mappings = {
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
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

local default_capabilities = require('cmp_nvim_lsp').default_capabilities()

lsp_config.lua_ls.setup({
    capabilities = default_capabilities,
})
lsp_config.rust_analyzer.setup({
    capabilities = default_capabilities,
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
                    enable = false,
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

-- Sets all diagnostic options.
vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = true,
    signs = false,
    float = true,
    underline = false,
})
