#!/usr/bin/env bash
IFS=$'\n\t'

if (xmodmap -pke | grep -F '38 = a' > /dev/null); then
    echo 'keycode 38 = 1
        keycode 39 = 2
        keycode 40 = 3
        keycode 41 = 4
        keycode 42 = 5
        keycode 43 = 6
        keycode 44 = 7
        keycode 45 = 8
        keycode 46 = 9
        keycode 47 = 0' | xmodmap -
    notify-send --urgency low \
        --hint string:x-canonical-private-synchronous:volume \
        -t 400 "NumLock on"
else
    echo 'keycode 38 = a A
        keycode 39 = s S
        keycode 40 = d D
        keycode 41 = f F
        keycode 42 = g G
        keycode 43 = h H
        keycode 44 = j J
        keycode 45 = k K
        keycode 46 = l L
        keycode 47 = semicolon colon' | xmodmap -
    notify-send --urgency low \
        --hint string:x-canonical-private-synchronous:volume \
        -t 400 "NumLock off"
fi
