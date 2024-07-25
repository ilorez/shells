#!/bin/bash

# Default action for turning the projector on
action="on"
position="--left-of"
resolution="--mode 1920x1080"

# Parse arguments
if [[ $1 == "off" ]]; then
  action="off"
elif [[ $1 == "on" ]]; then
  action="on"
  # Check for position argument
  if [[ $2 == "left" ]]; then
    position="--left-of"
  elif [[ $2 == "right" ]]; then
    position="--right-of"
  elif [[ $2 == "above" ]]; then
    position="--above"
  elif [[ $2 == "under" ]]; then
    position="--below"
  else
    position="--left-of" # Default position
  fi
  # Check for resolution argument
  if [[ -n $3 ]]; then
    if [ $3 == "auto" ]; then
      resolution="--auto"
    else
      resolution="--mode $3"
    fi
  fi
fi

if [[ $action == "off" ]]; then
  xrandr --output HDMI-1 --off --output LVDS-1 --auto
elif [[ $action == "on" ]]; then
  xrandr --output HDMI-1 $position LVDS-1 $resolution
fi
