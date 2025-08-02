
#!/bin/bash

# Function to increase the audio volume by a given percentage
increase_volume() {
  pactl set-source-volume @DEFAULT_SOURCE@ +$1%
}

# Function to decrease the audio volume by a given percentage
decrease_volume() {
  pactl set-source-volume @DEFAULT_SOURCE@ -$1%
}

# Function to toggle mute/unmute
toggle_mute() {
  pactl set-source-mute @DEFAULT_SOURCE@ toggle
}

case "$1" in
  "up")
    increase_volume 5
    echo "Increased audio by 5%."
    ;;
  "down")
    decrease_volume 5
    echo "Decreased audio by 5%."
    ;;
  "toggle")
    toggle_mute
    echo "Toggled mute/unmute."
    ;;
esac

pkill -RTMIN+10 dwmblocks
