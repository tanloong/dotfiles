#!/usr/bin/env lua

local keyset = vim.keymap.set
local hl = vim.api.nvim_set_hl

keyset({ "n", "v", "o" }, "K", "5gk")
keyset({ "n", "v", "o" }, "J", "5gj")
keyset({ "n", "v", "o" }, "H", "5h")
keyset({ "n", "v", "o" }, "L", "5l")
keyset({ "n", "v", "o" }, "Q", "@q")
keyset({ "n", "v", "o" }, "9", "$")
keyset("n", "g9", "g$")
keyset("n", "gp", "<cmd>.copy .<cr>", { desc = "copy current line below" })
keyset("n", "gP", "<cmd>.copy -<cr>", { desc = "copy current line above" })
-- overridden by bufferline mappings
-- keyset('n', 'gh', 'gT')
-- keyset('n', 'gl', 'gt')
keyset({ "n", "v" }, "k", "gk")
keyset({ "n", "v" }, "j", "gj")
keyset({ "n", "v" }, "gk", "k")
keyset({ "n", "v" }, "gj", "j")
keyset("n", "S", ":!")
keyset("n", "sS", ":%!")
keyset({ "n", "v" }, "M", "J")
keyset("n", "ga", "<Cmd>tabnew<CR><Cmd>term lazygit<CR>i")
keyset("n", "gA", "<Cmd>tabnew<CR><Cmd>term gitui<CR>i")
-- keyset('n', 'ga', '<Cmd>tabe<CR><Cmd>term gitui<CR>i')
keyset("n", "gf", "gF")
keyset("n", ">", ">>")
keyset("n", "<", "<<")
keyset("n", "<c-p>", ":%s///g<Left><Left>")
keyset("v", "<c-p>", ":s///g<Left><Left>")
keyset("n", "<c-q>", "<Cmd>q!<CR>")
keyset("n", "<c-s>", "<Cmd>w<CR>")
keyset("n", "ZW", "<Cmd>bd<CR>")
keyset("n", "<SPACE>e", "<Cmd>set spell!<bar>set spell?<CR>")
keyset("n", "g<CR>", "<Cmd>set hlsearch!<bar>set hlsearch?<CR>")
-- keyset('n', '<F4>', '<Cmd>q!<CR>')
keyset("n", "s", "<nop>")
keyset("n", "sv", "<Cmd>vsplit<CR>")
keyset("n", "ss", "<Cmd>split<CR>")
keyset("n", "s/", ":vimgrep //gf %<s-left><s-left><right>")
keyset("n", "<c-up>", "<Cmd>res +2<CR>")
keyset("n", "<c-down>", "<Cmd>res -2<CR>")
keyset("n", "<c-left>", "<Cmd>vertical resize-2<CR>")
keyset("n", "<c-right>", "<Cmd>vertical resize+2<CR>")
keyset("n", "te", "<Cmd>tabedit<CR>")
keyset("n", "/", "/\\v")
keyset("v", "/", "/\\v")
keyset("n", "?", "?\\v")
keyset("v", "?", "?\\v")
-- keyset('n', '<enter>', 'i<enter><esc>')
keyset("n", "<leader>S", [[<cmd>exec "silent!! zeal " .. expand("<cword>") .. " &"<cr>]])
keyset("v", "<leader>S",
  [[:<c-u>exec "silent!! zeal " .. getregion(getpos("'<"), getpos("'>"), {"type": "v"})[0] .. " &"<cr>]])
keyset("n", "<leader>K", [[<cmd>exec "silent!! goldendict " .. expand("<cword>") .. " &"<cr>]])
keyset("v", "<leader>K",
  [[:<c-u>exec "silent!! goldendict " .. getregion(getpos("'<"), getpos("'>"), {"type": "v"})[0] .. " &"<cr>]])
-- keyset('n', '<tab>', [[<cmd>exec "silent!! goldendict " .. expand("<cword>") .. " &"<cr>]])
-- keyset('v', '<tab>', [[:<c-u>exec "silent!! goldendict " .. DT#get_visual_selection() .. " &"<cr>]])
keyset("n", "<leader>b", [[<cmd>ls<cr>:b<space>]])
keyset("n", "<leader>e", [[<cmd>exec empty(filter(getwininfo(), 'v:val.quickfix')) ? 'copen' : 'cclose'<cr>]])
keyset("n", "zl", "1z=")
keyset("i", "<c-q>", "<c-k>")

-- NAVIGATION
-- jumping between a normal buffer and a neovim terminal
keyset("t", "<esc><esc>", "<c-\\><c-n>")
keyset("t", "<c-h>", "<c-\\><c-N><c-w>h")
keyset("t", "<c-j>", "<c-\\><c-N><c-w>j")
keyset("t", "<c-k>", "<c-\\><c-N><c-w>k")
keyset("t", "<c-l>", "<c-\\><c-N><c-w>l")
-- keyset('t', 'sh', '<c-\\><c-N><c-w>h')
-- keyset('t', 'sj', '<c-\\><c-N><c-w>j')
-- keyset('t', 'sk', '<c-\\><c-N><c-w>k')
-- keyset('t', 'sl', '<c-\\><c-N><c-w>l')
keyset("i", "<c-h>", "<c-\\><c-N><c-w>h")
keyset("i", "<c-j>", "<c-\\><c-N><c-w>j")
keyset("i", "<c-k>", "<c-\\><c-N><c-w>k")
keyset("i", "<c-l>", "<c-\\><c-N><c-w>l")
keyset("n", "<c-h>", "<c-\\><c-N><c-w>h")
keyset("n", "<c-j>", "<c-\\><c-N><c-w>j")
keyset("n", "<c-k>", "<c-\\><c-N><c-w>k")
keyset("n", "<c-l>", "<c-\\><c-N><c-w>l")
-- keyset('n', 'sh', '<c-w>h')
-- keyset('n', 'sl', '<c-w>l')
-- keyset('n', 'sj', '<c-w>j')
-- keyset('n', 'sk', '<c-w>k')

-- resize terminals
keyset("t", "<c-up>", "<c-\\><c-N><Cmd>res +2|startinsert<CR>")
keyset("t", "<c-down>", "<c-\\><c-N><Cmd>res -2|startinsert<CR>")
keyset("t", "<c-left>", "<c-\\><c-N><Cmd>vertical resize-2|startinsert<CR>")
keyset("t", "<c-right>", "<c-\\><c-N><Cmd>vertical resize+2|startinsert<CR>")
-- destroy terminals
keyset("t", "<c-q>", "<c-\\><c-N><Cmd>exit<CR>")

keyset("n", "gug", "<Cmd>s/\\v<(.)(\\w*)/\\u\\1\\L\\2/g | nohlsearch<CR>",
  { desc = [[To Turn One Line Into Title Caps, Make Every First Letter Of A Word Uppercase]] })
keyset("n", "<LEADER><F5>", '<Cmd>w! | !compiler "%"<CR>',
  { desc = [[Compile document, be it groff/LaTeX/markdown/etc.]] })
keyset("n", "go", '<Cmd>silent!!opout "%"<CR>', { desc = [[Open corresponding .pdf/.html or preview]] })
keyset("v", ".", ":normal .<CR>", { desc = [[Perform dot commands over visual blocks]] })
keyset("v", "p", "P", { desc = [[keep what I am pasting]] })
keyset({ "n", "v" }, "<leader>d", [["_d]])
-- keyset('i', '<c-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u',
--     { desc = [[Spell checking on the fly]] })
keyset("c", "%%", "getcmdtype()==':'? expand('%:h').'/' : '%%'",
  { expr = true, desc = [[展开活动缓冲区所在目录]] })
keyset("n", "d<space>", [[<cmd>let _p=getcurpos() | keeppatterns %s/\v\s+$//e | nohlsearch | call setpos(".", _p)<cr>]],
  { desc = [[Remove trailing spaces]] })
keyset("n", "d<enter>", [[<cmd>let _p=getcurpos() | keeppatterns %s/\v\n{3,}/\r\r/e | nohlsearch | call setpos(".", _p)<cr>]],
  { desc = "squeeze empty lines" })

-- TEXT OBJECTS
-- "in line" (entire line sans white-space; cursor at beginning--ie, ^)
keyset({ "x", "o" }, "il", ":<c-u>normal! g_v^<cr>", { silent = true })
-- "around line" (entire line sans trailing newline; cursor at beginning--ie, 0)
keyset({ "x", "o" }, "al", ":<c-u>normal! $v0<cr>", { silent = true })
-- "in document" (from first line to last; cursor at top--ie, gg)
keyset({ "x", "o" }, "ib", ":<c-u>normal! GVgg<cr>", { silent = true })
-- "in indentation" (indentation level sans any surrounding empty lines)
keyset({ "x", "o" }, "ii", "<cmd>call textobject#inIndentation()<cr>", { silent = true })
-- "around indentation" (indentation level and any surrounding empty lines)
keyset({ "x", "o" }, "ai", "<cmd>call textobject#aroundIndentation()<cr>", { silent = true })
-- "in _"
keyset({ "x", "o" }, "i_", ":<c-u>normal! T_vt_<cr>", { silent = true })

-- SQUARE BRACKETS
keyset("n", "]q", "<Cmd>cnext<CR>")
keyset("n", "[q", "<Cmd>cprevious<CR>")
keyset("n", "[<space>", [[<cmd>put!=nr2char(10)|']+<cr>]])
keyset("n", "]<space>", [[<cmd>put =nr2char(10)|'[-<cr>]])
keyset("n", "[e", [[<cmd>.move--<cr>]])
keyset("n", "]e", [[<cmd>.move+<cr>]])
keyset("x", "[e", [[:<c-u>'<,'>move'<--<cr>gv]])
keyset("x", "]e", [[:<c-u>'<,'>move'>+<cr>gv]])

-- convert unicode_escape to unicode
-- select '\u21bb' and type '<leader>c'
keyset("v", "<leader>c",
  [[:<c-u>'<,'>!python -c "import sys; print(sys.stdin.read().encode().decode('unicode_escape'), end='')"<cr>]])

keyset("n", "+",
  [[<cmd>let _p = getcurpos() | put =eval(getline(_p[1])) | call setpos(".", _p)<cr>]],
  { desc = [[run Vim expressions, insert output below]] })
keyset("v", "+",
  [[:<c-u>let _p = getcurpos() | put =<c-r>=escape(getregion(getpos("'<"), getpos("'>"), {"type": "v"})[0], '"|')<cr> | call setpos(".", _p)<cr>]],
  { desc = [[run Vim expressions, insert output below]] })

keyset("i", "<c-g><c-g>",
  [[<esc><cmd>silent let _p = getcurpos() | put ='' | exec "r!" .. escape(getline(_p[1]), "%!#") | if getline(line(".")+1) != '' | put ='' | endif | call setpos(".", _p) | redraw<cr>]],
  { desc = [[execute current line as shell command]] })
keyset("n", "<c-g><c-g>",
  [[<cmd>silent let _p = getcurpos() | put ='' | exec "r!" .. escape(getline(_p[1]), "%!#") | if getline(line(".")+1) != '' | put ='' | endif | call setpos(".", _p) | redraw<cr>]],
  { desc = [[execute current line as shell command]] })
keyset("v", "<c-g><c-g>",
  [[:<c-u>silent let _p = getcurpos() | put ='' | exec "r!" .. escape(getregion(getpos("'<"), getpos("'>"), {"type": "v"})[0], "%!#") | if getline(line(".")+1) != '' | put ='' | endif | call setpos(".", _p) | redraw<cr>]],
  { desc = [[execute current line as shell command]] })
keyset("n", "dlp", [[<cmd>let _p=getcurpos() | exec "normal! }dap" | call setpos(".", _p)<cr>]], { silent = true })
keyset("n", "dhp", [[<cmd>let _p=getcurpos() | exec "normal! {{dap" | call setpos(".", _p)<cr>]], { silent = true })

-- local autocmd = vim.api.nvim_create_autocmd
-- local augroup = vim.api.nvim_create_augroup

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

hl(0, "MarkLine", { bg = "darkred", fg = "gray", ctermbg = 9, ctermfg = 15 })
local function markline()
  vim.api.nvim_buf_add_highlight(vim.fn.bufnr("%"), 0, "MarkLine", (vim.fn.line(".") - 1), 0, -1)
end
keyset("n", "m.", markline)
keyset("n", "m<bs>", function() vim.api.nvim_buf_clear_namespace(vim.fn.bufnr("%"), 0, 0, -1) end)
