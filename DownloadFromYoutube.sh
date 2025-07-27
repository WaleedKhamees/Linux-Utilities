#!/bin/sh

ytdlp="yt-dlp --embed-metadata --embed-chapters --write-subs --embed-subs --sub-lang \"en.*,live_chat\" --merge-output-format mkv -N 4"
option=$(echo -e "Video\nPlaylist" | dmenu -p "What do you want to download?")

download_video() {
  url=$(xclip -o clipboard)
  quality=$(echo -e "high\nmedium\naudio" | dmenu -p "Choose quality?")
  case "$quality" in 
    "high")
      $ytdlp -f "bv*[height<=720]+ba/best" -o "Videos/%(title)s.%(ext)s" "$url"
      ;;
    "medium")
      $ytdlp -f "bv*[height<=360]+ba[abr<=128]/b[height<=360]" -o "Videos/%(title)s.%(ext)s" "$url"
      ;;
    "audio")
      $ytdlp -f "bestaudio[abr<=128]" -x --audio-format m4a -o "Audio/%(title)s.%(ext)s" "$url"
      ;;
  esac
}

download_playlist() {
  quality=$(echo -e "high\nmedium\naudio" | dmenu -p "Choose quality?")
  url=$(xclip -o clipboard)
  from=$(dmenu -p "From what video" < /dev/null)
  to=$(dmenu -p "To what video" < /dev/null)

  playlist_opts=""
  [ -n "$from" ] && playlist_opts="$playlist_opts --playlist-start $from"
  [ -n "$to" ] && playlist_opts="$playlist_opts --playlist-end $to"

  case "$quality" in 
    "high")
      $ytdlp --yes-playlist -f "bv*[height<=720]+ba/best" $playlist_opts -o "Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" "$url"
      ;;
    "medium")
      $ytdlp --yes-playlist -f "bv*[height<=360]+ba[abr<=128]/b[height<=360]" $playlist_opts -o "Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" "$url"
      ;;
    "audio")
      $ytdlp --yes-playlist -f "bestaudio[abr<=128]" -x --audio-format m4a $playlist_opts -o "Audio/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" "$url"
      ;;
  esac
}

case $option in 
  "Video")
    download_video
    notify-send "Downloaded" "Downloaded the video"
    ;;
  "Playlist")
    download_playlist
    notify-send "Downloaded" "Downloaded the playlist"
    ;;
esac

