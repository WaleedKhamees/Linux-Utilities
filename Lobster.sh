#!/bin/sh


previous_show=$(cat /tmp/lobster_script.txt | uniq | sort)
show=$(echo -e "$previous_show" | dmenu -p "What is the show?" -l 3 )
[ -z "$show" ] && exit 1
language=$(echo -e "english\ngerman" | dmenu -p "What is the language?" )
[ -z "$language" ] && exit 1
quality=$(echo -e "720\n360" | dmenu -p "what is the quality?")
[ -z "$quality" ] && exit 1

mp="$(find shows* -type d | dmenu -i -p "Where do you want it saved?")" || exit 1
test -z "$mp" && exit 1

if [ ! -d "$mp" ]; then
  mkdiryn=$(printf "No\\nYes" | dmenu -i -p "$mp does not exist. Create it?") || exit 1
  [ "$mkdiryn" = "Yes" ] && (mkdir -p "$mp" || sudo -A mkdir -p "$mp")
fi

if [[ -n $show ]]; then
  if [[ -n $mp ]]; then
    cd "$mp"
  fi
  command="lobster \"$show\" -d -l $language -q $quality"

  echo -e "$show" >> /tmp/lobster_script.txt

  st -e sh -c "$command"
fi
