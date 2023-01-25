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
    local lnum_cur = vim.fn.line(".")
    local lnum_prev3 = lnum_cur - 3
    local lnum_prev1 = lnum_cur - 1
    local line_cur = vim.fn.getline(".")
    local line_prev3 = vim.fn.getline(lnum_prev3)
    local line_prev1 = vim.fn.getline(lnum_prev1)
    -- local sep = " "
    local sep = "" -- 暂时用于en2zh，然后平行中文原文和中文机翻
    if (line_prev1 == "" or line_prev3 == "") then sep = "" end
    vim.fn.setline(lnum_prev3, M.strip(line_prev3) .. sep .. line_cur)
    vim.fn.setline(lnum_cur, '')
end

local map_intern = function()
    keyset('n', '<c-k>', '{')
    keyset('n', '<c-j>', '}')

    keyset('n', ',d', '<Cmd>write<CR><Cmd>silent!! intrn-align-update.sh %<CR>')
    keyset('n', ',.', '<Cmd>lua M.intrn_join()<CR>')
    keyset('n', ',,', ',.,d', { remap = true })
    keyset('n', ',r', '<Cmd>let pos=getcurpos()[1:] | %d | 0r %.bak | call cursor(pos)<CR>')
end

vim.api.nvim_create_autocmd("BufEnter", { pattern = "*interlaced*", callback = map_intern })
