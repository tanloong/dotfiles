#!/usr/bin/env lua

require("lf").setup({
    direction = "float",
    escape_quit = false,
    winblend = 0,
    border = "single",
})

vim.keymap.set("n", "tt", "<Cmd>Lf<CR>")
