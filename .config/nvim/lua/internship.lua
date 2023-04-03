#!/usr/bin/env lua
-- 用于上外实习
-- 2022年9月-12月

local keyset = vim.keymap.set

M = {}
function M.strip(s)
    return string.gsub(s, '%s+$', '')
end

function M.intrn_join()
    -- 将光标所在pair的中文或英文行合并到上一个pair对应中文或英文行的末尾
    local lineno = vim.fn.line(".")
    local lineno_minus3 = lineno - 3
    local lineno_minus1 = lineno - 1
    local line = vim.fn.getline(".")
    local line_minus3 = vim.fn.getline(lineno_minus3)
    local line_minus1 = vim.fn.getline(lineno_minus1)

    local sep = " "
    -- local sep = "" -- 暂时用于en2zh，然后平行中文原文和中文机翻
    if (line_minus1 == "" or line_minus3 == "") then sep = "" end
    vim.fn.setline(lineno_minus3, M.strip(line_minus3) .. sep .. line)
    vim.fn.setline(lineno, '')
end

local map_intern = function()
    keyset('n', 'K', '3k', { buffer = true })
    keyset('n', 'J', '3j', { buffer = true })

    keyset('n', 'M', '<Cmd>silent!! intrn-align-backup.sh %<CR><Cmd>lua M.intrn_join()<CR>', { buffer = true, nowait=true })
    keyset('n', 'd', '<Cmd>write<CR><Cmd>silent!! intrn-align-update.sh %<CR>', { buffer = true, nowait=true })
    keyset('n', ',', 'Md', { remap = true }, { buffer = true, nowait=true })
    keyset('n', 'r', '<Cmd>let pos=getcurpos()[1:] | %d | 0r %.bak | call cursor(pos)<CR>', { buffer = true, nowait=true })
end

vim.api.nvim_create_autocmd("BufEnter", { pattern = "*interlaced*", callback = map_intern })
