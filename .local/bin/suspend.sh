#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# 如果已经有zenity进程说明可能是连续误触休眠按钮，直接退出，防止重复弹出zenity窗口
if [ -n "$(pgrep zenity)" ]; then
    exit 1
fi

zenity --question --title='' --text='确认休眠吗？' --width=200
if [ "$?" -eq 0 ]; then
  systemctl suspend
fi
