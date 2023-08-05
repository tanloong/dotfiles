#!/usr/bin/env lua
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local before = "0r ~/.config/nvim/skeleton/"
local after = " | :normal G"

autocmd("BufNewFile",
    { pattern = "*.c", group = augroup("skeleton_c", { clear = true }), command = before .. "skeleton.c" .. after })
autocmd("BufNewFile",
    { pattern = "*.lua", group = augroup("skeleton_lua", { clear = true }), command = before .. "skeleton.lua" .. after })
autocmd("BufNewFile",
    { pattern = "*.py", group = augroup("skeleton_py", { clear = true }), command = before .. "skeleton.python" .. after })
autocmd("BufNewFile", {
    pattern = "*.sh",
    group = augroup("skeleton_sh", { clear = true }),
    command = before .. "skeleton.sh" .. after
})
autocmd("BufNewFile",
    { pattern = "*.awk", group = augroup("skeleton_awk", { clear = true }), command = before .. "skeleton.awk" .. after })
autocmd("BufNewFile",
    { pattern = "*.r", group = augroup("skeleton_r", { clear = true }), command = before .. "skeleton.r" .. after })
autocmd("BufNewFile", {
    pattern = "*.rmd",
    group = augroup("skeleton_rmd", { clear = true }),
    command = before .. "skeleton.rmd" .. after
})
autocmd("BufNewFile", {
    pattern = "*.sed",
    group = augroup("skeleton_sed", { clear = true }),
    command = before .. "skeleton.sed" .. after
})
autocmd("BufNewFile", {
    pattern = "*.go",
    group = augroup("skeleton_go", { clear = true }),
    command = before .. "skeleton.go" .. after
})
autocmd("BufNewFile", {
    pattern = "*.pl",
    group = augroup("skeleton_pl", { clear = true }),
    command = before .. "skeleton.perl" .. after
})
autocmd("BufNewFile",
    { pattern = "*.tex", group = augroup("skeleton_tex", { clear = true }),
        command = before .. "skeleton.tex | :startinsert!" })
