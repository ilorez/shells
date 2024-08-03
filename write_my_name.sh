#!/bin/bash

# Function to check if figlet is installed
check_figlet() {
  if ! command -v figlet &>/dev/null; then
    echo "figlet is not installed. Please install it and try again."
    exit 1
  fi
}

# Function to display name in a specific font
display_in_font() {
  local name=$1
  local font=$2
  echo "Font: $font"
  echo "======================"
  figlet -f "$font" "$name" || echo "Font '$font' not found."
  echo "======================"
}

# Function to display name in all available fonts
display_in_all_fonts() {
  local name=$1
  for font in $(figlist | grep -v "Figlet fonts in"); do
    display_in_font "$name" "$font"
  done
}

# Main script
main() {
  check_figlet

  local name=""
  local font=""
  local all_fonts=false

  # Parse command line arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
    -n | --name)
      name="$2"
      shift 2
      ;;
    -f | --font)
      font="$2"
      shift 2
      ;;
    --all)
      all_fonts=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
    esac
  done

  # If name is not provided, ask for it
  if [[ -z "$name" ]]; then
    read -p "Enter your name: " name
  fi

  # If neither font nor all_fonts is specified, ask for font
  if [[ -z "$font" ]] && [[ "$all_fonts" == false ]]; then
    read -p "Enter the font name (or 'all' for all fonts): " font
    if [[ "$font" == "all" ]]; then
      all_fonts=true
    fi
  fi

  # Display name in specified font(s)
  if [[ "$all_fonts" == true ]]; then
    display_in_all_fonts "$name"
  elif [[ -n "$font" ]]; then
    display_in_font "$name" "$font"
  else
    echo "No font specified. Using default font."
    display_in_font "$name" "standard"
  fi
}

main "$@"
