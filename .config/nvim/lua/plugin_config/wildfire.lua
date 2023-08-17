#!/usr/bin/env lua
return require("wildfire").setup({
    surrounds = {
        { "(", ")" },
        { "{", "}" },
        { "<", ">" },
        { "[", "]" },
    },
    keymaps = {
        init_selection = "=",
        node_incremental = "=",
        node_decremental = "-",
    },
})
