#!/bin/sh


emoji=$(dmenu-emoji | dmenu -i -l 5 | awk '{print $1}' | tr -d '\r\n')
echo $emoji | tr -d "\n" | xclip -selection clipboard
xdotool type --delay 0 "$emoji"

