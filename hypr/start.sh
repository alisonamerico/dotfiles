#!/usr/bin/env bash

# initializing wallpaper daemon
swww init &
# setting wallpaper
swww img ~/Pictures/Wallpapers/city.jpg &

# you can install this by adding
# pkgs.networkmanagerapplet to your packages
nm-applet --indicator &

# the bar
waybar &

# dnust
dnust
