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
    vim.keymap.set('n', '<leader>k', "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>K', "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', '<leader>q', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', '<leader>w', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set({ 'v', 'n' }, '<leader>a', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set({ 'v', 'n' }, '<leader>h', function() vim.lsp.buf.format { async = true } end, opts)
end)


vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = false,
    underline = false,
    signs = false,
    float = false,
    severity_sort = true,
})

-- Mainly LSP stuff
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>H', builtin.help_tags, {})
vim.keymap.set('n', '<leader>s', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>R', builtin.lsp_references, {})
-- Plain lines and minimal flair, please.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, { border = nil, title = nil, })

-- Telescope and telescope accesories
local tele = require('telescope')
tele.setup {
    defaults = {
        layout_strategy = 'flex',
        layout_config = { prompt_position = 'bottom' },
        wrap_results = false,
        border = true,
    }
}

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

require('trouble').setup({
    position = "right",
    width = 80,
    group = true,                     -- group results by file
    padding = false,                  -- add an extra new line on top of the list
    action_keys = {
        close = "q",                  -- close the list
        cancel = "<esc>",             -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r",                -- manually refresh
        jump = { "<cr>" },            -- jump to the diagnostic or open / close folds
        open_split = {},
        open_vsplit = { "<c-v>" },    -- open buffer in new vsplit
        open_tab = { "<c-t>" },       -- open buffer in new tab
        jump_close = { "o" },         -- jump to the diagnostic and close the list
        toggle_mode = "m",            -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P",         -- toggle auto_preview
        hover = "K",                  -- opens a small popup with the full multiline message
        preview = "p",                -- preview the diagnostic location
        close_folds = { "zM", "zm" }, -- close all folds
        open_folds = { "zR", "zr" },  -- open all folds
        toggle_fold = { "zA", "za" }, -- toggle fold of current file
        previous = "k",               -- previous item
        next = "j"                    -- next item
    },
    indent_lines = false,             -- add an indent guide below the fold icons
    auto_open = false,                -- automatically open the list when you have diagnostics
    auto_close = false,               -- automatically close the list when you have no diagnostics
    auto_preview = false,             -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false,                -- automatically fold a file trouble list at creation
    icons = false,
    use_diagnostic_signs = true       -- enabling this will use the signs defined in your lsp client
})
