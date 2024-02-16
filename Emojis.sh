#!/bin/sh


dmenu-emoji | dmenu -i -l 5 | awk '{print $1}' | tr -d '\n' | xclip -selection clipboard
