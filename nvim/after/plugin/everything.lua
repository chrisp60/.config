local lsp = require("lsp-zero")
lsp.preset({
    name = "recommended",
    suggest_lsp_servers = false,
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-t>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
})

lsp.setup_nvim_cmp({
    -- Allows Enter key to be used freely.
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    mapping = cmp_mappings,
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' }
    }
})

lsp.setup() -- Must be called before native lsp
lsp.on_attach(function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', '<leader>q', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', '<leader>w', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set({ 'v', 'n' }, '<leader>a', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set({ 'v', 'n' }, '<leader>h', function() vim.lsp.buf.format { async = false } end, opts)
end)

vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = false,
    underline = false,
    signs = true,
    float = false,
    severity_sort = true,
})

-- Mainly LSP stuff
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>H', builtin.help_tags, {})
vim.keymap.set('n', '<leader>S', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>s', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>R', builtin.lsp_references, {})

-- Plain lines and minimal flair, please.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, { border = nil, title = nil, })

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "rust" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

local null_ls = require("null-ls")
null_ls.setup({
    debug = true,
    sources = {
        null_ls.builtins.formatting.prettierd,
    },
})

require("indent_blankline").setup {
    show_current_context = true,
}

require('gitsigns').setup {
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end
        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        -- Actions
        map('n', '<leader>Gs', gs.stage_hunk)
        map('n', '<leader>Gu', gs.undo_stage_hunk)

        map('v', '<leader>Gs', function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end)
        map('v', '<leader>Gr', function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end)

        map('n', '<leader>GS', gs.stage_buffer)
        map('n', '<leader>GR', gs.reset_buffer)

        map('n', '<leader>Gp', gs.preview_hunk)

        map('n', '<leader>Gd', gs.diffthis)
        map('n', '<leader>GD', function() gs.diffthis('~') end)
        -- map('n', '<leader>Gt', gs.toggle_deleted)
        -- map('n', '<leader>Gr', gs.reset_hunk)
        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}
