filetype plugin indent on
syntax enable
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
set mouse= | "不允许用鼠标操作
set nrformats= | "把所有数字当成 10 进制，不管是不是以 0 开头
set scrolloff=5 | "光标垂直移动时保持顶端/底端显示5行
set ignorecase
set smartcase | "当搜索的字符含大写字母，暂时保持case sensitive
set wrap | "内容超出一行时自动换行
set wrapscan | "环形搜索，nowrapscan
set linebreak | "不要从单词中间换行
set noswapfile | "不要产生交换文件
set laststatus=2 | "show filename below
set clipboard^=unnamed,unnamedplus" | "复制到系统寄存器(*, +)
set dictionary+=$HOME/projects/linguistics-notes/dict
set dictionary+=$HOME/.local/share/BNC-40thousand.txt
set wildignore+=*aux,*toc,*out
set matchpairs=<:>,(:),{:},[:]
set path+=**
set spelllang=en,cjk
set complete=.,w,b,u,t,i,k
set guicursor=i-v:ver1,a:blinkon0
exec "nohlsearch"
highlight MatchParen cterm=none ctermbg=none ctermfg=green


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
nnoremap g9 g$
nnoremap ga :tabe<CR>:term lazygit<CR>i
nnoremap > >>
nnoremap < <<
nnoremap @@ @q
nnoremap <c-p> :%s///g<Left><Left>
vnoremap <c-p> :s///g<Left><Left>
nnoremap <SPACE>a ggVG
nnoremap <SPACE>s :w<CR>
nnoremap <SPACE>w :x<CR>
nnoremap <SPACE>q :q!<CR>
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
    nnoremap <F5> :w! \| !compiler "<c-r>%"<CR>
" Open corresponding .pdf/.html or preview
    nnoremap <SPACE>o :!opout <c-r>%<CR><CR>
" Save file as sudo on files that require root permission
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
" 展开活动缓冲区所在目录
    cnoremap <expr> %% getcmdtype()==':'? expand('%:h').'/' : '%%'
" Perform dot commands over visual blocks:
    vnoremap . :normal .<CR>

" Spell checking on the fly
inoremap <c-]> <c-g>u<Esc>[s1z=`]a<c-g>u
inoremap jk <right>
inoremap kj <left>
nnoremap <SPACE><SPACE> <Esc>/<<>><CR>:set nohlsearch<CR>v3l<c-g>

" unmap function keys in selected mode
    sunmap L
    sunmap H
    sunmap J
    sunmap K
    sunmap 9

packadd! matchit
let b:batch_words='begin:end'

" set filetype to 'tex' in empty latex file
    let g:tex_flavor='latex'

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
    autocmd VimLeave *.tex !texclear %
" Automatically deletes all trailing whitespace and newlines at end of file on save.
    " autocmd BufWritePre * let currPos = getpos(".")
    " autocmd BufWritePre * %s/\s\+$//e
    " autocmd BufWritePre * %s/\n\+\%$//e
    " autocmd BufWritePre * cal cursor(currPos[1], currPos[2])


" {{{
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
" }}}

" === vim-plug begin
" {{{
call plug#begin('~/.config/nvim/plugged')
    " Plug 'https://gitee.com/yaowenqiang/ultisnips.git'
    " Plug 'https://gitee.com/yaozhijin/vim-snippets.git'
    Plug 'https://gitee.com/zgpio/coc.nvim.git', {'branch':'release'}
    Plug 'https://gitee.com/linuor/vim-surround.git'
    Plug 'https://gitee.com/yanzhongqian/nerdcommenter.git'
    " markdown
    Plug 'https://gitee.com/tanloong/markdown-preview.nvim.git', { 'do': 'cd app && yarn install'  }
    Plug 'https://gitee.com/lovealone72/vim-markdown-toc.git', {'for': ['markdown']}
    Plug 'https://gitee.com/yaozhijin/vim-table-mode.git', { 'for': ['markdown']}
    Plug 'https://gitee.com/zerosharp/indentLine.git'
    Plug 'https://gitee.com/zgpio/wildfire.vim.git'
    Plug 'https://gitee.com/zgpio/vim-fugitive.git'
    " auto pair
    Plug 'https://gitee.com/yaozhijin/auto-pairs.git'
    Plug 'https://gitee.com/oy456xd/vim-visual-multi.git'
    " vim-slime
    Plug 'https://gitee.com/tanloong/vim-slime'
    " :help AutoSave.nvim, automatically saving your work whenever you make changes to it
    " :ASToggle, :ASOn, :ASOff
    Plug 'https://gitee.com/giteeguangwei/AutoSave.nvim.git'
    " VimTex
    Plug 'https://gitee.com/mirrors/vimtex.git', {'for': ['tex']}
call plug#end() 
" }}}
" === vim-plug end

" === markdown-preview begin
" {{{
" specify browser to open preview page
" let g:mkdp_browser = '/usr/bin/chromium'
" let g:mkdp_auto_start = 0
" let g:mkdp_auto_close = 0
" let g:mkdp_refresh_slow = 1
" let g:mkdp_open_to_the_world = 1
" let g:mkdp_port = 8080
" let g:mkdp_echo_preview_url = 1
" }}}
" === markdown-preview end

" === nerdcommenter begin
" {{{
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
" }}}
" === nerdcommenter end

" === vim-table-mode begin
" {{{
" 设置table mode先导键为<SPACE>t
let g:table_mode_map_prefix = '<SPACE>t'
" 进入或退出 table 模式时给出提示
let g:table_mode_verbose = 1
let g:table_mode_corner = '|'
" }}}
" === vim-table-mode end

" === wildfire begin
" {{{
"Selects the next closest text object.
    map = <Plug>(wildfire-fuel)
"Selects the previous closest text object.
    vmap - <Plug>(wildfire-water)
    let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it", "iW", "i`"] 
" }}}
" === wildfire end

" === vim-surround begin
xmap s <Plug>VSurround
" === vim-surround end

" === coc.nvim begin
" {{{
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
" Format selected lines
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Format current buffer
nmap <F9>  <Plug>(coc-format)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Use <cr> to confirm completion
" <cr> could be remapped by other vim plugins, try `:verbose imap <CR>`
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" Use to show documentation in preview window.
nnoremap <silent> <leader>s :call ShowDocumentation()<CR>
function! ShowDocumentation()
    if CocAction('hasProvider','hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('','in')
    endif
endfunction

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

let g:coc_global_extensions = [
            \ 'coc-pyright',
            \ 'coc-actions',
            \ 'coc-git',
            \ 'coc-snippets',
            \ 'coc-r-lsp',
            \ 'coc-json',
            \ 'coc-dictionary']
            " \ 'coc-sh',
            " \ 'coc-r-lsp',
            " \ 'coc-texlab',
            " \ 'coc-clangd',
" }}}
" === coc.nvim end

" === coc-texlab begin
" {{{
" autocmd FileType tex nnoremap <LEADER>b :CocCommand latex.Build<CR>
" autocmd BufWritePost *tex :CocCommand latex.Build
" }}}
" === coc-texlab end

" === coc-snippets begin
" {{{
" Use <C-o> for trigger snippet expand.
imap <c-o> <Plug>(coc-snippets-expand)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = 'jk'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = 'kj'

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
" }}}
" === coc-snippets end

" === ultisnips begin
" {{{
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
" let g:UltiSnipsExpandTrigger="<c-o>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" let g:UltiSnipsSnippetDirectories=["ultisnips"]
" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"
" }}}
" === ultisnips end

" === indentLine begin
" {{{
" indentLine will overwrite 'conceal' color with grey by default.
let g:indentLine_setColors = 1
let g:indentLine_char = '¦'
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
":IndentLinesToggle toggles lines on and off.
" let g:indentLine_conceallevel=0
let g:indentLine_concealcursor=''
" }}}
" === indentLine begin

" === vim-codefmt begin
" {{{
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
" augroup autoformat_settings
"     autocmd FileType python nnoremap <LEADER>b :FormatCode<Space>black<CR>:w<CR>
"     autocmd FileType python nnoremap <LEADER>l :FormatLine<Space>black<CR>:w<CR>
" augroup END
" }}}
" === vim-codefmt end

" === vim-markdown-toc begin
let g:vmt_auto_update_on_save = 1
let g:vmt_dont_insert_fence = 0
" === vim-markdown-toc end

" === vim-slime begin
" {{{
let g:slime_target = "x11"
let g:slime_no_mappings = 1
xmap <F5> <Plug>SlimeRegionSend
nmap <F5> :SlimeSendCurrentLine<CR>
nmap <c-c>v <Plug>SlimeConfig
let g:slime_preserve_curpos = 0
nmap ss <Plug>SlimeSendCell
" }}}
" === vim-slime end

" === AutoSave begin
" {{{
lua << EOF
local autosave = require("autosave")

autosave.setup(
    {
        enabled = true,
        -- execution_message = "AutoSave: saved",
        execution_message = function ()
          return "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S") end,
        events = {"InsertLeave", "TextChanged"},
        conditions = {
            exists = true,
            filename_is_not = {},
            filetype_is_not = {},
            modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 0,
        debounce_delay = 135
    }
)
EOF
" }}}
" === AutoSave end

" === VimTeX begin
" {{{
" 0. 快捷键！！！:help vimtex-default-mappings
" 1. :help vimtex
" 2. [Blog] https://ejmastnak.github.io/tutorials/vim-latex/vimtex.html
" 3. 在 ~/.latexmkrc 中设置 $pdflatex='xelatex -shell-escape -synctex=1';
" 后，可以在 zathura 中用 Ctrl+左键 跳转到 vim 对应位置，
" 也可以在 vim 中用 \lv 跳转到 zathura 对应位置
" 4. 写入模式 `]]` 自动补全 `}` 或 `\end{<env>}`
let g:vimtex_view_method = 'zathura'
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
nnoremap tt :VimtexTocToggle<CR><c-w>h
" }}}
" === VimTeX end

" === autopairs begin
let g:AutoPairs={'(':')', '[':']', '{':'}',"'":"'",'"':'"'}
" === autopairs end

