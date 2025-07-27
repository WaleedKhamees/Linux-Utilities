#!/bin/bash

remove() {
  local file="$1"
  local bookmarkFileName="$2"
  local pattern="\#$file#d"
  sed -i "$pattern" "$bookmarkFileName"
}

export FZF_PREVIEW_COLUMNS=$(tput cols)
export FZF_PREVIEW_LINES=$(tput lines)


bookmarkFileName="$HOME/dotfiles/Linux-Utilities/FileBookmark.txt"

choices="open\nremove\ndrag"

if [[ ! -f "$bookmarkFileName" ]]; then
  echo "File not found: $bookmarkFileName"
  exit 1
fi

if [[ ! -s "$bookmarkFileName" ]]; then
  echo "File is empty: $bookmarkFileName"
  exit 1
fi

while true; do 

sort -u "$bookmarkFileName" -o "$bookmarkFileName"

files=$(cat "$bookmarkFileName")
previewCommand="
~/.config/ranger/scope.sh "{}" '$FZF_PREVIEW_COLUMNS' '$FZF_PREVIEW_LINES' /tmp/$file.jpg False
# img="/tmp/$(basename {})".jpg
#
# if [[ -f \"$img\" ]]; then
#   ueberzug layer --parser bash 2>/dev/null <<EOF
# {
#   'action': 'add',
#   'identifier': 'preview',
#   'x': 0,
#   'y': 0,
#   'width': '$FZF_PREVIEW_COLUMNS',
#   'height': '$FZF_PREVIEW_LINES',
#   'path': '$img'
# }
# EOF
# fi
"



file=$(echo -e "$files" | fzf --reverse --border --prompt "File: " --preview "$previewCommand" --preview-window "down,70%,border-top,+{2}+3/3,~3")
[[ -z "$file" ]] && exit 0

cd $(dirname "$file")

choice=$(echo -e "$choices" | fzf --reverse --border --prompt "Choice: " --height 10%)

if [ ! -f "$file" ]; then
  remove "$file" "$bookmarkFileName"
  continue
fi 


  case "$choice" in 
    "open")
      xdg-open "$file"
      ;;
    "remove")
      remove "$file" "$bookmarkFileName"
      ;;
    "drag")
      drag "$file"
      ;;
    *)
      notify-send "Invalid choice"
      exit 1
      ;;
  esac

done
