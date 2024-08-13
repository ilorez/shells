#!/bin/bash
# clear console
clear

# test if write_my_name.sh is found and executable
#  if not found, exit with nothing
#  if found run command
if [ -x ./write_my_name.sh ]; then
  ./write_my_name.sh -n "Projector" -f standard -nfn -c cyan
fi

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
  echo "Turning the projector off..."
  xrandr --output HDMI-1 --off --output LVDS-1 --auto
elif [[ $action == "on" ]]; then
  echo "Turning the projector on"
  echo "- position: $position"
  echo "- resolution: $resolution"
  xrandr --output HDMI-1 $position LVDS-1 $resolution
fi
