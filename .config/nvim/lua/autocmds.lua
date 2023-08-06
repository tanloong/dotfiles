#!/usr/bin/env lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- {{{ don't auto-insert comment char on linebreak
autocmd("FileType",
    {
        pattern = "*",
        group = augroup("format_options", { clear = true }),
        command = [[set formatoptions-=ro]]
    })-- }}}
-- {{{ basic config for terminal buffer
autocmd("TermOpen",
    {
        pattern = "*",
        group = augroup("config_for_terminal_buf", { clear = true }),
        command = [[setlocal norelativenumber nonumber | setlocal statusline=channel:\ %{&channel} | startinsert]]
    })-- }}}
-- {{{ don't show [Process exited] in finished terminal
autocmd("TermClose", {
    pattern = "*",
    group = augroup("term_close", { clear = true }),
    callback = function()
        buf = tonumber(vim.fn.expand("<abuf>"))
        vim.api.nvim_buf_delete(buf, { force = true })
    end
})-- }}}
-- {{{ TheCW's preview_stack_trace
local preview_stack_trace = function()
    local line = vim.api.nvim_get_current_line()
    local pattern = 'File "([^"]+)", line (%d+)'
    local filepath, lineno = string.match(line, pattern)

    if filepath and lineno then
        vim.cmd("wincmd k")
        vim.cmd("e " .. filepath)
        vim.api.nvim_win_set_cursor(0, { tonumber(lineno), 1 })
        vim.cmd("wincmd j")
    end
end
autocmd("BufEnter", {
    pattern = "term://*",
    group = augroup("preview_stack_trace", { clear = true }),
    callback = function()
        vim.keymap.set("n", "p", preview_stack_trace, { silent = true, noremap = true, buffer = true })
    end
})-- }}}

-- au("BufEnter", { pattern = "term://*", command = 'startinsert' })
-- Output is followed if cursor is on the last line.
-- au("BufLeave", { pattern = "term://*", command = 'normal G' })

