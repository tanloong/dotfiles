#!/usr/bin/env lua
-- 用于上外实习
-- 2022年9月-12月

local keyset = vim.keymap.set

keyset('n', '<enter>', 'i<enter><esc>')
keyset('n', '@:', '<Cmd>silent!! intrn-align-update.sh %:s?interlaced?zh? %:s?interlaced?en? %<CR>')
keyset('n', '@;', '<Cmd>silent!! intrn-align-update.sh %:s?interlaced?zh? %:s?interlaced?en? %<CR>')
keyset('n', '@w', '<Cmd>lua M.intrn_join(" ")<CR>')
keyset('n', '@e', '<Cmd>lua M.intrn_join("")<CR>')

M = {}
function M.intrn_join(sep)
    -- 将光标所在pair的中文或英文行合并到上一个pair对应中文或英文行的末尾
    -- `dep` should be '' for Chinese lines, and ' ' for English lines.
    local line_num_cur = vim.fn.line(".")
    local line_num_target = vim.fn.line(".") - 3
    local line_cur = vim.fn.getline(".")
    local line_target = vim.fn.getline(line_num_target)
    vim.fn.setline(line_num_target,line_target..sep..line_cur)
    vim.fn.setline(line_num_cur,'')
end

