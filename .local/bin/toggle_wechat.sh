#!/bin/bash

# 获取可见窗口数量
COUNT=$(xdotool search --onlyvisible --class "wechat" | wc -l)

case $COUNT in
    0)
        # 状态：未启动
        # 动作：启动 WeChat
        wechat &
        ;;
    1)
        # 状态：最小化/隐藏 (只有托盘图标)
        # 动作：找到所有窗口，激活主窗口 (托盘图标通常无法被 windowactivate，所以会激活主窗口)
        WIN_ID=$(xdotool search --onlyvisible --class "wechat" | head -n 1)
        xdotool click --window "$WIN_ID" 1
        ;;
    2)
        # 状态：显示中 (托盘 + 主窗口)
        # 动作：找到可见窗口，最小化 (会最小化主窗口，忽略托盘图标)
        WIN_ID=$(xdotool search --onlyvisible --class "wechat" | head -n 1)
        eval $(xdotool getmouselocation --shell | sed 's/^/MOUSE_/')
        eval $(xdotool getwindowgeometry --shell $WIN_ID)
        xdotool mousemove --window $WIN_ID $((WIDTH - 15)) 15 click 1
        xdotool mousemove $MOUSE_X $MOUSE_Y
        ;;
esac
