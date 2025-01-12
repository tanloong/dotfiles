#!/usr/bin/env lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local keyset = vim.keymap.set

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
    local buf = tonumber(vim.fn.expand "<abuf>")
    vim.api.nvim_buf_delete(buf, { force = true })
  end
}) -- }}}

-- {{{ auto save
autocmd({ "FocusLost", "BufLeave" }, {
  pattern = "*",
  group = augroup("auto save", { clear = true }),
  command = "silent! w",
}) -- }}}

-- {{{ q/, q:
autocmd("CmdwinEnter",
  {
    group = augroup("cursor_up_when_entering_cmdwin", { clear = true }),
    command = [[normal! k]]
  }) -- }}}

-- InGitRepo{{{
-- https://github.com/wbthomason/packer.nvim/discussions/534#discussioncomment-2747491
local function check_git_repo()
  local cmd = "git rev-parse --is-inside-work-tree"
  if vim.fn.system(cmd) == "true\n" then
    vim.api.nvim_exec_autocmds("User", { pattern = "InGitRepo" })
    return true -- removes autocmd after lazy loading git related plugins
  end
end
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, { callback = function() vim.schedule(check_git_repo) end }) -- }}}

-- au("BufEnter", { pattern = "term://*", command = 'startinsert' })
-- Output is followed if cursor is on the last line.
-- au("BufLeave", { pattern = "term://*", command = 'normal G' })

