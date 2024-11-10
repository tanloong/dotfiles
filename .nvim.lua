#!/usr/bin/env lua

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local curr_path = debug.getinfo(1, "S").source
curr_path = curr_path:sub(2, curr_path:find("[^/\\]*$") - 1) -- 截取出目录

autocmd("BufWritePost", {
    pattern = curr_path .. ".local/share/fcitx5/table/*.txt",
    group = augroup("build_fcitx5_table", { clear = true }),
    callback = function()
      os.execute("bash " .. curr_path .. "./build_fcitx5_table.sh > /dev/null 2>&1")
    end
})
