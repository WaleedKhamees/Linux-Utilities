#!/bin/bash

# Ask for a song name
song=$(dmenu -p "What song do you want to download (spotdl)?" < /dev/null)
[ -z "$song" ] && exit 1

# Choose directory inside ~/Music
music_target=$(find "$HOME/Music" -type d | dmenu -i -p "Choose a directory inside Music")
[ -z "$music_target" ] && exit 1

# Run spotdl in a terminal
st -e sh -c "spotdl \"$song\" --output \"$music_target\""

