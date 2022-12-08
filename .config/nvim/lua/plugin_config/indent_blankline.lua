#!/usr/bin/env lua
local hi = vim.api.nvim_set_hl
hi(0, 'IndentBlanklineChar', { ctermbg = 'none', ctermfg = 'darkgray' })
require("indent_blankline").setup {
    show_end_of_line = false,
}
