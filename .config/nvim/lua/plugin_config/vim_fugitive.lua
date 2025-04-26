#!/usr/bin/env lua

local map = vim.keymap.set
map("n", "<leader>g", ":G<space>")
vim.cmd(
  [[
  cabbrev <expr> g (getcmdtype()==':' && getcmdline() == 'g' ? 'G' : 'git')
  cabbrev <expr> git (getcmdtype()==':' && getcmdline() == 'git' ? 'G' : 'g')
  ]]
)
