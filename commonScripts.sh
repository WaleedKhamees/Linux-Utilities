#!/bin/bash

functions="merge SRT with MP4\nreplace character in filename with another character"

merge () { 
  current_dir=$(pwd)
  
  files=$(ls | grep -E '\.srt$|\.vtt$')

  selection=$(echo -e "$files" | fzf --reverse --height 40%)

  if [[ -z "$selection" ]]; then
    echo "No file selected."
    exit 1
  fi

  extension="${selection##*.}"
  filename="${selection%.*}"

  echo "Selected file: $filename.$extension"

  if [ "$extension" == "vtt" ]; then
    ffmpeg -i "$selection" "${filename}.srt"
  fi

  srt="${filename}.srt"
  mp4="${filename}.mp4"

  if [ ! -f "$mp4" ]; then
    echo "Error: Corresponding MP4 file ($mp4) not found."
    exit 1
  fi

  ffmpeg -i "$mp4" -i "$srt" -c copy -c:s srt "${filename}.mkv"

  read -p "Do you want to delete the original files? [y/n]: " -r reply

  if [ "$reply" == "y" ]; then
    rm "$mp4" "$srt"
    [ "$extension" == "vtt" ] && rm "$selection"  # Remove original VTT if converted
  fi
}

replaceCharInFilenameWithAnotherChar() {
  read -p "Enter the character you want to replace: " -r char1
  read -p "Enter the character you want to replace with: " -r char2

  for file in *$char1*; do
    mv "$file" "${file//$char1/$char2}"
  done
}

function_selected=$(echo -e "$functions" | fzf --reverse --height 40%)

case $function_selected in 
  "merge SRT with MP4")
    merge 
    ;;
  "replace character in filename with another character")
    replaceCharInFilenameWithAnotherChar
    ;;
esac

