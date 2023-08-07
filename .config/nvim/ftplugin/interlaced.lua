#!/usr/bin/env lua
local keyset = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local setline = vim.fn.setline
local getline = vim.fn.getline

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

local function CopyToThreeLinesAbove(lineno)
    --[[ 用行所在pair的中文或英文行覆盖上一个pair对应中文或英文行 ]]
    local lineno_minus3 = lineno - 3
    local line = getline(lineno)
    local line_minus3 = getline(lineno_minus3)

    setline(lineno_minus3, line)
end

local function MergeLines()
    local lineno = vim.fn.line(".")
    if lineno <= 3 then return end
    local last_lineno = vim.fn.line("$")

    AppendToThreeLinesAbove(lineno)
    lineno = lineno + 3
    while lineno <= last_lineno do
        CopyToThreeLinesAbove(lineno)
        lineno = lineno + 3
    end
    setline(lineno - 3, '')

    local buf = vim.api.nvim_get_current_buf()
    while string.match(getline(last_lineno), "^%s*$") do
        vim.fn.deletebufline(buf, last_lineno)
        last_lineno = last_lineno - 1
    end
end

local function map_intern()
    local mappings = {
        { mode = 'n', from = ',', to = MergeLines },
        { mode = 'n', from = 'K', to = '3kzz' },
        { mode = 'n', from = 'J', to = '3jzz' }
    }
    for _, mapping in ipairs(mappings) do
        keyset(mapping.mode, mapping.from, mapping.to, { buffer = true, nowait = true })
    end
end

map_intern()
