#!/bin/bash


bookmarkFileName="$HOME/dotfiles/Linux-Utilities/FileBookmark.txt"

if [[ ! -f "$bookmarkFileName" ]]; then
  echo "File not found: $bookmarkFileName"
  exit 1
fi

if [[ ! -s "$bookmarkFileName" ]]; then
  echo "File is empty: $bookmarkFileName"
  exit 1
fi

sort -u "$bookmarkFileName" -o "$bookmarkFileName"

files=$(cat "$bookmarkFileName")

file=$(echo -e "$files" | fzf --reverse --border --prompt "File: " --preview "bat --color=always -n {}" --preview-window "down,70%,border-top,+{2}+3/3,~3")
[[ -z "$file" ]] && exit 0

cd $(dirname "$file")

nvim "$file"
