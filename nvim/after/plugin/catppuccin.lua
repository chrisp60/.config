local flavour = os.getenv('CATPPUCCIN_FLAVOUR') or 'mocha'

---@diagnostic disable: undefined-global
require("catppuccin").setup({
    flavour = flavour,
    transparent_background = false,
    show_end_of_buffer = true,
    term_colors = true,
    no_italic = false,
    no_bold = false,
    styles = {},
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "bold" },
                hints = { "bold" },
                warnings = { "bold" },
                information = { "bold" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = true,
        mini = true,
        harpoon = true,
        vimwiki = true,
        which_key = true,
        mason = true,
        markdown = true,
        indent_blankline = {
            enabled = true,
        },

    },
})

vim.cmd.colorscheme "catppuccin"
vim.cmd [[:highlight MatchParen cterm=bold ctermbg=black ctermfg=NONE]]
vim.cmd [[:highlight MatchParen gui=bold guibg=black guifg=NONE]]
