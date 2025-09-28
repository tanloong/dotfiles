@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo 用法: %0 文件名
    exit /b 1
)

set "filename=%~1"
set "basename=%~n1"
set "filepath=%~dp1"

rem 检查文件是否存在
if not exist "!filename!" (
    echo 文件不存在: !filename!
    exit /b 1
)

rem 根据文件扩展名决定打开什么
if /i "%~x1"==".tex" goto open_pdf
if /i "%~x1"==".sil" goto open_pdf
if /i "%~x1"==".typ" goto open_pdf
if /i "%~x1"==".m" goto open_pdf
if /i "%~x1"==".md" goto open_pdf
if /i "%~x1"==".dse" goto open_pdf
if /i "%~x1"==".Rmd" goto open_pdf
if /i "%~x1"==".txt" goto open_pdf
if /i "%~x1"==".mom" goto open_pdf

rem 处理单字符扩展名（如 .1, .2 等）
if "%~x1" neq "" (
    set "ext=%~x1"
    if "!ext:~1!" geq "0" if "!ext:~1!" leq "9" if "!ext:~2!"=="" goto open_pdf
)

if /i "%~x1"==".srt" goto open_mp4
if /i "%~x1"==".ass" goto open_mp4
if /i "%~x1"==".html" goto open_html

rem 如果没有匹配的类型，显示错误信息
echo 不支持的文件类型: %filename%
exit /b 1

:open_pdf
if exist "!filepath!!basename!.pdf" (
    start "" "!filepath!!basename!.pdf"
) else (
    echo PDF文件不存在: !filepath!!basename!.pdf
)
exit /b 0

:open_mp4
if exist "!filepath!!basename!.mp4" (
    start "" "!filepath!!basename!.mp4"
) else (
    echo MP4文件不存在: !filepath!!basename!.mp4
)
exit /b 0

:open_html
if exist "!filepath!!basename!.html" (
    start "" "!filepath!!basename!.html"
) else (
    echo HTML文件不存在: !filepath!!basename!.html
)
exit /b 0
