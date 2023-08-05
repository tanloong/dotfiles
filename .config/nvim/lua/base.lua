#!/usr/bin/env lua

local optset = vim.opt
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

optset.backspace = 'start,eol,indent'
optset.background = 'dark'
optset.number = true
optset.relativenumber = false
optset.tabstop = 4
optset.expandtab = true
optset.shiftwidth = 4
optset.updatetime = 100
optset.signcolumn = 'yes'
optset.mouse = 'nvi'
optset.scrolloff = 3
optset.ignorecase = true
optset.infercase = true
optset.smartcase = true
optset.wrap = true
optset.wrapscan = true
optset.linebreak = true
optset.swapfile = false
optset.laststatus = 2
optset.matchpairs = '<:>,(:),{:},[:]'
optset.foldmethod = 'marker'
optset.spelllang = 'en,cjk'
optset.complete = '.,w,b,u,t,i,k'
optset.guicursor = { 'i-v:ver1,a:blinkon0' }
optset.pumheight = 7
optset.backup = false
optset.nrformats = 'octal'
optset.fillchars = { fold = '─' }
optset.listchars = { trail = '●' }
optset.clipboard:prepend { 'unnamed,unnamedplus' }
optset.dictionary:append { vim.env.HOME .. "/.local/share/BNC-40thousand.txt" }
optset.wildignore:append { '*aux,*toc,*out' }
optset.path:append { '**' }

autocmd("FileType",
    {
        pattern = "*",
        group = augroup("formatoptions", { clear = true }),
        command = [[set formatoptions-=ro]]
    })

autocmd("TermOpen",
    {
        pattern = "*",
        group = augroup("termopen", { clear = true }),
        command = [[setlocal norelativenumber nonumber | setlocal statusline=channel:\ %{&channel} | startinsert]]
    })

-- au("BufEnter", { pattern = "term://*", command = 'startinsert' })
-- Output is followed if cursor is on the last line.
-- au("BufLeave", { pattern = "term://*", command = 'normal G' })

local preview_stack_trace = function()
    local line = vim.api.nvim_get_current_line()
    local pattern = 'File "([^"]+)", line (%d+)'
    local filepath, lineno = string.match(line, pattern)

    if filepath and lineno then
        vim.cmd("wincmd k")
        vim.cmd("e " .. filepath)
        vim.api.nvim_win_set_cursor(0, { tonumber(lineno), 1 })
        vim.cmd("wincmd j")
    end
end
autocmd("BufEnter", {
    pattern = "term://*",
    group = augroup("preview_stack_trace", { clear = true }),
    callback = function()
        vim.keymap.set("n", "p", preview_stack_trace, { silent = true, noremap = true, buffer = true })
    end
})

vim.cmd([[filetype plugin indent on]])
vim.cmd([[syntax on]])
vim.cmd([[iabbrev teh the]])
vim.g['netrw_winsize'] = 30 -- Change the size of the Netrw window when it creates a split.
vim.g['netrw_banner'] = 0   -- Hide the banner. To show it temporarily use I inside Netrw.
-- check |netrw-browse-maps| for more mappings
-- Save files that require root permission
vim.cmd([[cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!]])
vim.cmd([[
if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also https://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif
]])
vim.cmd([[packadd! matchit]])
vim.b['batch_words'] = 'begin:end'
vim.g['python_host_skip_check'] = 1
vim.g['python_host_prog'] = '/usr/bin/python'
vim.g['python3_host_skip_check'] = 1
vim.g['python3_host_prog'] = '/usr/bin/python3'
