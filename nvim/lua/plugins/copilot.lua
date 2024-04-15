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
        enabled = true,
        opts = {
            panel = {
                enabled = true,
                auto_refresh = true,
                layout = {
                    position = "right", ratio = 0.3
                }
            },
            suggestion = { enabled = false },
        },
        keys = {
            { "<leader>P", "<cmd>Copilot panel<cr>", desc = "Copilot Panel" },
        }
    },
}
