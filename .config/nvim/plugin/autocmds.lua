#!/usr/bin/env lua

local au = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("TlGroup", { clear = true })

-- {{{ don't auto-insert comment char on linebreak
au("FileType",
  {
    pattern = "*",
    group = group,
    command = [[set formatoptions-=ro]]
  }) -- }}}
-- {{{ basic config for terminal buffer https://github.com/neovim/neovim/issues/14986
au("TermOpen",
  {
    pattern = "*",
    group = group,
    command = [[setlocal statusline=channel:\ %{&channel}]]
  }) -- }}}

-- {{{ auto save
au({ "FocusLost", "BufLeave" }, {
  pattern = "*",
  group = group,
  command = "silent! update",
}) -- }}}

-- -- {{{ q/, q: -- cursor_up_when_entering_cmdwin
-- au("CmdwinEnter",
--   {
--     group = group,
--     command = [[normal! k]]
--   }) -- }}}

-- au("TextYankPost", {
--   group = group,
--   callback = function()
--     vim.highlight.on_yank { higroup = "IncSearch", timeout = 200 }
--   end,
-- })

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
