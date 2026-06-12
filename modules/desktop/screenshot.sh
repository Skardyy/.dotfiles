#!/usr/bin/env sh
if [ "$1" = "edit" ]; then
  grim -g "$(slurp)" - | satty -f -
else
  grim -g "$(slurp)" - | wl-copy
fi
