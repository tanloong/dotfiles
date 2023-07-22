#!/usr/bin/env lua

require('scrollview').setup({
    current_only = false,
    winblend = 80,
    base = 'right',
    column = 1,
    signs_on_startup = { 'search' }
})

local hi = vim.api.nvim_set_hl
hi(0, 'ScrollView', { ctermbg = 'gray', ctermfg = 'none' })
