#!/bin/sh

setxkbmap -query | grep -q 'ara' && setxkbmap us || setxkbmap ara

kill -39 $(pidof dwmblocks) 
