#!/bin/sh
xset -b
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

slstatus &

imwheel > /dev/null 2>&1 &
/home/tan/.local/bin/fix-touchpad &

twmnd &
blueman-applet &
nm-applet &
feh --bg-scale /home/tan/.local/share/wallpapers/brad-huchteman-stone-mountain.resized.jpg
picom -c > /dev/null 2>&1 &
flameshot & > /dev/null 2>&1
# redshift & > /dev/null 2>&1

[ -z $(ps -ef | grep -w goldendict | grep -v grep) ] && goldendict &

# /etc/X11/xinit/xinitrc 会加载 $HOME/.Xmodmap 文件
if [[ `hostnamectl --static` == "ideapad320" ]]; then
    [[ -f ~/.xmodmap_lenovo ]] && ln --symbolic --force ~/.xmodmap_lenovo ~/.Xmodmap
elif [[ `hostnamectl --static` == "bike" ]]; then
    [[ -f ~/.xmodmap_thinkpadx220i ]] && ln --symbolic --force ~/.xmodmap_thinkpadx220i ~/.Xmodmap
fi
fcitx5 & > /dev/null 2>&1

killall st > /dev/null 2>&1 || :
setsid -f st
exec dwm
