#!/bin/bash
# Function to check if figlet is installed
check_figlet() {
  if ! command -v figlet &>/dev/null; then
    echo "figlet is not installed. Please install it and try again."
    exit 1
  fi
}

# Function to get the directory of figlet fonts
get_fonts_dir() {
  figlet -I2
}

# Function to get the list of available fonts
get_available_fonts() {
  local fonts_dir
  fonts_dir=$(get_fonts_dir)
  find "$fonts_dir" -type f -name "*.flf" -exec basename {} .flf \;
}

# Function to display name in a specific font with color
display_in_font() {
  local name=$1
  local font=$2
  local no_font_name=$3
  local color=$4

  if [[ "$no_font_name" == false ]]; then
    echo -e "${color}Font: $font"
    echo "======================"
  fi

  figlet -f "$font" "$name" | while IFS= read -r line; do echo -e "${color}${line}"; done || echo "Font '$font' not found."

  if [[ "$no_font_name" == false ]]; then
    echo "======================"
  fi
}

# Function to display name in all available fonts with color
display_in_all_fonts() {
  local name=$1
  local color=$2
  local fonts
  fonts=$(get_available_fonts)
  for font in $fonts; do
    display_in_font "$name" "$font" false "$color"
  done
}

# Function to map color names to ANSI escape codes
get_color_code() {
  local color=$1
  case $color in
  black) echo "\033[0;30m" ;;
  red) echo "\033[0;31m" ;;
  green) echo "\033[0;32m" ;;
  yellow) echo "\033[0;33m" ;;
  blue) echo "\033[0;34m" ;;
  purple) echo "\033[0;35m" ;;
  cyan) echo "\033[0;36m" ;;
  white) echo "\033[0;37m" ;;
  *) echo "\033[0m" ;; # Default to no color
  esac
}

# Main script
main() {
  check_figlet

  local name=""
  local font=""
  local all_fonts=false
  local no_font_name=false
  local color="\033[0m" # Default to no color

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
    -nfn | --no-font-name)
      no_font_name=true
      shift
      ;;
    --all)
      all_fonts=true
      shift
      ;;
    -c | --color)
      color=$(get_color_code "$2")
      shift 2
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

  # Display name in specified font(s) with color
  if [[ "$all_fonts" == true ]]; then
    display_in_all_fonts "$name" "$color"
  elif [[ -n "$font" ]]; then
    display_in_font "$name" "$font" "$no_font_name" "$color"
  else
    echo -e "No font specified. Using default font."
    display_in_font "$name" "standard" "$no_font_name" "$color"
  fi

  # Reset color at the end
  echo -e "\033[0m"
}

main "$@"
