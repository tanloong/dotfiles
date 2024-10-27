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
-- {{{ basic config for terminal buffer https://github.com/neovim/neovim/issues/14986
autocmd("TermOpen",
    {
        pattern = "*",
        group = augroup("config_for_terminal_buf", { clear = true }),
        command = [[setlocal norelativenumber nonumber | setlocal statusline=channel:\ %{&channel}]]
    }) -- }}}
-- {{{ skip [Process exited] in finished terminal
autocmd("TermClose", {
    pattern = "*",
    group = augroup("term_close", { clear = true }),
    callback = function()
        buf = tonumber(vim.fn.expand("<abuf>"))
        vim.api.nvim_buf_delete(buf, { force = true })
    end
}) -- }}}
-- {{{ auto save
autocmd({ "FocusLost", "BufLeave" }, {
    pattern = "*",
    group = augroup("auto save", { clear = true }),
    command = "silent! w",
}) -- }}}

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
