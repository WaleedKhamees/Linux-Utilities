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

file=$(echo -e "$files" | fzy)
[[ -z "$file" ]] && exit 0

cd "$file"

nvim "$file"
