#!/usr/bin/env lua

if not vim.g.neovide then
  return
end

local g = vim.g

g.neovide_cursor_animation_length = 0
g.neovide_cursor_short_animation_length = 0
g.neovide_cursor_trail_size = 0
g.neovide_cursor_antialiasing = false
g.neovide_cursor_animate_in_insert_mode = false
g.neovide_cursor_animate_command_line = false
g.neovide_cursor_smooth_blink = false

vim.opt.guicursor = { "i:block-inverse,v:block-inverse,a:blinkon0" }
vim.o.guifont = "Cousine Nerd Font Mono,Microsoft YaHei"
