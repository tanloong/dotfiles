#!/usr/bin/env lua

local keyset = vim.keymap.set

keyset({ 'n', 'v', 'o' }, 'K', '5gk')
keyset({ 'n', 'v', 'o' }, 'J', '5gj')
keyset({ 'n', 'v', 'o' }, 'H', '5h')
keyset({ 'n', 'v', 'o' }, 'L', '5l')
keyset({ 'n', 'v', 'o' }, 'Q', '@q')
keyset({ 'n', 'v', 'o' }, '9', '$')
keyset('n', 'g9', 'g$')
-- overridden by bufferline mappings
-- keyset('n', 'gh', 'gT')
-- keyset('n', 'gl', 'gt')
keyset({ 'n', 'v' }, 'k', 'gk')
keyset({ 'n', 'v' }, 'j', 'gj')
keyset({ 'n', 'v' }, 'gk', 'k')
keyset({ 'n', 'v' }, 'gj', 'j')
keyset('n', 'S', ':!')
keyset('n', 'sS', ':%!')
keyset('n', 'M', 'J')
keyset('n', 'ga', '<Cmd>tabnew<CR><Cmd>term lazygit<CR>i')
-- keyset('n', 'ga', '<Cmd>tabe<CR><Cmd>term gitui<CR>i')
keyset('n', 'gf', 'gF')
keyset('n', '>', '>>')
keyset('n', '<', '<<')
keyset('n', '<c-p>', ':%s///g<Left><Left>')
keyset('v', '<c-p>', ':s///g<Left><Left>')
keyset('n', '<c-q>', '<Cmd>q!<CR>')
keyset('n', '<c-s>', '<Cmd>w<CR>')
keyset('n', 'ZW', '<Cmd>bd<CR>')
keyset('n', '<SPACE>e', '<Cmd>set spell!<bar>set spell?<CR>')
keyset('n', 'g<CR>', '<Cmd>set hlsearch!<bar>set hlsearch?<CR>')
keyset('n', '<F4>', '<Cmd>q!<CR>')
keyset('n', 's', '<nop>')
keyset('n', 'sv', '<Cmd>vsplit<CR>')
keyset('n', 'ss', '<Cmd>split<CR>')
keyset('n', 's/', ':vimgrep //gf %<s-left><s-left><right>')
keyset('n', ']q', '<Cmd>cnext<CR>')
keyset('n', '[q', '<Cmd>cprevious<CR>')
keyset('n', '<c-up>', '<Cmd>res +2<CR>')
keyset('n', '<c-down>', '<Cmd>res -2<CR>')
keyset('n', '<c-left>', '<Cmd>vertical resize-2<CR>')
keyset('n', '<c-right>', '<Cmd>vertical resize+2<CR>')
keyset('n', 'te', '<Cmd>tabedit<CR>')
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
-- keyset('n', '<enter>', 'i<enter><esc>')
keyset('n', '<leader>S', [[<cmd>exec "silent!! zeal " .. expand("<cword>") .. " &"<cr>]])
keyset('v', '<leader>S', [[:<c-u>exec "silent!! zeal " .. DT#get_visual_selection() .. " &"<cr>]])
keyset('n', '<leader>K', [[<cmd>exec "silent!! goldendict " .. expand("<cword>") .. " &"<cr>]])
keyset('v', '<leader>K', [[:<c-u>exec "silent!! goldendict " .. DT#get_visual_selection() .. " &"<cr>]])
keyset('n', '<leader>b', [[<cmd>ls<cr>:b<space>]])
keyset('n', '<leader>e', [[<cmd>exec empty(filter(getwininfo(), 'v:val.quickfix')) ? 'copen' : 'cclose'<cr>]])
keyset('n', 'Y', function() vim.fn.setreg('+', vim.trim(vim.api.nvim_get_current_line())) end)
keyset('n', 'zl', "1z=")

-- jumping between a normal buffer and a neovim terminal
keyset('t', '<esc><esc>', '<c-\\><c-n>')
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
keyset('c', '%%', "getcmdtype()==':'? expand('%:h').'/' : '%%'",
    { expr = true, desc = [[展开活动缓冲区所在目录]] })
keyset('n', 'd<space>', "<Cmd>let pos=getcurpos()[1:] | keeppatterns %s/\\s\\+$//e | nohlsearch | call cursor(pos)<CR>",
    { desc = [[Remove trailing spaces]] })

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- autocmd("FileType",
--     {
--         pattern = "netrw",
--         group = augroup("netrw_mapping", { clear = true }),
--         callback = function()
--             keyset("n", "H", [[u]], { buffer = true })
--             keyset("n", "h", [[-]], { buffer = true })
--             keyset("n", "l", [[<CR>]], { buffer = true })
--             keyset("n", "L", [[<CR><Cmd>Lexplorer<CR>]], { buffer = true })
--             keyset("n", "zh", [[gh]], { buffer = true })
--         end,
--     })
