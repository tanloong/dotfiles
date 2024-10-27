" my filetype file
if exists("did_load_filetypes")
  finish
endif
let s:did_load_filetypes = 1

augroup filetypedetect
  au! BufRead,BufNewFile *.typ,*.typst		setfiletype typst
augroup END
