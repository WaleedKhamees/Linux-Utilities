#!/bin/bash

status="$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')"
volume="$(pactl get-sink-volume @DEFAULT_SINK@ | awk 'NR==1{print $5}' | tr -d '%')"

toggle_mute() {
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    notify-send -u low -t 1000 "Volume" "Mute toggled"
}

increase_volume() {
    [ "$status" = "yes" ] && pactl set-sink-mute @DEFAULT_SINK@ 0

    if (( volume % 5 == 0 )); then
        new_volume=$(( volume + 5 ))
    else
        new_volume=$(( (volume / 5 + 1) * 5 ))
    fi

    (( new_volume > 100 )) && new_volume=100
    pactl set-sink-volume @DEFAULT_SINK@ "${new_volume}%"
}

decrease_volume() {
    [ "$status" = "yes" ] && pactl set-sink-mute @DEFAULT_SINK@ 0

    if (( volume % 5 == 0 )); then
        new_volume=$(( volume - 5 ))
    else
        new_volume=$(( (volume / 5) * 5 ))
    fi

    (( new_volume < 0 )) && new_volume=0
    pactl set-sink-volume @DEFAULT_SINK@ "${new_volume}%"
}

case "$1" in
    up)
        increase_volume
        ;;
    down)
        decrease_volume
        ;;
    toggle)
        toggle_mute
        ;;
esac

pkill -RTMIN+10 dwmblocks

