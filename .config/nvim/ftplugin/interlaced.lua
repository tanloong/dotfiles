#!/usr/bin/env lua
local keyset = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local setline = vim.fn.setline
local getline = vim.fn.getline
local fn = vim.fn

local function AppendToThreeLinesAbove(lineno)
    --[[ 将行所在pair的中文或英文行合并到上一个pair对应中文或英文行的末尾 ]]
    local lineno_minus3 = lineno - 3
    local lineno_minus1 = lineno - 1
    local line = getline(lineno)
    local line_minus3 = getline(lineno_minus3)
    local line_minus1 = getline(lineno_minus1)

    local sep = " "
    if (line_minus1 == "" or line_minus3 == "") then sep = "" end
    setline(lineno_minus3, string.gsub(line_minus3, '%s+$', '') .. sep .. line)
    setline(lineno, '')
end

local function DeleteTrailingEmptyLines()
    local last_lineno = fn.line("$")
    local buf = vim.api.nvim_get_current_buf()
    while string.match(getline(last_lineno), "^%s*$") do
        fn.deletebufline(buf, last_lineno)
        last_lineno = last_lineno - 1
    end
end

local function MoveLineUp()
    local lineno = fn.line(".")
    if lineno <= 3 then return end
    local last_lineno = fn.line("$")

    AppendToThreeLinesAbove(lineno)
    lineno = lineno + 3
    while lineno <= last_lineno do
        setline(lineno - 3, getline(lineno))
        lineno = lineno + 3
    end
    setline(lineno - 3, '')

    DeleteTrailingEmptyLines()
    vim.cmd("w")
end

local function SplitAfterCursor()
    local lineno = fn.line('.')
    local last_lineno = fn.line('$')

    fn.append(last_lineno, { "", "", "" })

    local last_counterpart_lineno = last_lineno
    while (last_counterpart_lineno - lineno) % 3 ~= 0 do
        last_counterpart_lineno = last_counterpart_lineno - 1
    end

    for i = last_counterpart_lineno, lineno + 3, -3 do
        setline(i + 3, getline(i))
    end

    current_line = getline(lineno)
    cursor_col = fn.col('.')
    before_cursor = current_line:sub(1, cursor_col - 1)
    after_cursor = current_line:sub(cursor_col)

    setline(lineno, fn.substitute(before_cursor, [[\s\+$]], "", ""))
    setline(lineno + 3, fn.substitute(after_cursor, [[^\s\+]], "", ""))

    DeleteTrailingEmptyLines()
    vim.cmd("w")
end

local function MoveLineDown()
    vim.cmd([[normal! 0]])
    SplitAfterCursor()
end

local function map_intern()
    local mappings = {
        { mode = 'n', from = ',', to = MoveLineUp },
        { mode = 'n', from = 'd', to = SplitAfterCursor },
        { mode = 'n', from = 'D', to = MoveLineDown },
        { mode = 'n', from = 'K', to = '3k' },
        { mode = 'n', from = 'J', to = '3j' }
    }
    for _, mapping in ipairs(mappings) do
        keyset(mapping.mode, mapping.from, mapping.to, { buffer = true, nowait = true })
    end
end

map_intern()
