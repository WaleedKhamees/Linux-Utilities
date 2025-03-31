#!/bin/sh

ytdlp="yt-dlp --embed-metadata --embed-chapters -N 4"
option=$(echo -e "Video\nPlaylist" | dmenu -p "What do you want to download?")
TERMINAL="st -c \"centered\" -e"
download_video() {
  url=$(xclip -o clipboard)
  quality=$(echo -e "high\nmedium\naudio" | dmenu -p "Choose quality?")
  case $quality in 
    "high")
      $TERMINAL $ytdlp -f 136+140 -o "Videos/%(title)s.%(ext)s" $url
      ;;
    "medium")
      $TERMINAL $ytdlp -f 18 -o "Videos/%(title)s.%(ext)s" $url
      ;;
    "audio")
      $TERMINAL $ytdlp -x --audio-format mp3 -o "Audio/%(title)s.%(ext)s" $url
      ;;
  esac
}
download_playlist() {
  quality=$(echo -e "high\nmedium\naudio" | dmenu -p "Choose quality?")
  url=$(xclip -o clipboard)
  from=$(dmenu -p "From what video" < /dev/null)
  to=$(dmenu -p "To what video" < /dev/null)
  case $quality in 
    "high")
      if [ -z $from ]; then 
        $TERMINAL $ytdlp --yes-playlist -f 136+140 -o "Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" $url
      elif [ -z $to ]; then 
        $TERMINAL $ytdlp --yes-playlist -f 136+140 -o "Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" --playlist-start $from $url
      else 
        $TERMINAL $ytdlp --yes-playlist -f 136+140 -o "Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" --playlist-start $from --playlist-end $to $url
      fi
      ;;
    "medium")
      if [ -z $from ]; then 
        $TERMINAL $ytdlp --yes-playlist -f 18 -o "Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" $url
      elif [ -z $to ]; then 
        $TERMINAL $ytdlp --yes-playlist -f 18 -o "Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" --playlist-start $from $url
      else 
        $TERMINAL $ytdlp --yes-playlist -f 18 -o "Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" --playlist-start $from --playlist-end $to $url
      fi
      ;;
    "audio")
      if [ -z $from ]; then 
        $TERMINAL $ytdlp --yes-playlist -f 250 -o "Audio/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" $url
      elif [ -z $to ]; then 
        $TERMINAL $ytdlp --yes-playlist -f 250 -o "Audio/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" --playlist-start $from $url
      else 
        $TERMINAL $ytdlp --yes-playlist -f 250 -o "Audio/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s" --playlist-start $from --playlist-end $to $url
      fi
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

