#!/bin/sh

# checks for hyprpaper as indicator
while ! pgrep -x "waybar" > /dev/null; do
    sleep 2
    (nohup waybar &> /dev/null) &
done
