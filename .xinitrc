#!/bin/sh
xset -b
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

slstatus &

imwheel >> /dev/null 2>&1 &
/home/tan/.local/bin/fix-touchpad &

twmnd &
blueman-applet &
nm-applet &
feh --bg-scale /home/tan/.local/share/wallpapers/brad-huchteman-stone-mountain.resized.jpg
picom -c >> /dev/null 2>&1 &
flameshot & > /dev/null 2>&1
# redshift & > /dev/null 2>&1

[ -z $(ps -ef | grep -w goldendict | grep -v grep) ] && goldendict &

xmodmap /home/tan/.xmodmap_thinkpadx220i
fcitx5 & >> /dev/null 2>&1

killall st > /dev/null 2>&1 || :
setsid -f st
exec dwm
