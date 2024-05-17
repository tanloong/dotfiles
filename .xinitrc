#!/bin/sh
xset -b
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
[ -f ~/.Xresources ] && xrdb -merge -I$HOME ~/.Xresources

slstatus &

dunst &
# blueman-applet &
nm-applet &
feh --bg-scale /home/tan/.local/share/wallpapers/brad-huchteman-stone-mountain.resized.jpg
# picom -c > /dev/null 2>&1 &
flameshot & > /dev/null 2>&1

fcitx5 --replace > /dev/null 2>&1 &
# ibus-daemon -rxRd

remap 2> /dev/null
killall $TERMINAL > /dev/null 2>&1 || :
setsid -f $TERMINAL
goldendict &
# exec startdwm.sh
exec dwm
