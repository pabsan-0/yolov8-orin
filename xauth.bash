# This script is meant to be sourced
# Use when working over ssh to docker-display stuff on a Jetson-plugged screen  

export DISPLAY=":1"
export XAUTHORITY="/run/user/1000/gdm/Xauthority"

