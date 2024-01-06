local function keys()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    return {
        "gA", function() mark.add_file() end,
        "gm", function() ui.toggle_quick_menu() end,
        "<leader>1", function() ui.nav_file(1) end,
        "<leader>2", function() ui.nav_file(2) end,
        "<leader>3", function() ui.nav_file(3) end,
        "<leader>4", function() ui.nav_file(4) end,
    }
end

return {
    {
        "theprimeagen/harpoon",
        config = keys
    },
}
