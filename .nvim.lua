#!/usr/bin/env lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local vim_fs = vim.fs

local script_parent = vim_fs.dirname(vim.fn.expand("%:p"))
local fcitx5_path = vim_fs.joinpath(script_parent, ".local", "share", "fcitx5")

autocmd("BufWritePost", {
  pattern = { fcitx5_path .. "/table/*.txt", fcitx5_path .. "/inputmethod/*.conf" },
  group = augroup("build_fcitx5_table", { clear = true }),
  callback = function()
    os.execute("bash " .. vim_fs.joinpath(script_parent, "build_fcitx5_table.sh") .. " > /dev/null 2>&1")
  end
})
