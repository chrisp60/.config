-- I dont know how I feel about copilot right now and sometimes its a little
-- annoying.
return {
    {
        "zbirenbaum/copilot-cmp",
        lazy = false,
        enabled = true,
        opts = {},
    },
    {
        "zbirenbaum/copilot.lua",
        lazy = false,
        enabled = true,
        opts = {
            panel = { enabled = false },
            suggestion = { enabled = false },
        },
    },
}
