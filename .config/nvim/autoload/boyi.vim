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
  $ ?^$? put=strftime('%Y%m%d', localtime()) . ' 昨日竞价进场今日上板票，开板后仍按涨停价计算主扶页面曲线:'
  %s/\v\s+$//

  call setcursorcharpos(1, 1)
  call setreg("+", getline(1))
endfunc

function! boyi#add_zhufu_ignore() abort
  v /\v\d/ d
  0 put='insert into zhufu_ignore (证券代码, 进场日期) values'
  2,$ s/\v.*/('&', '__DATE__'),/
  $ s/,$/;/
  let s:today_str = input("进场日期:", strftime("%Y%m%d", localtime()))
  %s/__DATE__/\=s:today_str/g
  call setreg("+", getline(1, '$'))
endfunc

function! boyi#add_wubo() abort
  normal! ggVG"cy
  enew
  normal! "cp
  v /\v^\d/ d
  0 put='insert into 吴博概念题材选股 (证券代码, 日期) values'
  2,$ s/\v^(\d+),.*/('\1', '__DATE__'),/
  $ s/,$/;/
  let s:yest_str = input("上一交易日:", boyi#get_yestraday())
  %s/__DATE__/\=s:yest_str/g
  call setreg("+", getline(1, '$'))
endfunc

" 产品名称标准化函数
function! boyi#normsimhold(name) abort
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
        elseif normalized =~# '十七\|17'
            return '博17'
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
        elseif normalized =~# '八\|8'
            return '智选8'
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

function! boyi#normsimcurve(name) abort
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
        return '扶摇'
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
        elseif normalized =~# '十七\|17'
            return '博17'
        elseif normalized =~# '十五\|15'
            return '博15'
        elseif normalized =~# '三\|3'
            return '博三'
        elseif normalized =~# '十\|10'
            return '博10'
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
        return '主升'
    endif

    if normalized =~# '淘'
        return '淘'
    endif

    if normalized =~# '进取'
        return '进取七'
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
        elseif normalized =~# '八\|8'
            return '智选8'
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

" 产品名称标准化函数
function! boyi#norm(name) abort
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
        return '扶摇五号'
    endif

    if normalized =~# '共'
        return '共赢二号'
    endif

    if normalized =~# '渭'
        if normalized =~# '十六\|16'
            return '渭16'
        elseif normalized =~# '11\|十一'
            return '渭11'
        elseif normalized =~# '12\|十二'
            return '渭12'
        elseif normalized =~# '五\|5'
            return '渭华翔五号'
        elseif normalized =~# '八\|8'
            return '渭华翔八号'
        elseif normalized =~# '六\|6'
            return '渭华翔六号'
        elseif normalized =~# '三\|3'
            return '渭华翔三号'
        endif
    endif

    if normalized =~# '博'
        if normalized =~# '十三\|13'
            return '博13'
        elseif normalized =~# '十七\|17'
            return '博17'
        elseif normalized =~# '十五\|15'
            return '博15'
        elseif normalized =~# '三\|3'
            return '博涵三号'
        elseif normalized =~# '十\|10'
            return '博10'
        elseif normalized =~# '一\|1'
            return '博涵一号'
        elseif normalized =~# '二\|2'
            return '博涵二号'
        elseif normalized =~# '七\|7'
            return '博涵七号'
        elseif normalized =~# '九\|9'
            return '博涵九号'
        endif
    endif

    if normalized =~# '主'
        return '主升一号'
    endif

    if normalized =~# '淘'
        return '淘股吧5号'
    endif

    if normalized =~# '进取'
        return '进取七号'
    endif

    if normalized =~# '成长'
        return '成长一号'
    endif

    if normalized =~# '稳健'
        return '稳健一号'
    endif

    if normalized =~# '智\|专享'
        if normalized =~# '一\|1'
            return '智选1号'
        elseif normalized =~# '二\|2'
            return '智选2号'
        elseif normalized =~# '三\|3'
            return '智选3号'
        elseif normalized =~# '六\|6'
            return '智选6号'
        elseif normalized =~# '八\|8'
            return '智选8号'
        elseif normalized =~# '九\|9'
            return '智选9号'
        endif
    endif

    " 未匹配到任何规则
    echohl WarningMsg
    echomsg '警告: 未能标准化产品名 - ' . a:name
    echohl None

    return a:name
endfunction

" 转换迅投委托单的账户名称
" Example: 渭华翔6号（平安）--> 平安渭六普
function! boyi#normwithbroker(name) abort
    " 1. 定义正则表达式
    " Python: r"^(?P<产品>[^)）]+)[(（](?P<券商>[^ )）]+?)\s*(?P<信用>信用)?(?:股票)?[)）]\s*$"
    " Vim: 使用 \( \) 进行捕获，\%(...) 进行非捕获，量词需要转义如 \+, \?
    let l:pattern = '^\([^)）]\+\)[(（]\([^ )）]\{-}\)\s*\(信用\)\?\%(股票\)\?[)）]\s*$'

    let l:match_list = matchlist(a:name, l:pattern)

    " 2. 匹配失败处理
    if empty(l:match_list)
        call v:lua.vim.notify('无法定位券商: ' . a:name, v:lua.vim.log.levels.ERROR)
        return a:name
    endif

    " matchlist 结果: [全匹配, 产品, 券商, 信用, ...]
    let l:acnt_raw = l:match_list[1]
    let l:broker = l:match_list[2]
    let l:credit = l:match_list[3]

    " 3. 标准化产品名
    let l:acnt = boyi#normsimcurve(l:acnt_raw)

    if l:acnt ==# ''
        call v:lua.vim.notify('无法标准化产品名: ' . a:name, v:lua.vim.log.levels.ERROR)
        return a:name
    endif

    " 4. 拼接结果
    if l:credit ==# '信用'
        return l:acnt . l:broker . '信'
    else
        return l:acnt . l:broker . '普'
    endif
endfunction
