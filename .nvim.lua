#!/usr/bin/env lua

if vim.fn.has("win32") == 1 then return end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local vim_fs = vim.fs

local script_parent = debug.getinfo(1, "S").source:sub(2, -1) -- 获取此脚本所在路径并去掉其开头的@
script_parent = vim_fs.dirname(script_parent)
local fcitx5_path = vim_fs.joinpath(vim.fn.fnamemodify(script_parent, ":p"), ".local", "share", "fcitx5")

autocmd("BufWritePost", {
  pattern = { fcitx5_path .. "/table/*.txt", fcitx5_path .. "/inputmethod/*.conf" },
  group = augroup("build_fcitx5_table", { clear = true }),
  callback = function()
    os.execute("bash " .. vim_fs.joinpath(script_parent, "build_fcitx5_table.sh") .. " > /dev/null 2>&1")
  end
})
