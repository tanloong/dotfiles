func! DT#wczh() range
	let save = @z
	silent exec 'normal! gv"zy'
	let text = @z
	let @z = save
	silent exec 'normal! gv'
	let cc = 0
	for char in split(text, '\zs')
		if char2nr(char) >= 0x4e00 && char2nr(char) <= 0x9fa5
			let cc += 1
		endif
	endfor
	echo "Count of Chinese charasters is:"
	echo cc
endfunc

" https://stackoverflow.com/questions/11858927/preventing-trailing-whitespace-when-using-vim-abbreviations
func! DT#Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
