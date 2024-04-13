#!/bin/sh 

# regex="^$HOME/(Audio|Music|workshop|shows).*"
# target=$(plocate -0 --regex "$regex" | xargs -0 dirname | uniq | fzf --border --preview "tree -C {}" --preview-window "up,40%,border-bottom,+{2}+3/3,~3")

if [ -z "pgrep -f updatedb" ]; then
    sudo setsid updatedb & disown
fi

st -e sh -c '
where=$(echo -e "special\nall" | fzf --border)
case $where in
    "special")
        regex="^$HOME/(workshop"
        directories=$(cat $HOME/dotfiles/Linux-Utilities/dirs.txt)
        for dir in $directories; do
            regex="$regex|$dir"
        done
        regex="$regex).*"
        target=$(plocate -0 --regex "$regex" | xargs -0 dirname | uniq | fzf --border --preview "tree -C {}" --preview-window "up,40%,border-bottom,+{2}+3/3,~3")
    ;;
    "all")
        target=$(locate -0 . | xargs -0 dirname | uniq | fzf --border --preview "tree -C {}" --preview-window "up,60%,border-bottom,+{2}+3/3,~3");
    ;;
esac

if [ -z "$target" ]; then
    exit 0;
fi 

program=$(echo -e "ranger\nnvim\ncode" | fzf --border);
cd "$target";
if [ "$program" = "nvim" ]; then
  tmux new-session -d -s "edit" "exec /bin/bash -c nvim"
  tmux attach-session -t "edit"
fi

$program .;
if [ "$program" != "code" ]; then
  exec /bin/bash
fi
'
