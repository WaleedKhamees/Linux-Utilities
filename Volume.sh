#!/bin/bash

status="$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d " " -f2)"
volume_percentage="$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | cut -d $'\n' -f1)"
volume="${volume_percentage%\%}"

# Function to toggle mute/unmute
toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    s=""
    case "$status" in
        "yes")
            s="Not muted"
            ;;
        "no")
            s="Muted"
            ;;
    esac
    notify-send -u low -t 1000 "Volume" "Audio is now ${s}"
}

# Function to increase the audio volume by a given percentage
increase_volume() {
  [ $status = "yes" ] && toggle_mute
  future_volume="$(expr "$volume" + "5")"
  [ $future_volume -le 100 ] && pactl set-sink-volume @DEFAULT_SINK@ +$1%
  [ $future_volume -gt 100 ] && pactl set-sink-volume @DEFAULT_SINK@ 100%
}

# Function to decrease the audio volume by a given percentage
decrease_volume() {
  [ $status = "yes" ] && toggle_mute
  pactl set-sink-volume @DEFAULT_SINK@ -$1%
}


case "$1" in
    "up")
        increase_volume 5
        ;;
    "down")
        decrease_volume 5
        ;;
    "toggle")
        toggle_mute
        ;;
esac
pkill -RTMIN+10 dwmblocks

