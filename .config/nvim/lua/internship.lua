#!/usr/bin/env lua
-- 用于上外实习
-- 2022年9月-12月

local keyset = vim.keymap.set

keyset('n', '<enter>', 'i<enter><esc>')
keyset('n', '@:', '<Cmd>silent!! intrn-align-update.sh %:s?interlaced?zh? %:s?interlaced?en? %<CR>')
keyset('n', '@;', '<Cmd>silent!! intrn-align-update.sh %:s?interlaced?zh? %:s?interlaced?en? %<CR>')
keyset('n', '@@', '<Cmd>lua M.intrn_join()<CR>')
keyset('n', '@R', '<Cmd>let pos=getcurpos()[1:] | %d | 0r %.bak | call cursor(pos)<CR>')
-- cursor position
-- reset cursor position

M = {}
function M.strip(s)
    return string.gsub(s, '%s+$', '')
end
function M.intrn_join()
    -- 将光标所在pair的中文或英文行合并到上一个pair对应中文或英文行的末尾
    -- `dep` should be '' for Chinese lines, and ' ' for English lines.
    local lnum_cur = vim.fn.line(".")
    local lnum_target = lnum_cur - 3
    local line_cur = vim.fn.getline(".")
    local line_target = vim.fn.getline(lnum_target)
    local sep = " "
    if vim.fn.getline(lnum_cur-1)=="" then sep="" end
    vim.fn.setline(lnum_target,M.strip(line_target)..sep..line_cur)
    vim.fn.setline(lnum_cur,'')
end
