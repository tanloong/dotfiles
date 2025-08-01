#!/usr/bin/env lua

local g = vim.g

--disable_distribution_plugins
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrwPlugin = 1
g.loaded_matchparen = 1
g.loaded_matchit = 1

g.python_host_skip_check = 1
g.python3_host_skip_check = 1
if vim.fn.has "win32" == 1 then
  g.python_host_prog = "D:/software/scoop/apps/python/current/python.exe"
  g.python3_host_prog = "D:/software/scoop/shims/python3.exe"
else
  g.python_host_prog = "/usr/bin/python"
  g.python3_host_prog = "/usr/bin/python3"
end
