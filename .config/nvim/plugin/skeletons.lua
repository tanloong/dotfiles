#!/usr/bin/env lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local ext_skeleton = {
  c = "skeleton.c",
  lua = "skeleton.lua",
  py = "skeleton.python",
  sh = "skeleton.sh",
  awk = "skeleton.awk",
  r = "skeleton.r",
  rmd = "skeleton.rmd",
  sed = "skeleton.sed",
  go = "skeleton.go",
  pl = "skeleton.perl",
  php = "skeleton.php"
}

for ext, filename in pairs(ext_skeleton) do
  local group_name = ("skeleton_%s"):format(ext)
  autocmd("BufNewFile", {
    pattern = "*." .. ext,
    group = augroup(group_name, { clear = true }),
    command = ("silent keepalt 0r ~/.config/nvim/skeleton/%s | :normal G"):format(filename)
  })
end

autocmd("BufNewFile", {
  pattern = "*.tex",
  group = augroup("skeleton_tex", { clear = true }),
  command = "silent keepalt 0r ~/.config/nvim/skeleton/skeleton.tex | :startinsert!"
})
