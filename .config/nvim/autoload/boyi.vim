func! boyi#ths2sql()
" 2025-12-11 14:30
"
" 输入文件是同花顺动态板块导出的昨日竞价今日上板票
" 表头为: 证券代码, 证券名称, 首次涨停时间, 最高, 现价
" 这个脚本用来转换为SQL语句，复制SQL粘贴到曲线程序调试窗口
"
1 d | "delete header"
$ put _ | "append an empty line"
gl /^/ t $
$ | normal! {
1,.-1 s/\v^\a+([^\t]+)\s*[^\t]+\s*([^\t]+)\t([^\t]+).*/insert into zt (证券代码, 进场日期, 涨停时间, 涨停价) values ('\1', '20251210', unixepoch( date ( 'now' , 'localtime' ) || ' ' || '\2' || '+08:00' ) , \3 ) ;/
put _
put ='insert into zt (证券代码, 进场日期, 涨停时间, 涨停价) values'
.+1,$ s/\v^\a+([^\t]+)\s*[^\t]+\s*([^\t]+)\t([^\t]+).*/('\1', '20251210', unixepoch( date ( 'now' , 'localtime' ) || ' ' || '\2' || '+08:00' ) , \3 )/
normal! {
.+1, $ s/\v\n\ze\s*\S/, /
s/$/;
normal! {
. d
normal! kJ
endfunc
