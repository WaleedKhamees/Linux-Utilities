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


mode=$(echo -e "Select\nWindow\nAll" | dmenu -p "ScreenShot Away!")

[ -z "$mode" ] && exit 1

save=$(echo -e "No\nYes" | dmenu -p "save screenshot?")

[ -z "$save" ] && exit 1


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


case "$mode" in
	"Window")
			maim -s "$file"
		;;
	"Select")
     flameshot gui -r | xclip -selection clipboard -t image/png
			# maim -s -c 0.41,0.62,0.42,0.2 -l -u "$file"
		;;
	*)
			maim "$file"
		;;
esac



xclip -selection clipboard -t image/png -o > $file
[[ "$save" == "No" ]] && rm "$file" 
