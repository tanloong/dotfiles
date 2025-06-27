#!/usr/bin/env lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local joinpath = vim.fs.joinpath
local has = vim.fn.has

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

local config_folder
if has "win32" == 1 then
  config_folder = os.getenv("LOCALAPPDATA")
else
  config_folder = joinpath(os.getenv("HOME"), ".config")
end

for ext, filename in pairs(ext_skeleton) do
  local group_name = ("skeleton_%s"):format(ext)
  autocmd("BufNewFile", {
    pattern = "*." .. ext,
    group = augroup(group_name, { clear = true }),
    command = ("silent keepalt 0r %s | :normal G"):format(
      joinpath(config_folder, "nvim", "skeleton", filename))
  })
end

autocmd("BufNewFile", {
  pattern = "*.tex",
  group = augroup("skeleton_tex", { clear = true }),
  command = ("silent keepalt 0r %s | :startinsert!"):format(
    joinpath(config_folder, "nvim", "skeleton", "skeleton.tex"))
})
