#!/usr/bin/env lua

local fn = vim.fn
local o = vim.o

require("lf").setup({
    direction = "float",
    height = fn.float2nr(fn.round(0.75 * o.lines)),  -- height of the floating window
    width = fn.float2nr(fn.round(0.5 * o.columns)), -- width of the floating window
    escape_quit = false,
    winblend = 0,
    border = "single",
})

vim.keymap.set("n", "tt", "<Cmd>Lf<CR>")
