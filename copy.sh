#!/bin/env bash

base="$HOME/dotfiles/Linux-Utilities/"
file="$base/copy.txt"

choices=""

while IFS= read -r line; do
    choices="$choices\n$(echo "$line" | cut -f 1 -d '`')" 
done < "$file"

choices=${choices:2}


choice=$(echo -e $choices | dmenu -l 10 -p "What to copy?")

[[ -z $choice ]] && exit 1

link=$(grep -m1 -F "$choice" "$file" | cut -f 2 -d '`')
echo $link | xclip -selection clipboard 
xdotool type --delay 0 "$link" 
