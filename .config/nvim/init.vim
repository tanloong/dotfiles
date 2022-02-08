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
set fdm=marker
set mouse=a                                "允许用鼠标操作"
set nrformats=                             "把所有数字当成 10 进制，不管是不是以 0 开头"
set scrolloff=5                            "光标垂直移动时保持顶端/底端显示5行"
set ignorecase
set smartcase                              "当搜索的字符含大写字母，暂时保持case sensitive"
set wrap                                   "内容超出一行时自动换行"
set wrapscan                               "环形搜索，nowrapscan"
set linebreak                              "换行时不要从单词中间换行"
set noswapfile                             "不要产生交换文件"
set laststatus=2                           "show filename below"
set clipboard^=unnamed,unnamedplus"        "复制到系统寄存器(*, +)"
set dictionary+=$HOME/projects/linguistics-notes/dict
set wildignore+=*aux,*toc,*out
" colorscheme solarized
exec "nohlsearch"

if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also https://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif

" 打开文件时跳到上次的位置
    au BufReadPost * if line("'\"") > 1 && line("'\'") <= line("$") | exe "normal! g'\""| endif

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
nnoremap R :write<CR>:edit!<CR>
" 保存修改，并重新从硬盘读取此文件
nnoremap M J
nnoremap sl :set splitright<CR>:vsplit<CR>
nnoremap sh :set nosplitright<CR>:vsplit<CR>
nnoremap g9 g$
nnoremap ga :tabe<CR>:term lazygit<CR>i
nnoremap > >>
nnoremap < <<
nnoremap @@ @q
nnoremap <c-j> 5<c-e>
nnoremap <c-k> 5<c-y>
nnoremap <c-y> :res +5<CR>
nnoremap <c-e> :res -5<CR>
nnoremap <c-c> :e $HOME/.config/nvim/init.vim<CR>
nnoremap <c-m> :e $HOME/document/memorandum/Linux.md<CR>
nnoremap <c-p> :%s///g<Left><Left><Left>
nnoremap <up> <c-y>
nnoremap <down> <c-e>
nnoremap <left> :vertical resize-5<CR>
nnoremap <right> :vertical resize+5<CR>
nnoremap <SPACE>a ggVG
nnoremap <SPACE>s :w<CR>
nnoremap <SPACE>w :x<CR>
nnoremap <SPACE>q :q!<CR>
nnoremap <SPACE>e :set spell!<CR>
nnoremap <SPACE><CR> :nohlsearch<CR>
nnoremap <LEADER>c :CocCommand<SPACE>
nnoremap <LEADER>l :CocList<SPACE>

" To Turn One Line Into Title Caps, Make Every First Letter Of A Word Uppercase:
    nnoremap gug :s/\v<(.)(\w*)/\u\1\L\2/g<CR>:nohlsearch<CR>
" Compile document, be it groff/LaTeX/markdown/etc.
    nnoremap <F5> :w! \| !compiler "<c-r>%"<CR>
" Open corresponding .pdf/.html or preview
    nnoremap <SPACE>o :!opout <c-r>%<CR><CR>
" Save file as sudo on files that require root permission
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
" 展开活动缓冲区所在目录
    cnoremap <expr> %% getcmdtype()==':'? expand('%:h').'/' : '%%'
" Perform dot commands over visual blocks:
    vnoremap . :normal .<CR>
" 补全路径
    inoremap <c-p> <c-x><c-f>
" 在补全建议之间移动
    inoremap <c-j> <c-n>
    inoremap <c-k> <c-p>
    cnoremap <c-j> <c-n>
    cnoremap <c-k> <c-p>

inoremap ,e <Esc>la
nnoremap <SPACE><SPACE> <Esc>/<<>><CR>:set nohlsearch<CR>v3l<c-g>
inoremap ,s ''<Esc>i
inoremap ,d ""<Esc>i
inoremap ,f =
inoremap ,z ,
"inoremap < <><ESC>i
"inoremap ( ()<ESC>i
" inoremap () ()<Esc>i
" inoremap [ []<ESC>i
" inoremap {} {}<Esc>i
" inoremap {{ {{{<CR>}}}<Esc>O

vnoremap <c-p> :s///g<Left><Left><Left>
" unmap function keys in selected mode
    sunmap L
    sunmap H
    sunmap J
    sunmap K
    sunmap 9

autocmd FileType markdown,rmd inoremap ,a **** <<>><Esc>6hi
autocmd FileType markdown,rmd inoremap ,c ``<SPACE><<>><Esc>F`i
autocmd FileType markdown,rmd inoremap ,i ** <<>><Esc>F*i
autocmd FileType markdown,rmd inoremap ,l [](<<>>)<Esc>F[a
autocmd Filetype markdown,rmd inoremap ,g ~~~~ <<>><Esc>F~hi
autocmd FileType markdown,rmd inoremap ,p ![](<<>>)<Esc>F[a
autocmd FileType markdown,rmd inoremap ,m -<SPACE>[<SPACE>]<SPACE>
autocmd FileType markdown,rmd inoremap ,n ---<CR><CR>
autocmd FileType markdown,rmd inoremap ,1 #<SPACE>
autocmd FileType markdown,rmd inoremap ,2 ##<SPACE>
autocmd FileType markdown,rmd inoremap ,3 ###<SPACE>
autocmd FileType markdown,rmd inoremap ,4 ####<SPACE>
autocmd FileType markdown,rmd inoremap ,5 #####<SPACE>
autocmd FileType markdown,rmd inoremap ,6 ######<SPACE>
autocmd FileType markdown,rmd inoremap ,` ```<CR><<>><CR>```<CR><CR><<>><Esc>4ka
autocmd FileType markdown,rmd nnoremap # /###<SPACE>

" set filetype to 'tex' in empty latex file
    let g:tex_flavor='latex'
autocmd Filetype tex inoremap ,` \begin{lstlisting}<CR><CR>\end{lstlisting}<Up>
autocmd Filetype tex inoremap ,l \href{}{<<>>}<<>><Esc>Ffla
autocmd Filetype tex inoremap ,bf \begin{frame}<CR>\end{frame}<Esc>O
autocmd Filetype tex inoremap ,bd \begin{compactdesc}<CR>\item[<<>>]<SPACE><<>><Esc>yy4p3jo\end{compactdesc}<Esc>5k0f<v3l<c-g>
autocmd Filetype tex inoremap ,bi \begin{compactitem}<CR>\item<SPACE><<>><Esc>yy4p3jo\end{compactitem}<Esc>5k0f<v3l<c-g>
autocmd Filetype tex inoremap ,be \begin{compactenum}<CR>\item<SPACE><<>><Esc>yy4p3jo\end{compactenum}<Esc>5k0f<v3l<c-g>
autocmd Filetype tex inoremap ,bb \begin{<<>>}<CR>\end{<<>>}<Esc>k$hv3h<c-g>
autocmd Filetype tex inoremap ,ipa \textipa{[<<>>]}<SPACE><<>><Esc>7hv3h<c-g>
autocmd Filetype tex inoremap ,, \{<<>>}<Esc>5hi
autocmd Filetype tex inoremap ,a \textbf{}<Esc>i
autocmd Filetype tex inoremap ,bx <CR>\mbox{}<CR>
autocmd Filetype tex inoremap ,bc \begin{cases}<CR>\end{cases}<Esc>O
autocmd Filetype tex inoremap ,ii \textit{}<Esc>i
autocmd Filetype tex inoremap ,u \uline{}<Esc>i
autocmd Filetype tex inoremap ,n \emph{}<Esc>i
autocmd Filetype tex inoremap ,m \item<SPACE>
autocmd Filetype tex inoremap ,d ``''<SPACE><<>><Esc>6hi
autocmd Filetype tex inoremap ,s `'<SPACE><<>><Esc>5hi
autocmd Filetype tex inoremap ,t \citet{<<>>}<Esc>4hv3l<c-g>
autocmd Filetype tex inoremap ,p \citep{<<>>}<Esc>4hv3l<c-g>
autocmd Filetype tex inoremap ,k \usepackage{}<Esc>i
autocmd Filetype tex inoremap ,f \footnote{}<Esc>i
autocmd Filetype tex inoremap ,1 \part{<<>>}<CR>\label{prt:<<>>}<Esc>k$hv3h<c-g>
autocmd Filetype tex inoremap ,2 \chapter{<<>>}<CR>\label{cha:<<>>}<Esc>k$hv3h<c-g>
autocmd Filetype tex inoremap ,3 \section{<<>>}<CR>\label{sec:<<>>}<Esc>k$hv3h<c-g>
autocmd Filetype tex inoremap ,4 \subsection{<<>>}<CR>\label{ssec:<<>>}<Esc>k$hv3h<c-g>
autocmd Filetype tex inoremap ,5 \subsubsection{<<>>}<CR>\label{sssec:<<>>}<Esc>k$hv3h<c-g>
autocmd Filetype tex inoremap ,6 \paragraph{<<>>}<CR>\label{par:<<>>}<Esc>k$hv3h<c-g>
autocmd Filetype tex inoremap ,7 \subparagraph{<<>>}<CR>\label{spar:<<>>}<Esc>k$hv3h<c-g>

autocmd Filetype c inoremap } {<CR>}<Esc>O
autocmd Filetype c inoremap `if if () {<CR>}<Esc>O<<>><Esc>kF)i
autocmd Filetype c inoremap `else else {<CR>}<Esc>O
autocmd Filetype c inoremap `for for () {<CR>}<Esc>O<<>><Esc>kF)i
autocmd Filetype c inoremap `main main ()<CR>{<CR>}<Esc>O
autocmd Filetype c inoremap `p printf("");<ESC>0f"a

autocmd Filetype r iunmap ,f
autocmd Filetype r inoremap ,f <-

autocmd Filetype sh inoremap ,c ``<Esc>i
autocmd Filetype sh inoremap ,1 !
autocmd Filetype sh inoremap ,2 @
autocmd Filetype sh inoremap ,3 #
autocmd Filetype sh inoremap ,4 $
autocmd Filetype sh inoremap ,8 *
autocmd Filetype sh inoremap ,( $()<Esc>i
autocmd Filetype sh inoremap ,{ ${}<Esc>i
autocmd Filetype sh inoremap ,[ $[]<Esc>i
autocmd Filetype sh inoremap ," "$"<Esc>i
autocmd Filetype sh inoremap } {<CR>}<Esc>O

autocmd Filetype java inoremap `if if () {<CR>}<Esc>O<<>><Esc>kF)i
autocmd Filetype java inoremap `else else {<CR>}<Esc>O
autocmd Filetype java inoremap `for for () {<CR>}<Esc>O<<>><Esc>kF)i
autocmd Filetype java inoremap `main main ()<CR>{<CR>}<Esc>O
autocmd Filetype java inoremap `p System.out.printf("");<ESC>0f"a
autocmd Filetype java inoremap `read System.in.read();
autocmd Filetype java inoremap } {<CR>}<Esc>O

autocmd Filetype go inoremap } {<CR>}<Esc>O

autocmd Filetype awk inoremap ,4 $

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
    autocmd VimLeave *.tex !texclear %
" Automatically deletes all trailing whitespace and newlines at end of file on save.
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\n\+\%$//e

nnoremap <c-h> :call AddHead()<CR>
function! AddHead()
if &filetype == 'python'
    call append(0, "#!/usr/bin/env python3")
    call append(1, "# -*- coding=utf-8 -*-")
elseif &filetype == 'sh'
    call append(0, "#!/usr/bin/env bash")
    call append(1, "set -euo pipefail")
    call append(2, "IFS=$'\\n\\t'")
elseif &filetype == 'tex'
    call append(0, '\documentclass[a4paper]{<<>>}')
    call append(1, '\usepackage{xeCJK}')
    call append(2, '\usepackage{fontspec,indentfirst}')
    call append(3, '\usepackage{subfigure}')
    call append(4, '\usepackage{paralist} % 压缩项目列表')
    call append(5, '\usepackage[normalem]{ulem} % 优化 \emph 命令')
    call append(6, '\usepackage[left=3.18cm,right=3.18cm,top=2.54cm,bottom=2.54cm]{geometry}')
    call append(7, '\usepackage[tone]{tipa} % 输入 IPA 音标')
    call append(8, '\setCJKmainfont{Source Han Serif CN Medium}')
    call append(9, '\setmainfont{Times New Roman}')
    call append(10, '\linespread{1.2}')
    call append(11, '\begin{document}')
    call append(12, '<<>>')
    call append(13, '\end{document}')
elseif &filetype == 'go'
    call append(0, 'package <<>>')
    call append(1, 'import "fmt"')
elseif &filetype == 'rmd'
    call append(0, "---")
    call append(1, "output: pdf_document")
    call append(2, "---")
elseif &filetype == 'awk'
    call append(0, "#!/usr/bin/env awk -f")
elseif &filetype == 'sed'
    call append(0, "#!/usr/bin/env sed -f")
elseif &filetype == 'c'
    call append(0, "#include <stdio.h>")
elseif &filetype == 'r'
    call append(0, "#!/usr/bin/env Rscript")
elseif &filetype == 'perl'
    call append(0, "#!/usr/bin/env perl")
endif
endfunction

" ===
" === vim-plug
" ===
call plug#begin('~/.config/nvim/plugged')
    " Plug 'https://gitee.com/bon-ami/vim-lsp.git'
    " Plug 'https://gitee.com/cocosleep/vim-latex-live-preview.git', { 'for': 'tex' }
    " Plug 'https://gitee.com/cocosleep/vim-lsp-settings.git'
    " Plug 'https://gitee.com/mirrors_matklad/nvim-lsp.git'
    " Plug 'https://gitee.com/mirrors_mattn/asyncomplete-lsp.vim.git'
    " Plug 'https://gitee.com/mirrors_mattn/asyncomplete.vim.git'
    " Plug 'https://gitee.com/tanloong/async.vim.git'
    " Plug 'https://gitee.com/yaowenqiang/ultisnips.git'
    " Plug 'lervag/vimtex', {'for': ['tex']}
    Plug 'https://gitee.com/yaozhijin/vim-snippets.git'
    Plug 'https://gitee.com/linuor/coc.nvim.git', {'branch': 'release'}
    Plug 'https://gitee.com/linuor/vim-surround.git'
    Plug 'https://gitee.com/yanzhongqian/nerdcommenter.git'
    " markdown
    Plug 'https://gitee.com/yaozhijin/markdown-preview.nvim.git', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    Plug 'https://gitee.com/lovealone72/vim-markdown-toc.git', {'for': ['markdown']}
    Plug 'https://gitee.com/yaozhijin/vim-table-mode.git', { 'for': ['markdown']}
    Plug 'https://gitee.com/zerosharp/indentLine.git'
    Plug 'https://gitee.com/zgpio/wildfire.vim.git'
    Plug 'https://gitee.com/zgpio/vim-fugitive.git'
    " auto format
    Plug 'https://gitee.com/bidaya0/vim-maktaba.git'
    Plug 'https://gitee.com/bidaya0/vim-codefmt.git'
    Plug 'https://gitee.com/bidaya0/vim-glaive.git'
    " auto pair
    Plug 'https://gitee.com/yaozhijin/auto-pairs.git'
    Plug 'https://gitee.com/oy456xd/vim-visual-multi.git'
call plug#end()

" ===
" === markdown-preview配置
" ===
" specify browser to open preview page
" let g:mkdp_browser = '/usr/bin/chromium'
" let g:mkdp_auto_start = 0
" let g:mkdp_auto_close = 0
" let g:mkdp_refresh_slow = 1
" let g:mkdp_open_to_the_world = 1
" let g:mkdp_port = 8080
" let g:mkdp_echo_preview_url = 1

" ===
" === nerdcommenter配置
" ===
" 关闭默认键位
let g:NERDCreateDefaultMappings = 0
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
" 注释符紧跟缩进的话， autopep8 会把注释行对齐成一行，取消注释时导致缩进错误
let g:NERDDefaultAlign = 'left'
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
map <SPACE>c <plug>NERDCommenterToggle

" ===
" === vim-table-mode配置
" ===
" 设置table mode先导键为<SPACE>t
let g:table_mode_map_prefix = '<SPACE>t'
" 进入或退出 table 模式时给出提示
let g:table_mode_verbose = 1
let g:table_mode_corner = '|'


" ===
" === wildfire
" ===
"Selects the next closest text object.
    map = <Plug>(wildfire-fuel)
"Selects the previous closest text object.
    vmap - <Plug>(wildfire-water)
    let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it", "iW", "i`"]

" ===
" === vim-surround
" ===
xmap s <Plug>VSurround

" ===
" === coc.nvim
" ===
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
" Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)
    " xmap <leader>f  <Plug>(coc-format-selected)
    " nmap <leader>f  <Plug>(coc-format-selected)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)
" use <cr> to confirm completion
" <cr> could be remapped by other vim plugins, try `:verbose imap <CR>`
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

let g:coc_global_extensions = [
            \ 'coc-pyright',
            \ 'coc-json',
            \ 'coc-actions',
            \ 'coc-clangd',
            \ 'coc-snippets',
            \ 'coc-git',
            \ 'coc-sh',
            \ 'coc-translator',
            \ 'coc-texlab',
            \ 'coc-dictionary']

" ===
" === coc-texlab
" ===
" autocmd FileType tex nnoremap <LEADER>b :CocCommand latex.Build<CR>
" autocmd BufWritePost *tex :CocCommand latex.Build

" ===
" === coc-snippets
" ===
" Use <C-o> for trigger snippet expand.
imap <c-o> <Plug>(coc-snippets-expand)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'


" ===
" === coc-snippets
" ===
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ===
" === coc-translator
" ===
" popup
nmap <LEADER>t <Plug>(coc-translator-p)
vmap <LEADER>t <Plug>(coc-translator-pv)
" echo
nmap tt <Plug>(coc-translator-e)
vmap tt <Plug>(coc-translator-ev)
" replace
nmap <Leader>r <Plug>(coc-translator-r)
vmap <Leader>r <Plug>(coc-translator-rv)

" ===
" === indentLine
" ===
" indentLine will overwrite 'conceal' color with grey by default.
let g:indentLine_setColors = 1
let g:indentLine_char = '¦'
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
":IndentLinesToggle toggles lines on and off.
" let g:indentLine_conceallevel=0
let g:indentLine_concealcursor=''


" ===
" === vim-codefmt
" ===
" augroup autoformat_settings
"   autocmd FileType bzl AutoFormatBuffer buildifier
"   autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
"   autocmd FileType dart AutoFormatBuffer dartfmt
"   autocmd FileType go AutoFormatBuffer gofmt
"   autocmd FileType gn AutoFormatBuffer gn
"   autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
"   autocmd FileType java AutoFormatBuffer google-java-format
  " Alternative: autocmd FileType python AutoFormatBuffer yapf
"   autocmd FileType python AutoFormatBuffer black
"   autocmd FileType rust AutoFormatBuffer rustfmt
"   autocmd FileType vue AutoFormatBuffer prettier
" augroup END
augroup autoformat_settings
    autocmd FileType python nnoremap <LEADER>b :FormatCode<Space>black<CR>:w<CR>
    autocmd FileType python nnoremap <LEADER>l :FormatLine<Space>black<CR>:w<CR>
augroup END

" ===
" === vim-markdown-toc
" ===
let g:vmt_auto_update_on_save = 1
let g:vmt_dont_insert_fence = 0
