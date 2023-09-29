#!/usr/bin/env lua

local hl = vim.api.nvim_set_hl
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

hl(0, 'Visual', { ctermbg = 'lightgray', ctermfg = 'black' })
hl(0, 'Conceal', { ctermbg = 'none', ctermfg = 'none' })
hl(0, 'MatchParen', { ctermbg = 'none', ctermfg = 'green' })
hl(0, 'Pmenu', { ctermbg = 236, ctermfg = 'none' })
hl(0, 'PmenuSel', { ctermbg = 24, ctermfg = 'none' })
hl(0, 'Folded', { ctermbg = 'none', ctermfg = 14 })
hl(0, 'SpellBad', { undercurl = true, ctermbg = 'none', ctermfg = 9 })
hl(0, 'SpellCap', { undercurl = true, ctermbg = 'none', ctermfg = 12 })
hl(0, 'SpellLocal', { undercurl = true, ctermbg = 'none', ctermfg = 14 })
hl(0, 'SpellRare', { undercurl = true, ctermbg = 'none', ctermfg = 13 })
hl(0, 'SignColumn', { ctermbg = 'none' })
hl(0, 'DiffAdd', { ctermfg = 'green' })
hl(0, 'DiffChange', { ctermfg = 'yellow' })
hl(0, 'DiffDelete', { ctermfg = 'red' })
hl(0, 'StatusLine', { underline = true, bold = true })
hl(0, 'StatusLineNC', { underline = true })
hl(0, 'CursorLine', {bold=true, ctermfg='green'})

-- autocmd("TextYankPost",
--     {
--         pattern = "*",
--         group = augroup("highlight_yank", { clear = true }),
--         callback = function()
--             vim.highlight.on_yank({ higroup = "Visual", timeout = 30, on_visual = false })
--         end
--     })
