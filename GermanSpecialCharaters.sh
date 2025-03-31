#!/bin/sh





# print special german characters

char=$(echo -e "ß\nä\nö\nü" | dmenu -i -l 4 -p "German characters" | tr -d "\r\n")
xdotool type --delay 0 $char
# | xclip -selection clipboard
