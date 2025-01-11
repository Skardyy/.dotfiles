#!/bin/sh

# checks for hyprpaper as indicator
while ! pgrep -x "waybar" > /dev/null; do
    (nohup waybar &> /dev/null) &
    sleep 1
done
# (nohup waybar &> /dev/null) &
