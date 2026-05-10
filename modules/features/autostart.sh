#!/bin/sh
dunst &
picom --experimental-backends -b &
# Set solid background if no wallpaper found
xsetroot -solid "#1E1E2E"
