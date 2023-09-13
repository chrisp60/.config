---@diagnostic disable: undefined-global
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = false,
    show_end_of_buffer = true,
    term_colors = true,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    no_italic = false,
    no_bold = false,
    styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        native_lsp = { enabled = true },
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
            colored_indent_levels = true,
        },

    },
})

vim.cmd.colorscheme "catppuccin"
vim.cmd [[:highlight MatchParen cterm=bold ctermbg=black ctermfg=NONE]]
vim.cmd [[:highlight MatchParen gui=bold guibg=black guifg=NONE]]
