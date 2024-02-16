#!/bin/bash

# A simple wrapper around maim
#
# When run, the screenshot will be added to the clipboard
# The file path will be put in the primary selection
# Will create notification containing file path
#
# If you have a project specified, it will put the sceenshot in that folder instead of /tmp
#
# Relies on maim for taking screenshot
# If you give it the -o flag for ocr, it needs tesseract



path="$HOME/screenshots"
command -v maim > /dev/null && screenshooter="maim" || ( echo -n "You need to install maim\nhttps://github.com/naelstrof/maim" && exit 1 )
lastactionfile="${XDG_DATA_HOME:-$HOME/.local/share}/lastaction"

#If a project is set we will put screenshots in the project's folder
command -v project > /dev/null && project=$(project current --path)
if [ -n "$project" ]; then
	path="$project/screenshots"
	#Make the directory if it doesn't exist
	mkdir "$path" 2> /dev/null
fi

filename="$(date +"%Y-%m-%dT%H-%M-%SZ").png"
file="${path}/${filename}"


maim -s -c 0.41,0.62,0.42,0.2 -l -u "$file"



if [ -f "$file" ]; then
    tesseract $file $file &> /dev/null
    cat "${file}.txt" | xclip -selection clipboard
    rm $file "$file.txt"
fi

