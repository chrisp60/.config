-- I dont know how I feel about copilot right now and sometimes its a little
-- annoying.
return {
    {
        "zbirenbaum/copilot-cmp",
        lazy = false,
        enabled = false,
        opts = {},
    },
    {
        "zbirenbaum/copilot.lua",
        lazy = false,
        enabled = false,
        opts = {
            panel = { enabled = false },
            suggestion = { enabled = false },
        },
    },
}
