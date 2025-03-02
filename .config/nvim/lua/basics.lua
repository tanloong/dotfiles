#!/usr/bin/env lua

local opt = vim.opt

opt.backspace = 'start,eol,indent'
opt.background = 'dark'
opt.number = true
opt.relativenumber = false
opt.numberwidth = 1
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.updatetime = 100
opt.signcolumn = 'yes'
opt.mouse = 'nvi'
-- opt.mouse = ''
opt.scrolloff = 3
opt.ignorecase = true
opt.infercase = true
opt.smartcase = true
opt.wrap = true
opt.wrapscan = true

opt.linebreak = true
opt.swapfile = false
opt.laststatus = 2
opt.matchpairs = '<:>,(:),{:},[:]'
opt.foldmethod = 'marker'
opt.spelllang = 'en,cjk'
opt.complete = '.,w,b,u,t,i,k'
if vim.fn.has("nvim-0.11") == 1 then
  opt.completeopt = 'menu,preview,fuzzy'
else
  opt.completeopt = 'menu,preview'
end
opt.guicursor = { 'i:ver1,v:block-inverse,a:blinkon0' }
opt.pumheight = 7
opt.backup = false
opt.nrformats = 'octal'
opt.fillchars = { fold = '─' }
opt.listchars = { trail = '●' }
opt.exrc = true -- auto load .nvim.lua file under cwd
opt.modeline = false

-- if vim.fn.has("nvim-0.10") == 1 then
--   vim.g.clipboard = {
--     name = 'OSC 52',
--     copy = {
--       ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--       ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--       ['"'] = require('vim.ui.clipboard.osc52').copy('"'),
--     },
--     paste = {
--       ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--       ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--       ['"'] = require('vim.ui.clipboard.osc52').paste('"'),
--     },
--   }
-- else
--   opt.clipboard:prepend { 'unnamed,unnamedplus' }
-- end
opt.clipboard:prepend { 'unnamed,unnamedplus' }
opt.dictionary:append { vim.env.HOME .. "/.local/share/words.txt" }
opt.thesaurus:append { vim.env.HOME .. "/.local/share/WordNet-thesaurus.txt" }
opt.wildignore:append { '*aux,*toc,*out' }
opt.wildignorecase = true -- ignore case when completing file names and directories in cmd-line
opt.path:append { '**' }
opt.cursorline = true
opt.cursorlineopt = 'screenline'
opt.termguicolors = true
opt.diffopt = { "internal", "filler", "closeoff", "followwrap" }
opt.jumpoptions = "view"
opt.grepprg = "rg --vimgrep --smart-case $*"
opt.grepformat = "%f:%l:%c:%m,%f:%l:%m,%f:%l%m,%f  %l%m"
-- opt.showcmd = false
opt.undofile = true
-- opt.iskeyword = "@,48-57,192-255" -- remove _ from the default

vim.cmd([[filetype plugin indent on]])
vim.cmd([[syntax on]])
vim.g.netrw_winsize = 30 -- Change the size of the Netrw window when it creates a split.
vim.g.netrw_banner = 0   -- Hide the banner. To show it temporarily use I inside Netrw.
vim.g.netrw_liststyle = 3
-- check |netrw-browse-maps| for more mappings
vim.cmd([[
if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also https://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif
]])
