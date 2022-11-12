#!/usr/bin/env lua
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
vim.keymap.set('n', 'tt', '<Cmd>VimtexTocToggle<CR><c-w>h')

