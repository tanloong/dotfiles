#!/usr/bin/env lua

local keyset = vim.keymap.set

require("fzf-lua").setup({
  winopts = {
    fullscreen = true,
    border = false,
    preview = { hidden = 'hidden' },
  },
})

keyset('n', '<leader>b', require("fzf-lua").buffers, {})
keyset('n', '<leader><leader>', require("fzf-lua").files, {})
keyset('n', '<leader>g', require("fzf-lua").grep, {})
keyset('n', '<leader>*', require("fzf-lua").grep_cword, {})
keyset('v', '<leader>*', require("fzf-lua").grep_visual, {})
keyset('n', '<c-/>', require("fzf-lua").blines, {})
keyset('n', '<leader>/', function() require("fzf-lua").files({ cwd = "vim.fn.stdpath('config')" }) end, {})

vim.cmd([[
    cabbrev <expr> h (getcmdtype() == ':' && getcmdline() == 'h' ?
                     \ 'FzfLua help_tags<cr>'
                     \: 'h')
    cabbrev <expr> Man (getcmdtype() == ':' && getcmdline() == 'Man' ?
                       \ 'FzfLua manpages<cr>'
                       \: 'h')
    ]])
