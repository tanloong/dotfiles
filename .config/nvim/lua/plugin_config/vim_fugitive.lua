#!/usr/bin/env lua

local map = vim.keymap.set
map("n", "<space>g", "<Cmd>G<CR>")
vim.cmd(
  [[
  cabbrev <expr> g (getcmdtype()==':' && getcmdline() == 'g' ? 'G' : 'g')
  cabbrev <expr> git (getcmdtype()==':' && getcmdline() == 'git' ? 'G' : 'g')
  ]]
)
