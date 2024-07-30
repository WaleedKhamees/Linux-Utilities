#!/bin/env bash

dirFileName="$HOME/dotfiles/Linux-Utilities/DirBookmarks.txt"

if [[ ! -f "$dirFileName" ]]; then
  echo "File not found: $dirFileName"
  exit 1
fi

if [[ ! -s "$dirFileName" ]]; then
  echo "File is empty: $dirFileName"
  exit 1
fi

sort -u "$dirFileName" -o "$dirFileName"

dirs=$(cat "$dirFileName")

dir=$(echo -e "$dirs" | fzy)
[[ -z "$dir" ]] && exit 0
program=$(echo -e "ranger\ntmux\nnvim\ncode\ncd\nzeditor\nremove-bookmark" | fzy)

if [[ -z "$dir" ]]; then
  exit 0
fi

cd "$dir"

case "$program" in
  "code" | "zeditor")
    "$program" "$dir"
    ;;
  "remove-bookmark")
    pattern="\#$dir#d"
    sed -i "$pattern" "$dirFileName"
    ;;
  "tmux")
    tmux new-session -d -s "edit" "exec /bin/bash -c nvim"
    tmux attach-session -t "edit"
    ;;
  *)
    "$program" "$dir"
    ;;
esac

