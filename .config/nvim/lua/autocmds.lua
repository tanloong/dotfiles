#!/usr/bin/env lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- {{{ don't auto-insert comment char on linebreak
autocmd("FileType",
    {
        pattern = "*",
        group = augroup("format_options", { clear = true }),
        command = [[set formatoptions-=ro]]
    }) -- }}}
-- {{{ basic config for terminal buffer
autocmd("TermOpen",
    {
        pattern = "*",
        group = augroup("config_for_terminal_buf", { clear = true }),
        command = [[setlocal norelativenumber nonumber | setlocal statusline=channel:\ %{&channel}]]
    }) -- }}}
-- {{{ don't show [Process exited] in finished terminal
autocmd("TermClose", {
    pattern = "*",
    group = augroup("term_close", { clear = true }),
    callback = function()
        buf = tonumber(vim.fn.expand("<abuf>"))
        vim.api.nvim_buf_delete(buf, { force = true })
    end
}) -- }}}

local function start_hl()
    if vim.v.hlsearch == 1 then return end

    local keycode = vim.api.nvim_replace_termcodes('<Cmd>set hls<CR>', true, false, true)
    vim.api.nvim_feedkeys(keycode, 'n', false)
end

-- check semantic alignment, part-time job from 2023.09.23 on providing training data for machine translation
local function preview_pair(direction)
    vim.cmd([[tabnext]])
    vim.cmd(direction)

    local line = vim.api.nvim_get_current_line()
    local patterns = { 'line (%d+): ([^,]+),(.*)$', }

    for _, pattern in ipairs(patterns) do
        lineno, py_zh_re, py_en_re = string.match(line, pattern)
        if lineno then break end
    end

    if not lineno then
        print("filepath or lineno not found")
        return
    end

    vim.cmd([[tabprevious]])
    vim_zh_re = py_zh_re:gsub("%(%?:", "%%("):gsub("%(%?(<?)([!=])([^)]+)%)", "(%3)@%1%2")
    vim_en_re = py_en_re:gsub("%(%?i[^)]*%)", "\\c"):gsub("\\b", "%%(<|>)"):gsub("%(%?(<?)([!=])([^)]+)%)", "(%3)@%1%2")
    :gsub("%(%?:([^|)]+)[^)]*%)", "%1")

    start_hl()
    vim.cmd("/\\v" .. vim_zh_re .. "|" .. vim_en_re)
    -- vim.fn.search("/\\v" .. vim_zh_re .. "|" .. vim_en_re, 'cnW')

    vim.fn.cursor({ tonumber(lineno), 1 })

    local raw_elem_zh = py_zh_re:gsub("%(%?x%)", "")
    -- (?:他|它|她)们 --> 他们
    raw_elem_zh = raw_elem_zh:gsub("%(%?:([^|)]+)[^)]*%)", "%1")
    raw_elem_zh = raw_elem_zh:gsub("[%^%$]", "")
    -- (?:他|它|她)们(?!的) --> (?:他|它|她)们
    raw_elem_zh = raw_elem_zh:gsub("%(%?(<?)([!=])([^)]+)%)", "")
    vim.fn.setreg("+", raw_elem_zh)
end

local function preview_next()
    preview_pair("normal! k")
    vim.cmd([[normal! zz]])
end

local function preview_previous()
    preview_pair("normal! j")
    vim.cmd([[normal! zz]])
end

local function toggle_map_preview()
    if not _G.has_preview_mapping then
        vim.keymap.set("n", "n", preview_next, { buffer = true })
        vim.keymap.set("n", "N", preview_previous, { buffer = true })

        _G.has_preview_mapping = true
        print('Enabled mappings for preview')
    else
        vim.api.nvim_buf_del_keymap(0, "n", "n")
        vim.api.nvim_buf_del_keymap(0, "n", "N")

        _G.has_preview_mapping = false
        print('Disabled mappings for preview')
    end
end

vim.api.nvim_create_user_command("PreviewNext", preview_next, {})
vim.api.nvim_create_user_command("PreviewPrevious", preview_previous, {})
vim.api.nvim_create_user_command("ToggleMapPreview", toggle_map_preview, {})

-- autocmd("TermOpen", {
--     group = augroup("preview_stack_trace", { clear = true }),
--     callback = function()
--         vim.keymap.set("n", "p", preview_stack_trace, { silent = true, noremap = true, buffer = true })
--     end
-- })

-- {{{ q/, q:
autocmd("CmdwinEnter",
    {
        group = augroup("cursor_up_when_entering_cmdwin", { clear = true }),
        command = [[normal! k]]
    }) -- }}}

-- au("BufEnter", { pattern = "term://*", command = 'startinsert' })
-- Output is followed if cursor is on the last line.
-- au("BufLeave", { pattern = "term://*", command = 'normal G' })
