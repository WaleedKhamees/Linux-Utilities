#!/bin/sh


# update /usr/share/applications/nvim.desktop
# TryExec=st -e nvim
# Exec=st -e nvim %F

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
        target=$(plocate --regex "$regex" | fzf --border --preview "bat --color=always -n {}" --preview-window "up,40%,border-bottom,+{2}+3/3,~3")
    ;;
    "all")
        target=$(locate . | fzf --border --preview "bat --color=always -n {}" --preview-window "up,40%,border-bottom,+{2}+3/3,~3")
    ;;
esac

dir=$(echo $target | xargs -0 dirname)
program=$(echo -e "xdg-open\nbookmark" | fzf --border)

cd "$dir"
if [ ! -f "$target" ]; then
    echo "File does not exist"
    exit 1
fi

case $program in
    "xdg-open")
        xdg-open "$target"
    ;;
    "bookmark")
        echo "$target" >> $HOME/dotfiles/Linux-Utilities/FileBookmark.txt
    ;;
esac

exit 1
'
