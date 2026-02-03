#!/bin/bash

path="$HOME/screenshots"
filename="$(date +"%Y-%m-%dT%H-%M-%SZ").png"
file="${path}/${filename}"

maim "$file"
xclip -selection clipboard -t image/png "$file"
