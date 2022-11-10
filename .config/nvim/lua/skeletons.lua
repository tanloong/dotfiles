#!/usr/bin/env lua
local au = vim.api.nvim_create_autocmd
local before = "0r ~/.config/nvim/skeleton/"
local after = " | :normal G"
au("BufNewFile", {pattern="*.c",   command=before.."skeleton.c"..after})
au("BufNewFile", {pattern="*.lua", command=before.."skeleton.lua"..after})
au("BufNewFile", {pattern="*.py",  command=before.."skeleton.python"..after})
au("BufNewFile", {pattern="*.sh",  command=before.."skeleton.sh"..after})
au("BufNewFile", {pattern="*.awk", command=before.."skeleton.awk"..after})
au("BufNewFile", {pattern="*.r",   command=before.."skeleton.r"..after})
au("BufNewFile", {pattern="*.rmd", command=before.."skeleton.rmd"..after})
au("BufNewFile", {pattern="*.sed", command=before.."skeleton.sed"..after})
au("BufNewFile", {pattern="*.go",  command=before.."skeleton.go"..after})
au("BufNewFile", {pattern="*.pl",  command=before.."skeleton.perl"..after})
au("BufNewFile", {pattern="*.tex", command=before.."skeleton.tex | :startinsert!"})
