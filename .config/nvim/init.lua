local optset = vim.opt
local keyset = vim.keymap.set
local hl = vim.api.nvim_set_hl
local au = vim.api.nvim_create_autocmd
keyset('n', '@:', ':silent!! intrn-align-update.sh %:s?interlaced?zh? %:s?interlaced?en? %<CR>')
keyset('n', '@;', ':silent!! intrn-align-update.sh %:s?interlaced?zh? %:s?interlaced?en? %<CR>')
keyset('n', '<enter>', 'i<enter><esc>')
-- options and hilights{{{
optset.backspace='2'
optset.background='dark'
optset.number=true
optset.relativenumber=true
optset.tabstop=4
optset.expandtab=true
optset.shiftwidth=4
optset.updatetime=100
optset.signcolumn='number'
optset.mouse='nvi'
optset.scrolloff=5
optset.ignorecase=true
optset.smartcase=true
optset.wrap=true
optset.wrapscan=true
optset.linebreak=true
optset.swapfile=false
optset.laststatus=2
optset.infercase=true
optset.matchpairs='<:>,(:),{:},[:]'
optset.foldmethod='marker'
optset.spelllang='en,cjk'
optset.complete='.,w,b,u,t,i,k'
optset.guicursor={'i-v:ver1,a:blinkon0'}
optset.pumheight=7
optset.backup=false
optset.nrformats='octal'
optset.fillchars={fold='─'}
optset.listchars={trail='●'}
optset.clipboard:prepend {'unnamed,unnamedplus'}
optset.dictionary:append {vim.env.HOME.."/.local/share/BNC-40thousand.txt"}
optset.wildignore:append {'*aux,*toc,*out'}
optset.path:append {'**'}
-- Save files that require root permission
    vim.cmd([[cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!]])
hl(0, 'Visual', {ctermbg='lightgray', ctermfg='black'})
hl(0, 'Conceal', {ctermbg='none', ctermfg='none'})
hl(0, 'MatchParen', {ctermbg='none', ctermfg='green'})
hl(0, 'Pmenu', {ctermbg=236, ctermfg='none'})
hl(0, 'PmenuSel', {ctermbg=24, ctermfg='none'})
hl(0, 'Folded', {ctermbg='none', ctermfg=14})
hl(0, 'SpellBad', {undercurl=true, ctermbg='none', ctermfg=9})
hl(0, 'SpellCap', {undercurl=true, ctermbg='none', ctermfg=12})
hl(0, 'SpellLocal', {undercurl=true, ctermbg='none', ctermfg=14})
hl(0, 'SpellRare', {undercurl=true, ctermbg='none', ctermfg=13})
-- }}}
-- mappings{{{
keyset({'n','v','o'}, '9', '$')
keyset({'n','v','o'}, 'K', '5gk')
keyset({'n','v','o'}, 'J', '5gj')
keyset({'n','v','o'}, 'H', '5h')
keyset({'n','v','o'}, 'L', '5l')
keyset({'n','v','o'}, 'Q', '@q')
keyset('n', 'j', 'gj')
keyset('n', 'k', 'gk')
keyset('n', 'gk', 'k')
keyset('n', 'gj', 'j')
keyset('n', 's<space>', ':!<SPACE>')
keyset('n', 'S', ':source $MYVIMRC<CR>')
keyset('n', 'R', ':write<CR>:edit!<CR>')
keyset('n', 'M', 'J')
keyset('n', 'g9', 'g$')
keyset('n', 'ga', ':tabe<CR>:term lazygit<CR>i')
keyset('n', '>', '>>')
keyset('n', '<', '<<')
keyset('n', '<c-p>', ':%s///g<Left><Left>')
keyset('v', '<c-p>', ':s///g<Left><Left>')
keyset('n', '<c-q>', ':q!<CR>')
keyset('n', '<SPACE>q', ':q!<CR>')
keyset('n', '<SPACE>e', ':set spell!<bar>set spell?<CR>')
keyset('n', '<SPACE><CR>', ':set hlsearch!<bar>set hlsearch?<CR>')
keyset('n', '<F4>', ':q!<CR>')
keyset('n', 'sv', ':vsplit<CR>')
keyset('n', 'ss', ':split<CR>')
keyset('n', '<up>', ':res +2<CR>')
keyset('n', '<down>', ':res -2<CR>')
keyset('n', '<left>', ':vertical resize-2<CR>')
keyset('n', '<right>', ':vertical resize+2<CR>')
keyset('n', 'te', ':tabedit<CR>')
keyset('n', 'gh', ':tabprevious<CR>')
keyset('n', 'gl', ':tabnext<CR>')
keyset('n', '/', '/\\v')
keyset('v', '/', '/\\v')
keyset('n', '?', '?\\v')
keyset('v', '?', '?\\v')
keyset('n', 'vie', 'ggVG')
keyset('n', 'die', 'ggdG')
keyset('n', 'yie', 'ggyG')
keyset('n', 'cie', 'ggcG')
-- keyset('t', '<c-h>', '<c-\\><c-N><c-w>h')
-- keyset('t', '<c-j>', '<c-\\><c-N><c-w>j')
-- keyset('t', '<c-k>', '<c-\\><c-N><c-w>k')
-- keyset('t', '<c-l>', '<c-\\><c-N><c-w>l')
-- keyset('i', '<c-h>', '<c-\\><c-N><c-w>h')
-- keyset('i', '<c-j>', '<c-\\><c-N><c-w>j')
-- keyset('i', '<c-k>', '<c-\\><c-N><c-w>k')
-- keyset('i', '<c-l>', '<c-\\><c-N><c-w>l')
keyset('n', 'sh', '<c-w>h')
keyset('n', 'sl', '<c-w>l')
keyset('n', 'sj', '<c-w>j')
keyset('n', 'sk', '<c-w>k')
keyset('t', '<Esc>', '<C-\\><C-n>')
-- To Turn One Line Into Title Caps, Make Every First Letter Of A Word Uppercase:
    keyset('n', 'gug', ':s/\\v<(.)(\\w*)/\\u\\1\\L\\2/g<CR>:nohlsearch<CR>')
-- Compile document, be it groff/LaTeX/markdown/etc.
    keyset('n', '<LEADER><F5>', ':w! | !compiler "%"<CR>')
-- Open corresponding .pdf/.html or preview
    keyset('n', '<SPACE>o', ':silent!!opout "%"<CR>')
-- Perform dot commands over visual blocks:
    keyset('v', '.', ':normal .<CR>')
keyset('v', 'p', '"_dP ')
-- keep what I am pasting
-- Spell checking on the fly
keyset('i', '<c-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u')
keyset('n', '<SPACE><SPACE>', '/<<>><CR>:set nohlsearch<CR>"_c4<right>')
keyset('i', 'jk', '<Esc>/<<>><CR>:set nohlsearch<CR>"_c4<right>')
keyset('i', 'jj', '<right>')
keyset('i', 'kk', '<left>')
--  展开活动缓冲区所在目录
    keyset('c', '%%', "getcmdtype()==':'? expand('%:h').'/' : '%%'", {expr=true})
--  }}}
-- miscellaneous{{{
vim.cmd([[filetype plugin on]])
vim.cmd([[filetype indent on]])
vim.cmd([[syntax on]])
vim.cmd([[iabbrev teh the]])
vim.g['netrw_winsize'] = 30 -- Change the size of the Netrw window when it creates a split.
vim.g['netrw_banner'] = 0   -- Hide the banner. To show it temporarily use I inside Netrw.
-- check |netrw-browse-maps| for more mappings
-- 打开文件时跳到上次的位置
vim.cmd([[
    au BufReadPost *
    \ if line("'\"") > 1
    \ && line("'\'") <= line("$") |
    \ exe "normal! g'\""|
    \ endif
]])
vim.cmd([[
if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also https://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif
]])
vim.cmd([[packadd! matchit]])
vim.b['batch_words']='begin:end'
-- Clean out tex build files whenever I close out of a .tex file.
au("VimLeave",{
    pattern = "*.tex",
    command = "silent!! latexmk -c %"
  })
-- }}}
-- skeleton{{{
do
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
end
-- }}}
-- vim-plug{{{
local Plug = vim.fn['plug#']
vim.call('plug#begin','~/.config/nvim/plugged')
    Plug('https://gitee.com/ProVim/coc.nvim.git', {branch='release'})
    Plug('https://gitee.com/tanloong/vim-surround.git')
    Plug('https://gitee.com/yanzhongqian/nerdcommenter.git')
    Plug('https://gitee.com/lovealone72/vim-markdown-toc.git', {['for']={'markdown'}})
    Plug('https://gitee.com/yaozhijin/vim-table-mode.git', {['for']={'markdown'}})
    -- Plug 'https://gitee.com/zerosharp/indentLine.git'
    Plug('https://gitee.com/tanloong/wildfire.vim.git')
    Plug('https://gitee.com/oy456xd/vim-visual-multi.git')
    -- vim-slime, needs xdotool
    Plug('https://gitee.com/tanloong/vim-slime')
    -- :help AutoSave.nvim, automatically saving your work whenever you make changes to it
    -- :ASToggle, :ASOn, :ASOff
    Plug('https://gitee.com/tanloong/auto-save.nvim.git')
    -- VimTex
    Plug('https://gitee.com/mirrors/vimtex.git')
    Plug('https://gitee.com/ProVim/vim-easymotion.git')
    -- ch(如，常)对应字母i，sh(如，厦)对应字母u，zh(如，真)对应字母v
    Plug('https://gitee.com/tanloong/vim-easymotion-chs.git')
vim.call('plug#end')
-- }}}
-- nerdcommenter{{{
-- 关闭默认键位
vim.g['NERDCreateDefaultMappings'] = 0
-- Add spaces after comment delimiters by default
vim.g['NERDSpaceDelims'] = 0
-- Align line-wise comment delimiters flush left instead of following code indentation
-- 注释符紧跟缩进的话， autopep8 会把注释行对齐成一行，取消注释时导致缩进错误
vim.g['NERDDefaultAlign'] = 'left'
-- Use compact syntax for prettified multi-line comments
vim.g['NERDCompactSexyComs'] = 1
keyset({'n','v','o'}, '<SPACE>c', '<plug>NERDCommenterToggle')
-- }}}
-- vim-table-mode{{{
-- 设置table mode先导键为<SPACE>t
vim.g['table_mode_map_prefix'] = '<SPACE>t'
-- 进入或退出 table 模式时给出提示
vim.g['table_mode_verbose'] = 1
vim.g['table_mode_corner'] = '|'
-- }}}
-- wildfire{{{
-- Selects the next closest text object.
    keyset({'n','v','o'}, '=', '<Plug>(wildfire-fuel)')
-- Selects the previous closest text object.
    keyset('v', '-', '<Plug>(wildfire-water)')
    vim.g['wildfire_objects'] = {"i'", "a'", 'i"', 'a"', "i)", "a)", "i]", "a]", "i}", "a}", "ip", "it", "iW", "i`"}
-- }}}
-- vim-surround{{{
keyset('x', 's', '<Plug>VSurround')
-- }}}
-- coc.nvim{{{
keyset('n', '<leader>c', ':CocCommand<space>')
vim.cmd([[highlight! link CocMenuSel PmenuSel]])
vim.cmd([[highlight! CocPumSearch ctermfg=yellow]])
-- Use tab for trigger completion with characters ahead and navigate.
-- NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
-- other plugin before putting this into your config.
vim.cmd([[
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
]])
-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice.
vim.cmd([[
inoremap <silent><expr> <CR> coc#pum#visible() ?
                              \ coc#pum#info()['index'] >= 0 ?
                              \ coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
]])
vim.cmd([[
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
  ]])
-- function _G.check_back_space()
    -- local col = vim.fn.col('.') - 1
    -- return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
-- end
-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
-- GoTo code navigation.
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "gr", "<Plug>(coc-references)", {silent = true})
-- Show documentation in preview window.
keyset("n", "<leader>s", '<CMD>lua _G.show_docs()<CR>', {silent = true})
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
-- Highlight the symbol and its references when holding the cursor.
-- vim.api.nvim_create_augroup("CocGroup", {})
-- vim.api.nvim_create_autocmd("CursorHold", {
    -- group = "CocGroup",
    -- command = "silent call CocActionAsync('highlight')",
    -- desc = "Highlight symbol under cursor on CursorHold"
-- })
-- Symbol renaming.
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})
-- Formatting selected code.
keyset("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
-- Applying codeAction to the selected region.
-- Example: `<leader>aap` for current paragraph
local opts = {silent = true, nowait = true}
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
-- Apply AutoFix to problem on the current line.
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)
-- Remap <C-f> and <C-b> for scroll float windows/popups.
-- @diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true, expr = true}
keyset("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
keyset("i", "<C-f>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset("i", "<C-b>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
keyset("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
-- Use CTRL-S for selections ranges.
-- Requires 'textDocument/selectionRange' support of language server.
keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
-- vim.cmd([[set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P]])
vim.cmd([[set statusline=%<%f\ %h%m%{coc#status()}%{get(b:,'coc_current_function','')}%r%=%-14.(%l,%c%V%)\ %p%%]])
-- Add `:Format` command to format current buffer.
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})
--vim.keynmap.set('n', '<F9>', ":call CocActionAsync('format')<CR>")
-- " Add `:Fold` command to fold current buffer.
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})
-- Add `:OR` command for organize imports of the current buffer.
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})
-- }}}
-- coc-extensions{{{
vim.g['coc_global_extensions'] = {
             'coc-pyright',
             'coc-actions',
             'coc-git',
             'coc-snippets',
             'coc-r-lsp',
             'coc-sumneko-lua',
             'coc-json',
             'coc-webview',
             'coc-markdown-preview-enhanced',
             'coc-java',
             'coc-dictionary'
             }
            -- \ 'coc-smartf',
            -- \ 'coc-vimtex',
            -- \ 'coc-sh',
            -- \ 'coc-texlab',
            -- \ 'coc-clangd',
-- }}}
-- coc-snippets{{{
-- Use <C-o> for trigger snippet expand.
keyset('i', '<c-o>', '<Plug>(coc-snippets-expand)')
-- Use <C-j> for jump to next placeholder, it's default of coc.nvim
vim.g['coc_snippet_next'] = '<c-j>'
-- Use <C-k> for jump to previous placeholder, it's default of coc.nvim
vim.g['coc_snippet_prev'] = '<c-k>'
-- }}}
-- vim-markdown-toc{{{
vim.g['vmt_auto_update_on_save'] = 0
vim.g['vmt_dont_insert_fence'] = 0
-- }}}
-- vim-slime{{{
vim.g['slime_target'] = "x11"
vim.g['slime_no_mappings'] = 1
keyset('x', '<F5>', '<Plug>SlimeRegionSend')
keyset('n', '<F5>', ':SlimeSendCurrentLine<CR>')
keyset('n', '<c-c>v', '<Plug>SlimeConfig')
vim.g['slime_preserve_curpos'] = 0
keyset('n', 's<F5>', '<Plug>SlimeSendCell')
-- }}}
-- VimTeX{{{
-- 0. 快捷键！！！:help vimtex-default-mappings
-- 1. :help vimtex
-- 2. [Blog] https://ejmastnak.github.io/tutorials/vim-latex/vimtex.html
-- 3. 在 ~/.latexmkrc 中设置 $pdflatex='xelatex -shell-escape -synctex=1';
-- 后，可以在 zathura 中用 Ctrl+左键 跳转到 vim 对应位置，
-- 也可以在 vim 中用 \lv 跳转到 zathura 对应位置
-- 4. 写入模式 `]]` 自动补全 `}` 或 `\end{<env>}`
vim.g['tex_flavor']='latex'  -- set filetype to 'tex' in empty latex file
vim.g['vimtex_view_method'] = 'zathura'
vim.g['vimtex_quickfix_mode'] = 0
vim.g['vimtex_quickfix_open_on_warning'] = 0
vim.g['vimtex_matchparen_enabled'] = 0
vim.g['vimtex_indent_enabled'] = 0
vim.g['vimtex_imaps_enabled'] = 0
vim.g['vimtex_compiler_method']='latexmk'
vim.g['vimtex_compiler_latexmk'] = {
     build_dir = '',
     callback = 1,
     continuous = 1,
     executable = 'latexmk',
     hooks = {},
     options = {
       '-verbose',
       '-file-line-error',
       '-synctex=1',
       '-interaction=nonstopmode',
       '-shell-escape',
     },
    }
-- :help vimtex-toc
vim.g['vimtex_toc_config'] = {
     fold_enable=1,
     split_pos='vert leftabove',
     indent_levels=1,
     show_numbers=0,
     layer_status= {
         content= 1,
         label= 0,
         todo= 0,
         include= 0,
       }
     }
vim.g['vimtex_syntax_conceal'] = {
    accents=1,
    ligatures=0,
    cites=1,
    fancy=1,
    greek=1,
    math_bounds=0,
    math_delimiters=1,
    math_fracs=1,
    math_super_sub=1,
    math_symbols=1,
    sections=0,
    styles=1,
    }
keyset('n', 'tt', ':VimtexTocToggle<CR><c-w>h')
-- }}}
-- vim-easymotion{{{
vim.g['EasyMotion_smartcase'] = 1
vim.g['EasyMotion_use_smartsign_us'] = 1
keyset({'n','v','o'}, '<bar>', '<Plug>(easymotion-bd-f)')
-- }}}
-- auto-save{{{
require('auto-save').setup(
    {
        enabled = true,
        -- execution_message = "AutoSave: saved",
        execution_message = {
            message = function() -- message to print on save
                return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")) end,
            dim = 0,
            -- dim the color of `message`
            cleaning_interval = 1250,
            -- (milliseconds) automatically clean MsgArea after displaying `message`.
            -- See :h MsgArea
        },
        trigger_events = {"InsertLeave", "TextChanged"},
        write_all_buffers = false,
        -- write all buffers when the current one meets `condition`
        debounce_delay = 135,
        -- saves the file at most every `debounce_delay` milliseconds
    }
)
-- }}}
