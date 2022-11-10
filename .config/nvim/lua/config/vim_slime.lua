#!/usr/bin/env lua
vim.g['slime_target'] = "x11"
vim.g['slime_no_mappings'] = 1
vim.keymap.set('x', '<F5>', '<Plug>SlimeRegionSend')
vim.keymap.set('n', '<F5>', '<Cmd>SlimeSendCurrentLine<CR>')
vim.keymap.set('n', '<c-c>v', '<Plug>SlimeConfig')
vim.g['slime_preserve_curpos'] = 0
vim.keymap.set('n', 's<F5>', '<Plug>SlimeSendCell')

