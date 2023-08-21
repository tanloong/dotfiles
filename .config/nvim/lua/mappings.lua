#!/usr/bin/env lua
local keyset = vim.keymap.set
keyset({ 'n', 'v', 'o' }, 'K', '5gk')
keyset({ 'n', 'v', 'o' }, 'J', '5gj')
keyset({ 'n', 'v', 'o' }, 'H', '5h')
keyset({ 'n', 'v', 'o' }, 'L', '5l')
keyset({ 'n', 'v', 'o' }, 'Q', '@q')
keyset('n', 'j', 'gj')
keyset('n', 'k', 'gk')
keyset('n', 'gk', 'k')
keyset('n', 'gj', 'j')
keyset('n', 'S', ':!')
keyset('n', 'R', ':PackerCompile<CR>')
keyset('n', 'M', 'J')
keyset('n', 'ga', '<Cmd>tabe<CR>:term lazygit<CR>i')
keyset('n', '>', '>>')
keyset('n', '<', '<<')
keyset('n', '<c-p>', ':%s///g<Left><Left>')
keyset('v', '<c-p>', ':s///g<Left><Left>')
keyset('n', '<c-q>', '<Cmd>q!<CR>')
keyset('n', '<SPACE>e', '<Cmd>set spell!<bar>set spell?<CR>')
keyset('n', 'g<CR>', '<Cmd>set hlsearch!<bar>set hlsearch?<CR>')
keyset('n', '<F4>', '<Cmd>q!<CR>')
keyset('n', 'sv', '<Cmd>vsplit<CR>')
keyset('n', 'ss', '<Cmd>split<CR>')
keyset('n', '<up>', '<c-y>')
keyset('n', '<down>', '<c-e>')
keyset('n', '<left>', '<c-b>')
keyset('n', '<right>', '<c-f>')
keyset('n', '<up>', '<Cmd>res +2<CR>')
keyset('n', '<down>', '<Cmd>res -2<CR>')
keyset('n', '<left>', '<Cmd>vertical resize-2<CR>')
keyset('n', '<right>', '<Cmd>vertical resize+2<CR>')
keyset('n', 'te', '<Cmd>tabedit<CR>')
keyset({'n', 'v', 'o'}, 'gh', '0')
keyset({'n', 'v', 'o'}, 'gl', '$')
keyset({'n', 'v', 'o'}, 'gL', 'g$')
keyset('n', '9', '<Cmd>tabprevious<CR>')
keyset('n', '0', '<Cmd>tabnext<CR>')
keyset('n', '/', '/\\v')
keyset('v', '/', '/\\v')
keyset('n', '?', '?\\v')
keyset('v', '?', '?\\v')
keyset('n', 'vil', '0v$h')
keyset('n', 'dil', '0D')
keyset('n', 'yil', '0y$')
keyset('n', 'vib', 'ggVG')
keyset('n', 'dib', '<Cmd>%d<cr>')
keyset('n', 'yib', '<Cmd>%y<cr>')
keyset('n', 'cib', 'ggcG')
keyset('n', '<enter>', 'i<enter><esc>')
-- keyset('n', '<tab>', "<Cmd>exe 'silent!!goldendict ' .. expand('<cword>')<cr>")
keyset('v', '<tab>', ":w <Home>silent<End> !xargs goldendict<cr>")
keyset('n', 'Y', function() vim.fn.setreg('+', vim.trim(vim.api.nvim_get_current_line())) end)

-- jumping between a normal buffer and a neovim terminal
keyset('t', '<leader><esc>', '<c-\\><c-N>')
keyset('t', '<c-h>', '<c-\\><c-N><c-w>h')
keyset('t', '<c-j>', '<c-\\><c-N><c-w>j')
keyset('t', '<c-k>', '<c-\\><c-N><c-w>k')
keyset('t', '<c-l>', '<c-\\><c-N><c-w>l')
-- keyset('t', 'sh', '<c-\\><c-N><c-w>h')
-- keyset('t', 'sj', '<c-\\><c-N><c-w>j')
-- keyset('t', 'sk', '<c-\\><c-N><c-w>k')
-- keyset('t', 'sl', '<c-\\><c-N><c-w>l')
keyset('i', '<c-h>', '<c-\\><c-N><c-w>h')
keyset('i', '<c-j>', '<c-\\><c-N><c-w>j')
keyset('i', '<c-k>', '<c-\\><c-N><c-w>k')
keyset('i', '<c-l>', '<c-\\><c-N><c-w>l')
keyset('n', '<c-h>', '<c-\\><c-N><c-w>h')
keyset('n', '<c-j>', '<c-\\><c-N><c-w>j')
keyset('n', '<c-k>', '<c-\\><c-N><c-w>k')
keyset('n', '<c-l>', '<c-\\><c-N><c-w>l')
keyset('n', 'sh', '<c-w>h')
keyset('n', 'sl', '<c-w>l')
keyset('n', 'sj', '<c-w>j')
keyset('n', 'sk', '<c-w>k')
-- resize terminals
keyset('t', '<c-up>', '<c-\\><c-N><Cmd>res +2|startinsert<CR>')
keyset('t', '<c-down>', '<c-\\><c-N><Cmd>res -2|startinsert<CR>')
keyset('t', '<c-left>', '<c-\\><c-N><Cmd>vertical resize-2|startinsert<CR>')
keyset('t', '<c-right>', '<c-\\><c-N><Cmd>vertical resize+2|startinsert<CR>')
-- destroy terminals
keyset('t', '<c-q>', '<c-\\><c-N><Cmd>exit<CR>')

keyset('n', 'gug', '<Cmd>s/\\v<(.)(\\w*)/\\u\\1\\L\\2/g | nohlsearch<CR>',
    { desc = [[To Turn One Line Into Title Caps, Make Every First Letter Of A Word Uppercase]] })
keyset('n', '<LEADER><F5>', '<Cmd>w! | !compiler "%"<CR>',
    { desc = [[Compile document, be it groff/LaTeX/markdown/etc.]] })
keyset('n', 'go', '<Cmd>silent!!opout "%"<CR>',
    { desc = [[Open corresponding .pdf/.html or preview]] })
keyset('v', '.', ':normal .<CR>',
    { desc = [[Perform dot commands over visual blocks]] })
keyset('v', 'p', 'P',
    { desc = [[keep what I am pasting]] })
-- keyset('i', '<c-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u',
--     { desc = [[Spell checking on the fly]] })
keyset('n', '<SPACE><SPACE>', '/<<>><CR>:set nohlsearch<CR>"_c4<right>')
keyset('i', 'jk', '<Esc>/<<>><CR>:set nohlsearch<CR>"_c4<right>')
keyset('i', 'jj', '<right>')
keyset('i', 'kk', '<left>')
keyset('c', '%%', "getcmdtype()==':'? expand('%:h').'/' : '%%'",
    { expr = true, desc = [[展开活动缓冲区所在目录]] })
keyset('n', 'd<space>', "<Cmd>let pos=getcurpos()[1:] | %s/\\s\\+$//e | nohlsearch | call cursor(pos)<CR>",
    { desc = [[Remove trailing spaces]] })

-- local toggle_boolean = function()
--     local cword = vim.fn.expand("<cword>")
--     local boolean_map = {
--         ["true"] = "false", -- lua, ...
--         ["false"] = "true", -- lua, ...
--         ["True"] = "False",   -- Python
--         ["False"] = "True",   -- Python
--         ["TRUE"] = "FALSE",   -- R
--         ["FALS"] = "TRUE",   -- R
--         ["T"] = "F",          -- R
--         ["F"] = "T",          -- R
--     }
--
--     local val = boolean_map[cword]
--     if val then
--         vim.cmd('normal! ciw' .. val)
--     else
--         print("Error: toggle_boolean got unknown key " .. cword)
--     end
-- end
-- keyset('n', '<leader>t', toggle_boolean)
