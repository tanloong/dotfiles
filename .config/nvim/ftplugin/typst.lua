#!/usr/bin/env lua

function IsInTypstMath()
    local parser = vim.treesitter.get_parser(0, "typst")
    if not parser then return false end

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1  -- Treesitter uses 0-based indexing

    local tree = parser:parse()[1]
    if not tree then return false end

    local root = tree:root()
    local node = root:named_descendant_for_range(row, col, row, col)

    while node do
        if node:type() == "math" then
            return true
        end
        node = node:parent()
    end

    return false
end
