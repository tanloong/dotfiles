" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.typ,*.typst		setfiletype typst
  au! BufRead,BufNewFile *interlaced*.txt	setfiletype interlaced
augroup END
