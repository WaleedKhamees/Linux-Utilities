#!/bin/sh





# print special german characters

echo -e "ß\nä\nö\nü" | dmenu -i -l 4 -p "German characters" | tr -d "\r\n" | xclip -selection clipboard
