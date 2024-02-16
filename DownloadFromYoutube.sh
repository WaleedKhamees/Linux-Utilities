#!/bin/sh

ytdlp="yt-dlp --embed-metadata --embed-chapters"
option=$(echo -e "Video\nPlaylist" | dmenu -p "What do you want to download?")
download_video() {
  url=$(xclip -o clipboard)
  quality=$(echo -e "high\nmedium\naudio" | dmenu -p "Choose quality?")
  case $quality in 
    "high")
      st -e sh -c "$ytdlp -f 22 -o \"Videos/%(title)s.%(ext)s\" $url;read"
      ;;
    "medium")
      st -e sh -c "$ytdlp -f 18 -o \"Videos/%(title)s.%(ext)s\" $url;read"
      ;;
    "audio")
      st -e sh -c "$ytdlp -f 250 -o \"Audio/%(title)s.%(ext)s\" $url;read"
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
        st -e sh -c "$ytdlp --yes-playlist -f 22 -o \"Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s\" $url"
      elif [ -z $to ]; then 
        st -e sh -c "$ytdlp --yes-playlist -f 22 -o \"Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s\" --playlist-start $from $url"
      else 
        st -e sh -c "$ytdlp --yes-playlist -f 22 -o \"Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s\" --playlist-start $from --playlist-end $to $url"
      fi
      ;;
    "medium")
      if [ -z $from ]; then 
        st -e sh -c "$ytdlp --yes-playlist -f 18 -o \"Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s\" $url"
      elif [ -z $to ]; then 
        st -e sh -c "$ytdlp --yes-playlist -f 18 -o \"Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s\" --playlist-start $from $url"
      else 
        st -e sh -c "$ytdlp --yes-playlist -f 18 -o \"Videos/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s\" --playlist-start $from --playlist-end $to $url"
      fi
      ;;
    "audio")
      if [ -z $from ]; then 
        st -e sh -c "$ytdlp --yes-playlist -f 250 -o \"Audio/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s\" $url"
      elif [ -z $to ]; then 
        st -e sh -c "$ytdlp --yes-playlist -f 250 -o \"Audio/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s\" --playlist-start $from $url"
      else 
        st -e sh -c "$ytdlp --yes-playlist -f 250 -o \"Audio/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s\" --playlist-start $from --playlist-end $to $url"
      fi
      ;;
  esac
}



case $option in 
  "Video")
    download_video
    ;;
  "Playlist")
    download_playlist
    ;;

esac
