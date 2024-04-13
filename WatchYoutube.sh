#!/bin/sh



quality=$(echo -e "360p\n720p\n1080p" | dmenu -i -p "Select quality")
url=$(xclip -o)

[ -z "$quality" ] && exit 1
[ -z "$url" ] && exit 1



if [ "$quality" = "360p" ]; then
    mpv --ytdl-format="best[height<=360]" "$url"
elif [ "$quality" = "720p" ]; then
    mpv --ytdl-format="best[height<=720]" "$url"
elif [ "$quality" = "1080p" ]; then
    mpv --ytdl-format="best[height<=1080]" "$url"
fi
