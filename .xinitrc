#!/bin/sh
xset -b
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
[ -f ~/.Xresources ] && xrdb -merge -I$HOME ~/.Xresources

slstatus &

imwheel > /dev/null 2>&1 &
/home/tan/.local/bin/fix-touchpad &

dunst &
# blueman-applet &
nm-applet --no-agent &
feh --bg-scale /home/tan/.local/share/wallpapers/brad-huchteman-stone-mountain.resized.jpg
# picom -c > /dev/null 2>&1 &
flameshot & > /dev/null 2>&1

hostname=$(hostnamectl hostname)
ln --symbolic --force ~/.Xmodmap-"${hostname}" ~/.Xmodmap 
# /etc/X11/xinit/xinitrc 会加载 $HOME/.Xmodmap 文件
ln --symbolic --force ~/.Xresources-"${hostname}" ~/.Xresources

fcitx5 > /dev/null 2>&1 &

killall st > /dev/null 2>&1 || :
setsid -f st
goldendict &
"$HOME/software/Clash for Windows-0.20.10-x64-linux/cfw" &
exec dwm
# exec i3
