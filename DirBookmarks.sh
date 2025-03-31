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

while true; do
  sort -u "$dirFileName" -o "$dirFileName"

  dirs=$(cat "$dirFileName")

  dir=$(echo -e "$dirs" | fzf --border --reverse --prompt "Directory: " --preview "tree -C {}" --preview-window "down,70%,border-top,+{2}+3/3,~3")
  [[ -z "$dir" ]] && exit 0
  program=$(echo -e "cd\nranger\ntmux\nnvim\ncode\nzeditor\nremove-bookmark" | fzf --border --reverse --prompt "Program: ")

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
    "cd")
      /bin/bash
      ;;
    *)
      "$program" "$dir"
      ;;
  esac
done 
