#!/usr/bin/env lua

vim.api.nvim_create_user_command('Delete',
    'if filereadable(expand("%"))|call delete(expand("%"))|execute ":bd"|execute ":bn"', { force = true })
vim.api.nvim_create_user_command('Rename', 'let @s=expand("%")|f <args>|w<bang>|call delete(@s)',
    { force = true, nargs = 1, bang = true, complete = 'file' })
vim.api.nvim_create_user_command('CopyPath', [[let @+ = expand('%:p')]], { force = true })
