#!/usr/bin/env lua

local hi = vim.api.nvim_set_hl
hi(0, 'Visual', { ctermbg = 'lightgray', ctermfg = 'black' })
hi(0, 'Conceal', { ctermbg = 'none', ctermfg = 'none' })
hi(0, 'MatchParen', { ctermbg = 'none', ctermfg = 'green' })
hi(0, 'Pmenu', { ctermbg = 236, ctermfg = 'none' })
hi(0, 'PmenuSel', { ctermbg = 24, ctermfg = 'none' })
hi(0, 'Folded', { ctermbg = 'none', ctermfg = 14 })
hi(0, 'SpellBad', { undercurl = true, ctermbg = 'none', ctermfg = 9 })
hi(0, 'SpellCap', { undercurl = true, ctermbg = 'none', ctermfg = 12 })
hi(0, 'SpellLocal', { undercurl = true, ctermbg = 'none', ctermfg = 14 })
hi(0, 'SpellRare', { undercurl = true, ctermbg = 'none', ctermfg = 13 })
