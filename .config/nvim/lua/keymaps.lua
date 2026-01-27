#!/usr/bin/env lua

local map = vim.keymap.set
local api = vim.api
local hi = vim.api.nvim_set_hl

map({ "n", "v", "o" }, "K", "5gk")
map({ "n", "v", "o" }, "J", "5gj")
-- map({ "n", "v", "o" }, "H", "5h")
-- map({ "n", "v", "o" }, "L", "5l")
map({ "n", "v", "o" }, "Q", "@q")
map({ "n", "v", "o" }, "9", "$")
map("n", "g9", "g$")
map("n", "gp", "<cmd>.copy .<cr>", { desc = "copy current line to below" })
map("n", "gP", "<cmd>.copy -<cr>", { desc = "copy current line to above" })
-- comment current line, copy below, uncomment copied line
map("n", "gcp",
  "<cmd>let _p=getcurpos() | let _p[1]+=1<cr><cmd>normal gcc<cr><cmd>.copy . | normal gcc<cr><cmd>call setpos('.', _p)<cr>",
  { desc = "copy current line to above" })
map("n", "gcP",
  "<cmd>let _p=getcurpos()<cr><cmd>normal gcc<cr><cmd>.copy - | normal gcc<cr><cmd>call setpos('.', _p)<cr>",
  { desc = "copy current line to above" })
map({ "n", "v" }, "k", "gk")
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "gk", "k")
map({ "n", "v" }, "gj", "j")
map("n", "S", ":!")
map("n", "sS", ":%!")
map("n", ">", ">>")
map("n", "<", "<<")
map({ "n", "v" }, "M", "J")
map("n", "ga", "<Cmd>tabnew | term lazygit<CR>i")
map("n", "gA", "<Cmd>tabnew | term gitui<CR>i")
-- keyset('n', 'ga', '<Cmd>tabe<CR><Cmd>term gitui<CR>i')
map("n", "gf", "gF")
map("n", "<c-p>", ":%s///g<Left><Left>")
map("v", "<c-p>", ":s///g<Left><Left>")
map("n", "<c-q>", "<Cmd>q!<CR>")
map("n", "<c-s>", "<Cmd>w<CR>")
map("n", "<SPACE>e", "<Cmd>set spell!<bar>set spell?<CR>")
map("n", "g<CR>", "<Cmd>set hlsearch!<bar>set hlsearch?<CR>")
map("n", "s", "<nop>")
map("n", "sv", "<Cmd>vsplit<CR>")
map("n", "ss", "<Cmd>split<CR>")
map("n", "s/", ":vimgrep //gf %<s-left><s-left><right>")
map("n", "<c-up>", "<Cmd>res +2<CR>")
map("n", "<c-down>", "<Cmd>res -2<CR>")
map("n", "<c-left>", "<Cmd>vertical resize-2<CR>")
map("n", "<c-right>", "<Cmd>vertical resize+2<CR>")
-- map("n", "te", "<Cmd>tabedit<CR>")
map("n", "/", "/\\v")
map("v", "/", "/\\v")
map("n", "?", "?\\v")
map("v", "?", "?\\v")
-- keyset('n', '<enter>', 'i<enter><esc>')
map("n", "gZ", [[<cmd>exec "silent!! zeal " .. expand("<cword>") .. " &"<cr>]])
map("v", "gZ",
  [[:<c-u>exec "silent!! zeal " .. getregion(getpos("'<"), getpos("'>"), {"type": "v"})[0] .. " &"<cr>]])
map("n", "gK", [[<cmd>exec "silent!! goldendict " .. expand("<cword>") .. " &"<cr>]])
map("v", "gK",
  [[:<c-u>exec "silent!! goldendict " .. getregion(getpos("'<"), getpos("'>"), {"type": "v"})[0] .. " &"<cr>]])
-- keyset('n', '<tab>', [[<cmd>exec "silent!! goldendict " .. expand("<cword>") .. " &"<cr>]])
-- keyset('v', '<tab>', [[:<c-u>exec "silent!! goldendict " .. DT#get_visual_selection() .. " &"<cr>]])
map("n", "<space>r", "<cmd>call DT#RunFile()<CR>", { silent = true })
map("n", "<leader>b", [[<cmd>ls<cr>:b<space>]])
-- Toggle quickfix window
map("n", "<leader>e", [[<cmd>exec empty(filter(getwininfo(), 'v:val.quickfix')) ? 'copen' : 'cclose'<cr>]])
-- Correct bad spell word under cursor
map("n", "zl", "1z=")
map("i", "<c-q>", "<c-k>")
-- Insert a newline at cursor without entering insert mode
map("n", "<c-enter>", [[i<nl><esc>]])
-- Visual select the just pasted text by p/P
map("n", "gV", "`[v`]")
map("n", "tt", "<Cmd>Lexplore<CR>")

-- web search
map("n", "gX", function()
  vim.ui.open(("https://bing.com/search?q=%s&form=QBLH"):format(vim.fn.expand "<cword>"))
  -- vim.ui.open(("https://metaso.cn?q=%s"):format(vim.fn.expand "<cword>"))
end)
map("x", "gX", function()
  local lines = vim.fn.getregion(vim.fn.getpos ".", vim.fn.getpos "v", { type = vim.fn.mode() })
  vim.ui.open(("https://bing.com/search?q=%s"):format(vim.trim(table.concat(lines, " "))))
  -- vim.ui.open(("https://metaso.cn?q=%s"):format(vim.trim(table.concat(lines, " "))))
  api.nvim_input "<esc>"
end)

local _search = function(_open)
  local bufnr = api.nvim_create_buf(false, false)
  vim.bo[bufnr].buftype = "prompt"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.fn.prompt_setprompt(bufnr, "")
  api.nvim_buf_set_extmark(bufnr, api.nvim_create_namespace "WebSearch", 0, 0, {
    line_hl_group = "Normal",
  })
  local width = math.floor(vim.o.columns * 0.6)
  local winid = api.nvim_open_win(bufnr, true, {
    relative = "editor",
    row = math.floor(vim.o.lines / 3),
    width = width,
    height = 1,
    col = math.floor(vim.o.columns / 2) - math.floor(width / 2),
    border = "single",
    title = "Search",
    title_pos = "center",
  })
  vim.cmd.startinsert()
  vim.wo[winid].number = false
  vim.wo[winid].scl = "no"
  vim.wo[winid].lcs = "trail: "
  vim.wo[winid].wrap = true
  vim.wo[winid].signcolumn = "no"
  vim.wo[winid].cursorline = false
  vim.fn.prompt_setcallback(bufnr, function(text)
    _open(text)
    -- vim.ui.open(("https://metaso.cn?q=%s"):format(vim.trim(text)))
    api.nvim_win_close(winid, true)
  end)
  map({ "n" }, "<esc>", function()
    pcall(api.nvim_win_close, winid, true)
  end, { buffer = bufnr })
end

map("n", "gs", function()
  _search(function(text) vim.ui.open(("https://cn.bing.com/search?q=%s&form=QBLH"):format(vim.trim(text))) end)
end)

map("n", "gz", function()
  _search(
    function(text) vim.system { "zeal", vim.trim(text) } end
  )
end)

-- keyset("i", "<C-a>", "<Esc>^i")
map("i", "<CR>", function()
  if tonumber(vim.fn.pumvisible()) == 1 then
    return "<C-y>"
  end
  local line = api.nvim_get_current_line()
  local col = api.nvim_win_get_cursor(0)[2]
  local before = line:sub(col, col)
  local after = line:sub(col + 1, col + 1)
  local t = {
    ["("] = ")",
    ["["] = "]",
    ["{"] = "}",
  }
  if t[before] and t[before] == after then
    return "<CR><ESC>O"
  end
  return "<CR>"
end, { expr = true })
map("i", "<c-l>", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local offset = line:sub(col + 1):find "[%]\"'’”)}>`]"
  if offset == nil then
    api.nvim_win_set_cursor(0, { row, #line })
    return
  end
  api.nvim_win_set_cursor(0, { row, col + offset })
end, { desc = "Jump out of brackets, jump to end of line if not found" })

-- keyset("i", "<C-e>", function()
--   if vim.fn.pumvisible() == 1 then
--     return "<C-e>"
--   else
--     return "<End>"
--   end
-- end, { expr = true })

-- NAVIGATION
-- jumping between a normal buffer and a neovim terminal
-- map("t", "<esc><esc>", "<c-\\><c-n>")
map("t", "<c-h>", "<c-\\><c-N><c-w>h")
map("t", "<c-j>", "<c-\\><c-N><c-w>j")
map("t", "<c-k>", "<c-\\><c-N><c-w>k")
map("t", "<c-l>", "<c-\\><c-N><c-w>l")
map("t", "<c-v><c-j>", "<c-j>")
map("t", "<c-v><c-k>", "<c-k>")
-- map("t", "<c-v><c-h>", "<c-h>")
-- map("t", "<c-v><c-l>", "<c-l>")
-- map("t", "<c-w>H", "<c-\\><c-N><c-w>H")
-- map("t", "<c-w>L", "<c-\\><c-N><c-w>L")
-- map("t", "<c-w>J", "<c-\\><c-N><c-w>J")
-- map("t", "<c-w>K", "<c-\\><c-N><c-w>K")
map("t", "<c-^>", "<c-\\><c-N><c-^>")

map({ "n" }, "<c-h>", "<c-\\><c-N><c-w>h")
map({ "n" }, "<c-j>", "<c-\\><c-N><c-w>j")
map({ "n" }, "<c-k>", "<c-\\><c-N><c-w>k")
map({ "n" }, "<c-l>", "<c-\\><c-N><c-w>l")

-- Resize terminals
map("t", "<c-up>", "<c-\\><c-N><Cmd>res +2|startinsert<CR>")
map("t", "<c-down>", "<c-\\><c-N><Cmd>res -2|startinsert<CR>")
map("t", "<c-left>", "<c-\\><c-N><Cmd>vertical resize-2|startinsert<CR>")
map("t", "<c-right>", "<c-\\><c-N><Cmd>vertical resize+2|startinsert<CR>")
-- Destroy terminals
map("t", "<c-q>", "<c-\\><c-N><Cmd>exit<CR>")

map("n", "gug", "<Cmd>keeppatterns s/\\v<(.)(\\w*)/\\u\\1\\L\\2/g<CR>",
  { desc = [[To Turn One Line Into Title Caps, Make Every First Letter Of A Word Uppercase]] })
map("n", "<LEADER><F5>", '<Cmd>w! | !compiler "%"<CR>',
  { desc = [[Compile document, be it groff/LaTeX/markdown/etc.]] })
map("v", "p", "P", { desc = [[keep what I am pasting, don't pollute my register]] })
map({ "n", "v" }, "<leader>d", [["_d]])
-- keyset('i', '<c-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u',
--     { desc = [[Spell checking on the fly]] })
map("c", "%%", "getcmdtype()==':'? expand('%:h').'/' : '%%'",
  { expr = true, desc = [[展开活动缓冲区所在目录]] })
map("n", "d<space>", [[<cmd>let _p=getcurpos() | keeppatterns %s/\v\s+$//e | nohlsearch | call setpos(".", _p)<cr>]],
  { desc = [[Remove trailing spaces]] })
map("n", "d<enter>",
  [[<cmd>let _p=getcurpos() | keeppatterns %s/\v\n{3,}/\r\r/e | call setpos(".", _p)<cr>]],
  { desc = "squeeze empty lines" })

-- TEXT OBJECTS
-- "in line" (entire line sans white-space; cursor at beginning--ie, ^)
map({ "x", "o" }, "il", ":<c-u>normal! g_v^<cr>", { silent = true })
-- "around line" (entire line sans trailing newline; cursor at beginning--ie, 0)
map({ "x", "o" }, "al", ":<c-u>normal! $v0<cr>", { silent = true })
-- "in document" (from first line to last; cursor at top--ie, gg)
map({ "x", "o" }, "ib", ":<c-u>normal! GVgg<cr>", { silent = true })
-- "in indentation" (indentation level sans any surrounding empty lines)
map({ "x", "o" }, "ii", "<cmd>call textobject#inIndentation()<cr>", { silent = true })
-- "around indentation" (indentation level and any surrounding empty lines)
map({ "x", "o" }, "ai", "<cmd>call textobject#aroundIndentation()<cr>", { silent = true })
-- "in _"
map({ "x", "o" }, "i_", ":<c-u>normal! T_vt_<cr>", { silent = true })

-- SQUARE BRACKETS
-- map("n", "]q", "<Cmd>cnext<CR>")
-- map("n", "[q", "<Cmd>cprevious<CR>")
map("n", "[x", [[<cmd>.move--<cr>]])
map("n", "]x", [[<cmd>.move+<cr>]])
map("x", "[x", [[:<c-u>'<,'>move'<--<cr>gv]])
map("x", "]x", [[:<c-u>'<,'>move'>+<cr>gv]])

-- convert unicode_escape to unicode
-- select '\u21bb' and type '<leader>c'
map("v", "<leader>c",
  [[:<c-u>'<,'>!python -c "import sys; print(sys.stdin.read().encode().decode('unicode_escape'), end='')"<cr>]])

map("n", "+",
  [[<cmd>let _p = getcurpos() | put =eval(getline(_p[1])) | call setpos(".", _p) | redraw<cr>]],
  { desc = [[run Vim expressions, insert output below]] })
map("v", "+",
  [[:<c-u>let _p = getcurpos() | put =<c-r>=escape(getregion(getpos("'<"), getpos("'>"), {"type": "v"})[0], '"|')<cr> | call setpos(".", _p) | redraw<cr>]],
  { desc = [[run Vim expressions, insert output below]] })

map("i", "<c-g><c-g>",
  [[<esc><cmd>silent let _p = getcurpos() | put ='' | exec "r!" .. escape(getline(_p[1]), "%!#") | if getline(line(".")+1) != '' | put ='' | else | let _b = nvim_get_current_buf() | while line(".")+2 <= line("$") && getline(line(".")+2) == '' | call deletebufline(_b, line(".")+2) | endwhile | endif | call setpos(".", _p) | redraw<cr>]],
  { desc = [[execute current line as shell command]] })
map("n", "<c-g><c-g>",
  [[<cmd>silent let _p = getcurpos() | put ='' | exec "r!" .. escape(getline(_p[1]), "%!#") | if getline(line(".")+1) != '' | put ='' | else | let _b = nvim_get_current_buf() | while line(".")+2 <= line("$") && getline(line(".")+2) == '' | call deletebufline(_b, line(".")+2) | endwhile | endif | call setpos(".", _p) | redraw<cr>]],
  { desc = [[execute current line as shell command]] })
map("v", "<c-g><c-g>",
  [[:<c-u>silent let _p = getcurpos() | put ='' | exec "r!" .. escape(getregion(getpos("'<"), getpos("'>"), {"type": "v"})[0], "%!#") | if getline(line(".")+1) != '' | put ='' | else | let _b = nvim_get_current_buf() | while line(".")+2 <= line("$") && getline(line(".")+2) == '' | call deletebufline(_b, line(".")+2) | endwhile | endif | call setpos(".", _p) | redraw<cr>]],
  { desc = [[execute current line as shell command]] })

-- %!# is special chars in fish
-- map("n", "dp", [[<cmd>let _p=getcurpos() | exec "normal! }dap" | call setpos(".", _p)<cr>]], { silent = true })
-- map("n", "dP", [[<cmd>let _p=getcurpos() | exec "normal! {{dap" | call setpos(".", _p)<cr>]], { silent = true })

hi(0, "MarkLine", { bg = "darkred", fg = "gray", ctermbg = 9, ctermfg = 15 })
local function markline()
  api.nvim_buf_add_highlight(vim.fn.bufnr "%", 0, "MarkLine", (vim.fn.line "." - 1), 0, -1)
end
map("n", "m.", markline)
map("n", "m<bs>", function() api.nvim_buf_clear_namespace(vim.fn.bufnr "%", 0, 0, -1) end)

----------------------------------- COMMENT ------------------------------------
---This func is copied from neovim/runtime/lua/vim/_comment.lua
local function get_commentstring(ref_position)
  local buf_cs = vim.bo.commentstring
  local ts_parser = vim.treesitter.get_parser(0, "", { error = false })
  if not ts_parser then return buf_cs end
  local row, col = ref_position[1] - 1, ref_position[2]
  local ref_range = { row, col, row, col + 1 }
  local ts_cs, res_level = nil, 0
  local function traverse(lang_tree, level)
    if not lang_tree:contains(ref_range) then return end
    local lang = lang_tree:lang()
    local filetypes = vim.treesitter.language.get_filetypes(lang)
    for _, ft in ipairs(filetypes) do
      local cur_cs = vim.filetype.get_option(ft, "commentstring")
      if cur_cs ~= "" and level > res_level then ts_cs = cur_cs end
    end
    for _, child_lang_tree in pairs(lang_tree:children()) do traverse(child_lang_tree, level + 1) end
  end
  traverse(ts_parser, 1)
  return ts_cs or buf_cs
end
---@param line string
---@param cs string
---@return boolean
local comment_check = function(line, cs)
  -- Structure of 'commentstring': <left part> <%s> <right part>
  local left, right = cs:match "^(.-)%%s(.-)$"
  local l_esc, r_esc = vim.pesc(left), vim.pesc(right)
  -- Commented line has the following structure:
  -- <whitespace> <trimmed left> <anything> <trimmed right> <whitespace>
  local regex = "^%s-" .. vim.trim(l_esc) .. ".*" .. vim.trim(r_esc) .. "%s-$"
  return line:find(regex) ~= nil
end
local function comment_end()
  local line = api.nvim_get_current_line()
  local row = api.nvim_win_get_cursor(0)[1]
  local commentstring = get_commentstring { row, 0 }
  local comment = commentstring:gsub("%%s", "")
  local index = commentstring:find "%%s"
  if line:find "%S" then
    comment = " " .. comment
    index = index + 1
  end
  api.nvim_buf_set_lines(0, row - 1, row, false, { line .. comment })
  api.nvim_win_set_cursor(0, { row, #line + index - 2 })
  api.nvim_feedkeys("a", "n", false)
end
---如果光标行是注释或光标行是第一行或上一行是空行，使用光标行的缩进
---如果光标行不是注释且上一行非空，使用下一行的缩进
local function comment_above()
  local row = api.nvim_win_get_cursor(0)[1]
  local line_cursor = api.nvim_buf_get_lines(0, row - 1, row, false)[1]
  local line_above = api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1]
  local line
  local commentstring = get_commentstring { row, 0 }
  local is_comment = comment_check(line_cursor, commentstring)
  if is_comment or line_above == nil or #line_above == 0 then
    line = line_cursor
  else
    line = line_above
  end
  local comment = commentstring:gsub("%%s", "")
  local index = commentstring:find "%%s"
  local blank_chars = (line:find "%S" or #line + 1) - 1
  local blank = line:sub(1, blank_chars)
  api.nvim_buf_set_lines(0, row - 1, row - 1, true, { blank .. comment })
  api.nvim_win_set_cursor(0, { row, #blank + index - 2 })
  api.nvim_feedkeys("a", "n", false)
end
---如果光标行是注释或光标行是最后一行或下一行是空行，使用光标行的缩进
---如果光标行不是注释且下一行非空，使用下一行的缩进
local function comment_below()
  local row = api.nvim_win_get_cursor(0)[1]
  local line_cursor = api.nvim_buf_get_lines(0, row - 1, row, false)[1]
  local line_below = api.nvim_buf_get_lines(0, row, row + 1, false)[1]
  local line
  local commentstring = get_commentstring { row, 0 }
  local is_comment = comment_check(line_cursor, commentstring)
  if is_comment or line_below == nil or #line_below == 0 then
    line = line_cursor
  else
    line = line_below
  end
  local comment = commentstring:gsub("%%s", "")
  local index = commentstring:find "%%s"
  local blank_chars = (line:find "%S" or #line + 1) - 1
  local blank = line:sub(1, blank_chars)
  api.nvim_buf_set_lines(0, row, row, true, { blank .. comment })
  api.nvim_win_set_cursor(0, { row + 1, #blank + index - 2 })
  api.nvim_feedkeys("a", "n", false)
end
map("n", "gcA", comment_end)
map("n", "gcO", comment_above)
map("n", "gco", comment_below)

--- Map |gx| to call |vim.ui.open| on the <cfile> at cursor.
local function do_open(uri)
  local cmd, err = vim.ui.open(uri)
  local rv = cmd and cmd:wait(1000) or nil
  if cmd and rv and rv.code ~= 0 and rv.code ~= 124 then
    err = ("vim.ui.open: command failed (%d): %s"):format(rv.code, vim.inspect(cmd.cmd))
  end
  return err
end
local gx_desc =
"Opens filepath or URI under cursor with the system handler (file explorer, web browser, …)"
vim.keymap.set({ "n" }, "gx", function()
  for _, url in ipairs(require "vim.ui"._get_urls()) do
    local err = do_open(url)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end, { desc = gx_desc })
vim.keymap.set({ "x" }, "gx", function()
  local lines =
      vim.fn.getregion(vim.fn.getpos ".", vim.fn.getpos "v", { type = vim.fn.mode() })
  -- Trim whitespace on each line and concatenate.
  local err = do_open(table.concat(vim.iter(lines):map(vim.trim):totable()))
  if err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = gx_desc })

map("n", "gcb", "<Cmd>e ++enc=gbk<CR>")
map("n", "gcu", "<Cmd>e ++enc=utf-8<CR>")
