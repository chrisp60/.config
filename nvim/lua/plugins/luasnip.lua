---@diagnostic disable:unused-local
local luasnip = require("luasnip")
local snippet = luasnip.snippet
local text = luasnip.text_node
local insert = luasnip.insert_node
local choice = luasnip.choice_node
local format = require("luasnip.extras.fmt").fmt

local derive = snippet(
    "derive",
    format("#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, PartialOrd Eq, Ord, Hash)]", {})
)

luasnip.add_snippets("all", {
    derive,
})

luasnip.add_snippets("all", {
    snippet(
        "<input>",
        format(
            [[
            <div class="form-floating mb-3">
                <input
                    name="{name}"
                    class="form-control"
                    autocomplete="off"
                    placeholder="~"
                />
                <label>{label}</label>
            </div>
            ]],
            {
                name = insert(1),
                label = insert(2),
            },
            { repeat_duplicates = true }
        )
    ),
})

return {
    "L3MON4D3/LuaSnip",
    opts = {},
}
