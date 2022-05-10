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
# picom -c > /dev/null 2>&1 &
flameshot & > /dev/null 2>&1
# redshift & > /dev/null 2>&1

[ -z $(ps -ef | grep -w goldendict | grep -v grep) ] && goldendict &

# Host-specific configuration
case $(hostnamectl hostname) in
    bike)
        ln --symbolic --force ~/.xmodmap_thinkpadx220i ~/.Xmodmap # /etc/X11/xinit/xinitrc 会加载 $HOME/.Xmodmap 文件
        ln --symbolic --force ~/.Xresources_thinkpad220i ~/.Xresources;;
    ideapad320)
        ln --symbolic --force ~/.xmodmap_lenovo ~/.Xmodmap
        ln --symbolic --force ~/.Xresources_ideapad320 ~/.Xresources;;
    cup)
        ln --symbolic --force ~/.xmodmap_dell ~/.Xmodmap
        ln --symbolic --force ~/.Xresources_dell ~/.Xresources;;
esac

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
fcitx5 & > /dev/null 2>&1

killall st > /dev/null 2>&1 || :
setsid -f st
exec dwm
