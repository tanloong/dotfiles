#!/bin/sh

xset -b
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
[ -f ~/.Xresources ] && xrdb -merge -I$HOME ~/.Xresources

slstatus &

dunst &
# blueman-applet &
nm-applet &

# For awesome: comment out this line, the wallpaper is handled in ~/.config/awesome/default/theme.lua
# For dwm: uncomment this line
# feh --bg-scale /home/tan/.local/share/wallpapers/brad-huchteman-stone-mountain.resized.jpg

# picom -c > /dev/null 2>&1 &
flameshot & > /dev/null 2>&1

fcitx5 --replace > /dev/null 2>&1 &
# ibus-daemon -rxRd

remap 2> /dev/null
killall $TERMINAL > /dev/null 2>&1 || :
setsid -f $TERMINAL
goldendict &

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# exec startdwm.sh
# exec dwm
exec awesome
