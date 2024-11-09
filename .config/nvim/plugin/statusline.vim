" 缓冲区号 文件名 文件类型 修改 帮助 只读 编码 换行符 BOM ======== 位置 行数 百分比位置
set statusline=[%n]\ %<%f\ %y\ %{&modified?'[+]':&modifiable\|\|&ft=~'^\\vhelp\|qf$'?'':'[-]'}%h%r%{&fenc=='utf-8'\|\|&fenc==''?'':'['.&fenc.']'}%{&ff=='unix'?'':'['.&ff.']'}%{&bomb?'[BOM]':''}%{&eol?'':'[noeol]'}%{&diff?'[diff]':''}%=\ \ \ \ \ %-14.(%l,%c%V%)\ %LL\ %P
