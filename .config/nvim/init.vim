"basic config{{{
filetype plugin on
filetype indent on
syntax on
set t_Co=256
set background=dark
set number
set relativenumber
set backspace=2
set tabstop=4
set expandtab
set shiftwidth=4
set updatetime=100
set signcolumn=number
set mouse=nvi | " enable mouse in normal, visual, and insert modes
set nrformats= | "把所有数字当成 10 进制，不管是不是以 0 开头
set scrolloff=5 | "光标垂直移动时保持顶端/底端显示5行
set ignorecase
set smartcase | "当搜索的字符含大写字母，暂时保持case sensitive
set wrap | "内容超出一行时自动换行
set wrapscan | "环形搜索，nowrapscan
set linebreak | "不要从单词中间换行
set noswapfile | "不要产生交换文件
set laststatus=2 | "show filename below
set clipboard^=unnamed,unnamedplus | "复制到系统寄存器(*, +)
set infercase
set dictionary+=$HOME/.local/share/BNC-40thousand.txt
set wildignore+=*aux,*toc,*out
set matchpairs=<:>,(:),{:},[:]
set foldmethod=marker
set fillchars=fold:─
set path+=**
set spelllang=en,cjk
set complete=.,w,b,u,t,i,k
set guicursor=i-v:ver1,a:blinkon0
exec "nohlsearch"
set pumheight=5

iabbrev teh the

"highlight Visual cterm=none ctermbg=237 ctermfg=none
highlight Visual cterm=none ctermbg=lightgray ctermfg=black guibg=lightgray guifg=black
highlight Conceal cterm=none ctermbg=none ctermfg=none guibg=none guifg=none
highlight MatchParen cterm=none ctermbg=none ctermfg=green guibg=none guifg=green
highlight Pmenu cterm=none ctermbg=236 ctermfg=none guibg=236 guifg=none
highlight PmenuSel cterm=none ctermbg=24 ctermfg=none guibg=24 guifg=none
highlight Folded cterm=none ctermbg=none ctermfg=14 guibg=none guifg=14
highlight SpellBad cterm=undercurl ctermbg=none ctermfg=9 guibg=none guifg=9
highlight SpellCap cterm=undercurl ctermbg=none ctermfg=12 guibg=none guifg=12
highlight SpellLocal cterm=undercurl ctermbg=none ctermfg=14 guibg=none guifg=14
highlight SpellRare cterm=undercurl ctermbg=none ctermfg=13 guibg=none guifg=13

let g:netrw_winsize = 30 | " Change the size of the Netrw window when it creates a split.
let g:netrw_banner = 0   | " Hide the banner. To show it temporarily use I inside Netrw.
" check |netrw-browse-maps| for more mappings

if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also https://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif

" 打开文件时跳到上次的位置
    au BufReadPost * if line("'\"") > 1 && line("'\'") <= line("$") | exe "normal! g'\""| endif
packadd! matchit
let b:batch_words='begin:end'

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
    autocmd VimLeave *.tex !texclear %
" Automatically deletes all trailing whitespace and newlines at end of file on save.
    " autocmd BufWritePre * let currPos = getpos(".")
    " autocmd BufWritePre * %s/\s\+$//e
    " autocmd BufWritePre * %s/\n\+\%$//e
    " autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" Detect platform
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
"}}}
"keybindings{{{
noremap 9 $
noremap K 5gk
noremap J 5gj
noremap H 5h
noremap L 5l
noremap Q gq
nnoremap j gj
nnoremap k gk
nnoremap gk k
nnoremap gj j
nnoremap s :<nop>
nnoremap S :<nop>
nnoremap R :write<CR>:edit!<CR> | " 保存修改，并重新从硬盘读取此文件
nnoremap M J
nnoremap g9 g$
nnoremap ga :tabe<CR>:term lazygit<CR>i
nnoremap > >>
nnoremap < <<
nnoremap @@ @q
nnoremap <c-p> :%s///g<Left><Left>
vnoremap <c-p> :s///g<Left><Left>
nnoremap <SPACE>a ggVG
nnoremap <c-q> :q!<CR>
nnoremap <SPACE>e :set spell!<CR>
nnoremap <SPACE><CR> :nohlsearch<CR>
" nnoremap <LEADER>c :CocCommand<SPACE>
" nnoremap <LEADER>l :CocList<SPACE>
nnoremap <F4> :q!<CR>
nnoremap S :source $MYVIMRC<CR>
nnoremap sl :set splitright<CR>:vsplit<CR>
nnoremap sh :set nosplitright<CR>:vsplit<CR>
nnoremap sj :set splitbelow<CR>:split<CR>
nnoremap sk :set nosplitbelow<CR>:split<CR>
nnoremap <up> :res +2<CR>
nnoremap <down> :res -2<CR>
nnoremap <left> :vertical resize-2<CR>
nnoremap <right> :vertical resize+2<CR>
tnoremap <c-h> <c-\><c-N><c-w>h
tnoremap <c-l> <c-\><c-N><c-w>l
tnoremap <c-j> <c-\><c-N><c-w>j
tnoremap <c-k> <c-\><c-N><c-w>k
inoremap <c-h> <c-\><c-N><c-w>h
inoremap <c-j> <c-\><c-N><c-w>j
inoremap <c-k> <c-\><c-N><c-w>k
inoremap <c-l> <c-\><c-N><c-w>l
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
tnoremap <Esc> <C-\><C-n>

" To Turn One Line Into Title Caps, Make Every First Letter Of A Word Uppercase:
    nnoremap gug :s/\v<(.)(\w*)/\u\1\L\2/g<CR>:nohlsearch<CR>
" Compile document, be it groff/LaTeX/markdown/etc.
    nnoremap <LEADER><F5> :w! \| !compiler "<c-r>%"<CR>
" Open corresponding .pdf/.html or preview
    nnoremap <SPACE>o :!opout <c-r>%<CR><CR>
" Save file as sudo on files that require root permission
    cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
" 展开活动缓冲区所在目录
    cnoremap <expr> %% getcmdtype()==':'? expand('%:h').'/' : '%%'
" Perform dot commands over visual blocks:
    vnoremap . :normal .<CR>
vnoremap p "_dP | " keep what I am pasting

" Spell checking on the fly
inoremap <c-]> <c-g>u<Esc>[s1z=`]a<c-g>u
nnoremap <SPACE><SPACE> /<<>><CR>:set nohlsearch<CR>"_c4<right>
inoremap jk <Esc>/<<>><CR>:set nohlsearch<CR>"_c4<right>
inoremap kj <left>
"nnoremap <SPACE><SPACE> <Esc>/<<>><CR>:set nohlsearch<CR>v3l<c-g>
"" unmap function keys in selected mode
"    sunmap L
"    sunmap H
"    sunmap J
"    sunmap K
"    sunmap 9
" }}}
"{{{skeleton
if g:iswindows==1
    autocmd BufNewFile *.c   0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.c      | :normal G
    autocmd BufNewFile *.py	 0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.python | :normal G
    autocmd BufNewFile *.sh	 0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.sh     | :normal G
    autocmd BufNewFile *.tex 0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.tex    | :startinsert!
    autocmd BufNewFile *.awk 0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.awk    | :normal G
    autocmd BufNewFile *.r   0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.r      | :normal G
    autocmd BufNewFile *.rmd 0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.rmd    | :normal G
    autocmd BufNewFile *.sed 0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.sed    | :normal G
    autocmd BufNewFile *.go  0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.go     | :normal G
    autocmd BufNewFile *.pl  0r C://Users//Administrator//AppData//Local//nvim//skeleton//skeleton.perl   | :normal G
else
    autocmd BufNewFile *.c   0r ~/.config/nvim/skeleton/skeleton.c      | :normal G
    autocmd BufNewFile *.py	 0r ~/.config/nvim/skeleton/skeleton.python | :normal G
    autocmd BufNewFile *.sh	 0r ~/.config/nvim/skeleton/skeleton.sh     | :normal G
    autocmd BufNewFile *.tex 0r ~/.config/nvim/skeleton/skeleton.tex    | :startinsert!
    autocmd BufNewFile *.awk 0r ~/.config/nvim/skeleton/skeleton.awk    | :normal G
    autocmd BufNewFile *.r   0r ~/.config/nvim/skeleton/skeleton.r      | :normal G
    autocmd BufNewFile *.rmd 0r ~/.config/nvim/skeleton/skeleton.rmd    | :normal G
    autocmd BufNewFile *.sed 0r ~/.config/nvim/skeleton/skeleton.sed    | :normal G
    autocmd BufNewFile *.go  0r ~/.config/nvim/skeleton/skeleton.go     | :normal G
    autocmd BufNewFile *.pl  0r ~/.config/nvim/skeleton/skeleton.perl   | :normal G
endif
"}}}
"{{{ vim-plug
if g:iswindows==1
    call plug#begin('C:\Users\Administrator\AppData\Local\nvim\autoload\plugged')
else
    call plug#begin('~/.config/nvim/plugged')
endif
    Plug 'https://gitee.com/ProVim/coc.nvim.git', {'branch':'release'}
    Plug 'https://gitee.com/linuor/vim-surround.git'
    Plug 'https://gitee.com/yanzhongqian/nerdcommenter.git'
    Plug 'https://gitee.com/lovealone72/vim-markdown-toc.git', {'for': ['markdown']}
    Plug 'https://gitee.com/yaozhijin/vim-table-mode.git', { 'for': ['markdown']}
    "Plug 'https://gitee.com/zerosharp/indentLine.git'
    Plug 'https://gitee.com/zgpio/wildfire.vim.git'
    Plug 'https://gitee.com/zgpio/vim-fugitive.git'
    Plug 'https://gitee.com/oy456xd/vim-visual-multi.git'
    " vim-slime
    Plug 'https://gitee.com/tanloong/vim-slime'
    " :help AutoSave.nvim, automatically saving your work whenever you make changes to it
    " :ASToggle, :ASOn, :ASOff
    Plug 'https://gitee.com/tanloong/auto-save.nvim.git'
    " VimTex
    Plug 'https://gitee.com/mirrors/vimtex.git', {'for': ['tex']}
call plug#end()
"}}}
"nerdcommenter{{{
" 关闭默认键位
let g:NERDCreateDefaultMappings = 0
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 0
" Align line-wise comment delimiters flush left instead of following code indentation
" 注释符紧跟缩进的话， autopep8 会把注释行对齐成一行，取消注释时导致缩进错误
let g:NERDDefaultAlign = 'left'
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
map <SPACE>c <plug>NERDCommenterToggle
"}}}
"vim-table-mode{{{
" 设置table mode先导键为<SPACE>t
let g:table_mode_map_prefix = '<SPACE>t'
" 进入或退出 table 模式时给出提示
let g:table_mode_verbose = 1
let g:table_mode_corner = '|'
"}}}
"wildfire{{{
"Selects the next closest text object.
    map = <Plug>(wildfire-fuel)
"Selects the previous closest text object.
    vmap - <Plug>(wildfire-water)
    let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it", "iW", "i`"]
"}}}
"vim-surround{{{
xmap s <Plug>VSurround
"}}}
"coc.nvim{{{
highlight! link CocMenuSel PmenuSel
highlight! CocPumSearch ctermfg=yellow
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use to show documentation in preview window.
nnoremap <silent> <leader>s :call ShowDocumentation()<CR>
function! ShowDocumentation()
    if CocAction('hasProvider','hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('','in')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add (Neo)Vim's native statusline support.
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline=%<%f\ %h%m%{coc#status()}%{get(b:,'coc_current_function','')}%r%=%-14.(%l,%c%V%)\ %p%%

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')
nmap <F9> :call CocActionAsync('format')<CR>

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
"}}}
"coc-extensions"{{{
let g:coc_global_extensions = [
            \ 'coc-pyright',
            \ 'coc-actions',
            \ 'coc-git',
            \ 'coc-snippets',
            \ 'coc-r-lsp',
            \ 'coc-json',
            \ 'coc-webview',
            \ 'coc-markdown-preview-enhanced',
            \ 'coc-dictionary'
            \ ]
            " \ 'coc-sh',
            " \ 'coc-r-lsp',
            " \ 'coc-texlab',
            " \ 'coc-clangd',
"}}}
"coc-snippets{{{
" Use <C-o> for trigger snippet expand.
imap <c-o> <Plug>(coc-snippets-expand)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'
"}}}
"vim-markdown-toc{{{
let g:vmt_auto_update_on_save = 1
let g:vmt_dont_insert_fence = 0
"}}}
"vim-slime{{{
let g:slime_target = "x11"
let g:slime_no_mappings = 1
xmap <F5> <Plug>SlimeRegionSend
nmap <F5> :SlimeSendCurrentLine<CR>
nmap <c-c>v <Plug>SlimeConfig
let g:slime_preserve_curpos = 0
nmap ss <Plug>SlimeSendCell
"}}}
"auto-save{{{
lua << EOF

require('auto-save').setup(
    {
        enabled = true,
        -- execution_message = "AutoSave: saved",
        execution_message = {
            message = function() -- message to print on save
                return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")) end,
            dim = 0.18,
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
EOF
"}}}
"VimTeX{{{
" 0. 快捷键！！！:help vimtex-default-mappings
" 1. :help vimtex
" 2. [Blog] https://ejmastnak.github.io/tutorials/vim-latex/vimtex.html
" 3. 在 ~/.latexmkrc 中设置 $pdflatex='xelatex -shell-escape -synctex=1';
" 后，可以在 zathura 中用 Ctrl+左键 跳转到 vim 对应位置，
" 也可以在 vim 中用 \lv 跳转到 zathura 对应位置
" 4. 写入模式 `]]` 自动补全 `}` 或 `\end{<env>}`
let g:tex_flavor='latex' | " set filetype to 'tex' in empty latex file
if g:iswindows==1
    let g:vimtex_view_general_viewer = 'SumatraPDF'
else
    let g:vimtex_view_method = 'zathura'
endif
let g:vimtex_quickfix_mode = 0
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_matchparen_enabled = 0
let g:vimtex_indent_enabled = 0
let g:vimtex_imaps_enabled = 0
let g:vimtex_compiler_method='latexmk'
let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \   '-shell-escape',
    \ ],
    \}
" :help vimtex-toc
let g:vimtex_toc_config = {
    \ 'fold_enable': 1,
    \ 'split_pos': 'vert leftabove',
    \ 'indent_levels': 1,
    \ 'show_numbers': 0,
    \ }
let g:vimtex_syntax_conceal = {
    \ 'accents': 1,
    \ 'ligatures': 0,
    \ 'cites': 1,
    \ 'fancy': 1,
    \ 'greek': 1,
    \ 'math_bounds': 0,
    \ 'math_delimiters': 1,
    \ 'math_fracs': 1,
    \ 'math_super_sub': 1,
    \ 'math_symbols': 1,
    \ 'sections': 0,
    \ 'styles': 1,
    \}
nnoremap tt :VimtexTocToggle<CR><c-w>h
"}}}
