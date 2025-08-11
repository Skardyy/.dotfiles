#!/bin/bash
WALLPAPER_DIR="$HOME/Desktop/assests-git/"

menu() {
  find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -printf "%f\n" | sort
}

main() {
  choice=$(menu | walker --dmenu)

  if [ -n "$choice" ]; then
    selected_wallpaper="${WALLPAPER_DIR}${choice}"

    # Check if file exists
    if [ -f "$selected_wallpaper" ]; then
      swww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5
      notify-send "Wallpaper Changed" "$choice"
    else
      notify-send "Error" "Wallpaper file not found: $choice"
    fi
  fi
}

main
