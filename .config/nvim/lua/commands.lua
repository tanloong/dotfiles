#!/usr/bin/env lua

local vim_api = vim.api

vim_api.nvim_create_user_command('Delete',
    'if filereadable(expand("%"))|call delete(expand("%"))|execute ":bd"|execute ":bn"', { force = true })
vim_api.nvim_create_user_command('Rename', 'let @s=expand("%")|f <args>|w<bang>|call delete(@s)',
    { force = true, nargs = 1, bang = true, complete = 'file' })
vim_api.nvim_create_user_command('CopyPath', [[let @+ = expand('%:p')]], { force = true })
