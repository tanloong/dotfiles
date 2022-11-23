#!/usr/bin/env lua
vim.g['slime_target'] = "neovim"
vim.g['slime_no_mappings'] = 1
vim.g['slime_preserve_curpos'] = 0
vim.keymap.set('x', '<c-c><c-c>', '<Plug>SlimeRegionSend')
vim.keymap.set('x', '<F5>', '<c-c><c-c>`>', {remap=true})
vim.keymap.set('n', '<F5>', '<Cmd>SlimeSendCurrentLine<CR>j')
vim.keymap.set('n', '<c-c>v', '<Plug>SlimeConfig')
vim.keymap.set('n', 's<F5>', '<Plug>SlimeSendCell')

