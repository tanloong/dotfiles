function! boyi#get_yestraday(fmt = "%Y%m%d")
  " 返回早于今天的第一个工作日
  let l:cand = localtime() - 86400
  " %w: day of week (0..6); 0 is Sunday
  let l:weekday = strftime("%w", l:cand)
  while l:weekday == "0" || l:weekday == "6"
    let l:cand -= 86400
    let l:weekday = strftime("%w", l:cand)
  endwhile
  return strftime(a:fmt, l:cand)
endfunction

func! boyi#ths2sql()
" 2025-12-11 14:30
"
" 输入文件是同花顺动态板块导出的昨日竞价今日上板票
" 表头为: 证券代码, 证券名称, 首次涨停时间, 最高, 现价
" 这个脚本用来转换为SQL语句，复制SQL粘贴到曲线程序调试窗口
"
  :%delete _
  :put +
  let l:bid_date = input("进场日期:", boyi#get_yestraday()) " 进场日期，填上一交易日
  gl /^\s*$/ d | "delete empty lines
  %s/^\s\+//e | "delete leading whitespaces
  v /\v^%(代码|\u\u\d{6})>/ d | "delete irrelevant lines
  $ put _ | "append an empty line
  gl /^/ t $ | "copy table below
  0;/^代码\>
  . d | "delete the header of the copied table
  1,1/^$/ t 0

  1/^$/+1,1/^$//^$/-1 s/\v^\a+([^\t]+)\s*[^\t]+\s*([^\t]+)\s*([^\t]+).*/insert or ignore into zt (证券代码, 进场日期, 涨停时间, 涨停价) values ('\1', '__BID_DATE__', unixepoch( date ( 'now' , 'localtime' ) || ' ' || '\2' || '+08:00' ) , \3 ) ;/
  1,1/^$/-1 s/\v^\a+([^\t]+)\s*[^\t]+\s*([^\t]+)\s*([^\t]+).*/('\1', '__BID_DATE__', unixepoch( date ( 'now' , 'localtime' ) || ' ' || '\2' || '+08:00' ) , \3 )/
  1,1/^$/-1 s/\v\n\ze\s*\S/, /e
  1 s/$/;
  0 put ='insert or ignore into zt (证券代码, 进场日期, 涨停时间, 涨停价) values'
  1,1/^$/-1 j

  %s/__BID_DATE__/\=l:bid_date/g
  $ ?^$? put=strftime('%Y%m%d', localtime()) . ' 昨日竞价今日上板票，开板后仍按涨停价计算主扶页面曲线:'

  call setcursorcharpos(1, 1)
  call setreg("+", getline(1))
endfunc


" 产品名称标准化函数
function! boyi#normsim(name) abort
    " 处理空值或无效输入
    if empty(a:name) || a:name ==# 'nan' || a:name ==# 'NaN'
        return v:null
    endif

    let normalized = substitute(a:name, '博弈', '', 'g')
    let normalized = substitute(normalized, '-号', '一号', 'g')
    let normalized = trim(normalized)

    " 处理移除后为空的情况
    if empty(normalized)
        return v:null
    endif

    " 定义匹配规则
    if normalized =~# '扶'
        return '扶'
    endif

    if normalized =~# '共'
        return '共赢'
    endif

    if normalized =~# '渭'
        if normalized =~# '十六\|16'
            return '渭16'
        elseif normalized =~# '11\|十一'
            return '渭11'
        elseif normalized =~# '12\|十二'
            return '渭12'
        elseif normalized =~# '五\|5'
            return '渭五'
        elseif normalized =~# '八\|8'
            return '渭八'
        elseif normalized =~# '六\|6'
            return '渭六'
        elseif normalized =~# '三\|3'
            return '渭三'
        endif
    endif

    if normalized =~# '博'
        if normalized =~# '十三\|13'
            return '博13'
        elseif normalized =~# '十五\|15'
            return '博15'
        elseif normalized =~# '三\|3'
            return '博三'
        elseif normalized =~# '十\|10'
            return '博十'
        elseif normalized =~# '一\|1'
            return '博一'
        elseif normalized =~# '二\|2'
            return '博二'
        elseif normalized =~# '七\|7'
            return '博七'
        elseif normalized =~# '九\|9'
            return '博九'
        endif
    endif

    if normalized =~# '主'
        return '主'
    endif

    if normalized =~# '淘'
        return '淘'
    endif

    if normalized =~# '进取'
        return '进取'
    endif

    if normalized =~# '成长'
        return '成长'
    endif

    if normalized =~# '稳健'
        return '稳健'
    endif

    if normalized =~# '智\|专享'
        if normalized =~# '一\|1'
            return '智选1'
        elseif normalized =~# '二\|2'
            return '智选2'
        elseif normalized =~# '三\|3'
            return '智选3'
        elseif normalized =~# '六\|6'
            return '智选6'
        elseif normalized =~# '九\|9'
            return '智选9'
        endif
    endif

    " 未匹配到任何规则
    echohl WarningMsg
    echomsg '警告: 未能标准化产品名 - ' . a:name
    echohl None

    return a:name
endfunction
