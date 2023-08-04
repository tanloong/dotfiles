#!/usr/bin/env lua

local AppendLineToThreeLinesAbove = function(lineno)
    --[[ 将行所在pair的中文或英文行合并到上一个pair对应中文或英文行的末尾 ]]
    local lineno_minus3 = lineno - 3
    local lineno_minus1 = lineno - 1
    local line = vim.fn.getline(lineno)
    local line_minus3 = vim.fn.getline(lineno_minus3)
    local line_minus1 = vim.fn.getline(lineno_minus1)

    local sep = " "
    if (line_minus1 == "" or line_minus3 == "") then sep = "" end
    vim.fn.setline(lineno_minus3, string.gsub(line_minus3, '%s+$', '') .. sep .. line)
    vim.fn.setline(lineno, '')
end

local MergeLines = function()
    local lineno = vim.fn.line(".")
    if lineno <= 3 then return end

    local last_lineno = vim.fn.line("$")

    while lineno <= last_lineno do
        AppendLineToThreeLinesAbove(lineno)
        lineno = lineno + 3
    end

    local buf = vim.api.nvim_get_current_buf()
    while string.match(vim.fn.getline(last_lineno), "^%s*$") do
        vim.fn.deletebufline(buf, last_lineno)
        last_lineno = last_lineno - 1
    end
end

local map_intern = function()
    local mappings = {
        { mode = 'n', from = ',', to = MergeLines },
        { mode = 'n', from = 'K', to = '3kzz' },
        { mode = 'n', from = 'J', to = '3jzz' }
    }
    for _, mapping in ipairs(mappings) do
        vim.keymap.set(mapping.mode, mapping.from, mapping.to, { buffer = true, nowait = true })
    end
end

vim.api.nvim_create_autocmd("BufEnter", { pattern = "*interlaced*.txt", callback = map_intern })
